#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
encode.py —— 把任意文件转成纯文本 TXT 分片（Base64），v2 布局。

硬性规则：
  1. 单个 TXT 最多 50000 个字符（50K）。--part-size 只能调小，
     传更大的值会被自动限制回 50000，绝不会生成 3.9MB 那种大文件。
  2. 分片按全局 5 位数字编号：00001.txt、00002.txt ……
  3. 每 100 个分片放进一个 4 位数字子文件夹：
        0001/00001.txt ... 0001/00100.txt
        0002/00101.txt ... 0002/00200.txt
        0003/00201.txt ... 以此类推
     第 101 个分片自动进入第二个文件夹。
  4. 生成 manifest.json，记录布局参数、原始大小与 SHA256，供 decode.py 还原。

用法：
  python encode.py <源文件> [--out-dir 输出目录] [--part-size 每片字符数]
  例：python encode.py voice2.zip --out-dir . --part-size 50000
"""

import os
import base64
import hashlib
import json
import argparse

# ---------------- 布局常量（encode / decode 必须一致） ----------------
VERSION = 2
LAYOUT = "foldered"
MAX_PART_SIZE = 50000        # 硬上限：单个 TXT 最大 50K 字符
PART_SIZE = MAX_PART_SIZE    # 默认值就等于上限
FILES_PER_FOLDER = 100       # 每个子文件夹最多 100 个 TXT
FOLDER_DIGITS = 4            # 文件夹名 4 位：0001
PART_DIGITS = 5              # 分片名 5 位：00001.txt


def folder_of(idx, per=FILES_PER_FOLDER, digits=FOLDER_DIGITS):
    """第 idx 个分片（从 1 开始）所属的子文件夹名。"""
    return f"{(idx - 1) // per + 1:0{digits}d}"


def part_relpath(idx, per=FILES_PER_FOLDER, digits=FOLDER_DIGITS,
                 part_digits=PART_DIGITS):
    """第 idx 个分片相对输出目录的路径。"""
    return os.path.join(folder_of(idx, per, digits),
                        f"{idx:0{part_digits}d}.txt")


def encode(input_path, out_dir, part_size=PART_SIZE):
    if not os.path.isfile(input_path):
        raise FileNotFoundError(input_path)
    if part_size < 4:
        raise ValueError("part-size 不能小于 4")
    if part_size > MAX_PART_SIZE:
        print(f"[提示] --part-size={part_size} 超过 50K 硬上限，"
              f"已自动限制为 {MAX_PART_SIZE}。", flush=True)
        part_size = MAX_PART_SIZE

    os.makedirs(out_dir, exist_ok=True)

    sha = hashlib.sha256()
    total_bytes = 0
    part_index = 0
    buf = []          # 待输出的 Base64 片段
    buf_len = 0
    made_folders = set()

    def emit(idx, text):
        rel = part_relpath(idx)
        folder = os.path.dirname(rel)
        abs_folder = os.path.join(out_dir, folder)
        if folder not in made_folders:
            os.makedirs(abs_folder, exist_ok=True)
            made_folders.add(folder)
        with open(os.path.join(out_dir, rel), "w",
                  encoding="ascii", newline="") as f:
            f.write(text)

    # 每次读 65535 字节（3 的倍数），保证每块 Base64 无中间填充符。
    read_size = 3 * 21845
    with open(input_path, "rb") as f:
        while True:
            raw = f.read(read_size)
            if not raw:
                break
            sha.update(raw)
            total_bytes += len(raw)
            chunk = base64.b64encode(raw).decode("ascii")
            buf.append(chunk)
            buf_len += len(chunk)
            while buf_len >= part_size:
                text = "".join(buf)
                part_index += 1
                emit(part_index, text[:part_size])
                rest = text[part_size:]
                buf = [rest] if rest else []
                buf_len = len(rest)

    tail = "".join(buf)
    if tail or part_index == 0:      # 空文件也写出一个空分片，便于还原
        part_index += 1
        emit(part_index, tail)

    manifest = {
        "version": VERSION,
        "layout": LAYOUT,
        "original_name": os.path.basename(input_path),
        "total_parts": part_index,
        "encoding": "base64",
        "part_size": part_size,
        "max_part_size": MAX_PART_SIZE,
        "files_per_folder": FILES_PER_FOLDER,
        "folder_digits": FOLDER_DIGITS,
        "part_digits": PART_DIGITS,
        "original_size": total_bytes,
        "sha256": sha.hexdigest(),
    }
    with open(os.path.join(out_dir, "manifest.json"), "w",
              encoding="utf-8") as f:
        json.dump(manifest, f, ensure_ascii=False, indent=2)
    return manifest


def main():
    p = argparse.ArgumentParser(description="把任意文件编码为 50K 以内的 Base64 TXT 分片")
    p.add_argument("input", help="要转换的源文件")
    p.add_argument("--out-dir", default=None,
                   help="输出目录（默认与源文件同目录）")
    p.add_argument("--part-size", type=int, default=PART_SIZE,
                   help=f"每个 TXT 最大字符数，默认/上限 {MAX_PART_SIZE}（50K）")
    args = p.parse_args()

    out_dir = args.out_dir or os.path.dirname(os.path.abspath(args.input))
    m = encode(args.input, out_dir, args.part_size)
    folders = (m["total_parts"] + m["files_per_folder"] - 1) // m["files_per_folder"]

    print("编码完成：")
    print(f"  源文件     : {args.input}")
    print(f"  分片目录   : {os.path.abspath(out_dir)}")
    print(f"  分片数量   : {m['total_parts']} 个（每个最多 {m['part_size']} 字符）")
    print(f"  子文件夹   : {folders} 个，每个最多 {m['files_per_folder']} 个 TXT")
    print(f"  原始大小   : {m['original_size']} 字节")
    print(f"  SHA256     : {m['sha256']}")


if __name__ == "__main__":
    main()
