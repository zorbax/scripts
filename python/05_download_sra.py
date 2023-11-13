#!/usr/bin/env python3
import sys
import subprocess
from pathlib import Path


def main():
    if len(sys.argv) != 2:
        print(f"\nUsage: ./{Path(__file__).name} <srr_ids.txt>\n",
              file=sys.stderr)
        sys.exit(1)

    with open(sys.argv[1], 'r') as srr_id:
        srrs = srr_id.read().split("\n")

    for i in srrs:
        print("Downloading %s" % i)
        subprocess.call('fastq-dump -F --gzip --split-3 %s' % i, shell=True)


if __name__ == '__main__':
    main()
