#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
decode.py —— 把 encode.py 生成的多个 TXT 分片还原成原始文件。

做法：
  1. 读取 manifest.json，取得原始文件名、分片数量与期望 SHA256；
  2. 按 00001.txt、00002.txt …… 的顺序读取并拼接 Base64 字符串；
  3. Base64 解码回原始字节；
  4. 计算 SHA256 与 manifest 中的值比对，确保与原始文件逐字节一致；
  5. 写出还原文件（默认名为 restored_<原名>，可指定输出路径）。

用法：
  python decode.py [--in-dir 分片目录] [--output 输出文件路径]
"""

import os
import sys
import base64
import hashlib
import json
import argparse


def decode(in_dir, output_path=None):
    manifest_path = os.path.join(in_dir, "manifest.json")
    if not os.path.isfile(manifest_path):
        raise FileNotFoundError(
            "找不到 manifest.json，无法还原（请确认 --in-dir 指向正确的分片目录）"
        )
    with open(manifest_path, "r", encoding="utf-8") as f:
        manifest = json.load(f)

    total_parts = manifest["total_parts"]
    parts = []
    for i in range(1, total_parts + 1):
        name = f"{i:05d}.txt"
        path = os.path.join(in_dir, name)
        if not os.path.isfile(path):
            raise FileNotFoundError(f"缺少分片文件：{name}")
        with open(path, "r", encoding="utf-8") as f:
            parts.append(f.read().strip())   # strip 去掉可能的换行/空白，不影响 Base64

    b64 = "".join(parts)
    data = base64.b64decode(b64)

    actual_sha = hashlib.sha256(data).hexdigest()
    if actual_sha != manifest["sha256"]:
        raise ValueError(
            "校验失败！分片可能损坏或不完整。\n"
            f"  期望: {manifest['sha256']}\n  实际: {actual_sha}"
        )

    if output_path is None:
        output_path = os.path.join(in_dir, "restored_" + manifest["original_name"])
    with open(output_path, "wb") as f:
        f.write(data)

    return output_path, actual_sha


def main():
    p = argparse.ArgumentParser(description="把 Base64 TXT 分片还原为原始文件")
    p.add_argument("--in-dir", default=".",
                   help="分片所在目录（默认当前目录）")
    p.add_argument("--output", default=None,
                   help="还原后的输出文件路径（默认 restored_<原名>）")
    args = p.parse_args()

    output_path, sha = decode(args.in_dir, args.output)

    print("还原完成：")
    print(f"  输出文件 : {output_path}")
    print(f"  SHA256   : {sha}")
    print("  校验通过，文件与原始内容完全一致。")


if __name__ == "__main__":
    main()
