#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
decode.py —— 把 encode.py 生成的 TXT 分片还原成原始文件。

支持两种布局（由 manifest.json 的 layout 字段决定）：
  v2 "foldered"：分片在 0001/、0002/ … 子文件夹里，每目录最多 100 个，
                 文件名 5 位数字，见 manifest 中的 files_per_folder /
                 folder_digits / part_digits。
  v1 "flat"    ：旧版平铺在根目录的 00001.txt …（兼容旧仓库）。

采用流式解码：逐片读取、按 4 字符对齐增量 b64decode 并写盘，同时增量计算
SHA256。内存占用只有几 KB，不需要把 2GB 文本整块读进内存。

用法：
  python decode.py [--in-dir 分片目录] [--output 输出文件路径]
  例：python decode.py --in-dir . --output restored_voice2.zip
"""

import os
import base64
import hashlib
import json
import argparse


def part_path(in_dir, idx, manifest):
    """按 manifest 描述的第 2 版布局（或旧版平铺）定位第 idx 个分片。"""
    if manifest.get("layout") == "foldered":
        per = int(manifest.get("files_per_folder", 100))
        fd = int(manifest.get("folder_digits", 4))
        pd = int(manifest.get("part_digits", 5))
        folder = f"{(idx - 1) // per + 1:0{fd}d}"
        return os.path.join(in_dir, folder, f"{idx:0{pd}d}.txt")
    return os.path.join(in_dir, f"{idx:05d}.txt")


def decode(in_dir, output_path=None, progress=True):
    manifest_path = os.path.join(in_dir, "manifest.json")
    if not os.path.isfile(manifest_path):
        raise FileNotFoundError(
            "找不到 manifest.json，无法还原（请确认 --in-dir 指向正确的分片目录）")
    with open(manifest_path, "r", encoding="utf-8") as f:
        m = json.load(f)

    total = int(m["total_parts"])
    expect_sha = m["sha256"]
    expect_size = int(m.get("original_size", -1))

    if output_path is None:
        output_path = os.path.join(in_dir, "restored_" + m["original_name"])

    sha = hashlib.sha256()
    written = 0
    carry = ""        # 不足 4 个字符的余量，留到下一片一起解码
    tmp = output_path + ".part"
    ok = False
    try:
        with open(tmp, "wb") as out:
            for i in range(1, total + 1):
                path = part_path(in_dir, i, m)
                if not os.path.isfile(path):
                    raise FileNotFoundError(
                        f"缺少分片文件：{os.path.relpath(path, in_dir)}")
                with open(path, "r", encoding="ascii", errors="ignore") as f:
                    text = f.read().strip()
                carry += text
                n = len(carry) - (len(carry) % 4)
                if n:
                    chunk = base64.b64decode(carry[:n])
                    out.write(chunk)
                    sha.update(chunk)
                    written += len(chunk)
                    carry = carry[n:]
                if progress and (i % 5000 == 0 or i == total):
                    print(f"  已处理 {i}/{total} 片", flush=True)
            if carry:
                chunk = base64.b64decode(carry)
                out.write(chunk)
                sha.update(chunk)
                written += len(chunk)

        actual_sha = sha.hexdigest()
        if actual_sha != expect_sha:
            raise ValueError(
                "校验失败！分片可能损坏或不完整。\n"
                f"  期望: {expect_sha}\n  实际: {actual_sha}")
        if expect_size >= 0 and written != expect_size:
            raise ValueError(
                f"校验失败！文件大小不符：期望 {expect_size} 字节，实际 {written} 字节")
        ok = True
    finally:
        if not ok and os.path.isfile(tmp):
            os.remove(tmp)

    os.replace(tmp, output_path)
    return output_path, actual_sha, written, m


def main():
    p = argparse.ArgumentParser(description="把 Base64 TXT 分片还原为原始文件")
    p.add_argument("--in-dir", default=".", help="分片所在目录（默认当前目录）")
    p.add_argument("--output", default=None,
                   help="还原后的输出文件路径（默认 restored_<原名>）")
    args = p.parse_args()

    out, sha, size, m = decode(args.in_dir, args.output)
    print("还原完成：")
    print(f"  输出文件 : {out}")
    print(f"  文件大小 : {size} 字节")
    print(f"  分片数量 : {m['total_parts']} 个")
    print(f"  SHA256   : {sha}")
    print("  校验通过，文件与原始内容完全一致。")


if __name__ == "__main__":
    main()
