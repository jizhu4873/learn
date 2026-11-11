#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
encode.py —— 把任意类型文件转换成字符串，并切割成多个 TXT 文本文件。

做法：
  1. 以二进制读取源文件；
  2. 用 Base64 编码成纯 ASCII 字符串（可无损还原任何格式，且安全存放在 TXT 中）；
  3. 按 PART_SIZE 个字符（默认 50000，即约 50K）切分，依次写入
     00001.txt、00002.txt ……（文件名固定为 5 位数）；
  4. 额外生成 manifest.json 记录原始文件名、分片数量、编码方式与 SHA256 校验和，
     供 decode.py 无损还原。

用法：
  python encode.py <源文件> [--out-dir 输出目录] [--part-size 每片字符数]
"""

import os
import sys
import base64
import hashlib
import json
import argparse

PART_SIZE = 50000  # 每个 TXT 文件最多字符数（约 50K）


def write_part(out_dir, idx, text):
    path = os.path.join(out_dir, f"{idx:05d}.txt")
    with open(path, "w", encoding="utf-8") as f:
        f.write(text)


def encode(input_path, out_dir, part_size=PART_SIZE):
    if not os.path.isfile(input_path):
        raise FileNotFoundError(input_path)

    os.makedirs(out_dir, exist_ok=True)

    sha = hashlib.sha256()
    total_bytes = 0
    buf = ""          # 累积的 Base64 字符串
    part_index = 0    # 已写入的分片数

    with open(input_path, "rb") as f:
        # 每次读取 3 的倍数个字节：3 字节 -> 4 字符 Base64 且无填充。
        # 若按 65536（非 3 的倍数）读取，每块末尾会被塞入 "==" 填充符，
        # 拼接后这些 "==" 落在字符串中间，b64decode 会报 "Incorrect padding"。
        read_size = 3 * 21845  # 65535，3 的倍数
        while True:
            raw = f.read(read_size)     # 流式读取，避免大文件占用过多内存
            if not raw:
                break
            sha.update(raw)
            total_bytes += len(raw)
            buf += base64.b64encode(raw).decode("ascii")
            # 一旦缓冲超过一片大小，就写出若干完整分片
            while len(buf) >= part_size:
                part_index += 1
                write_part(out_dir, part_index, buf[:part_size])
                buf = buf[part_size:]

    # 剩余不足一片的内容，也要写出；空文件则至少写出一个空分片
    if buf or part_index == 0:
        part_index += 1
        write_part(out_dir, part_index, buf)

    manifest = {
        "original_name": os.path.basename(input_path),
        "total_parts": part_index,
        "encoding": "base64",
        "part_size": part_size,
        "original_size": total_bytes,
        "sha256": sha.hexdigest(),
    }
    manifest_path = os.path.join(out_dir, "manifest.json")
    with open(manifest_path, "w", encoding="utf-8") as f:
        json.dump(manifest, f, ensure_ascii=False, indent=2)

    return manifest


def main():
    p = argparse.ArgumentParser(description="把任意文件编码为多个 Base64 TXT 分片")
    p.add_argument("input", help="要转换的源文件")
    p.add_argument("--out-dir", default=None,
                   help="输出目录（默认与源文件同目录）")
    p.add_argument("--part-size", type=int, default=PART_SIZE,
                   help="每个 TXT 最大字符数，默认 50000（约 50K）")
    args = p.parse_args()

    out_dir = args.out_dir or os.path.dirname(os.path.abspath(args.input))
    manifest = encode(args.input, out_dir, args.part_size)

    print("编码完成：")
    print(f"  源文件   : {args.input}")
    print(f"  分片目录 : {out_dir}")
    print(f"  分片数量 : {manifest['total_parts']} 个（每个最多 {manifest['part_size']} 字符）")
    print(f"  原始大小 : {manifest['original_size']} 字节")
    print(f"  SHA256   : {manifest['sha256']}")


if __name__ == "__main__":
    main()
