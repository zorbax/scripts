#! /usr/bin/env python3

import sys
import os
import screed


def main():
    if len(sys.argv) != 3:
        basename = os.path.basename(sys.argv[0])
        print(f"\nUsage: ./{basename} <input.fastq> <output.fna>\n",
              file=sys.stderr)
        sys.exit(1)

    with screed.open(sys.argv[1]) as infile:
        with open(sys.argv[2], "w") as outfile:
            for i, record in enumerate(infile):
                name = record['name']
                seq = record['sequence']
                outfile.write('>%s\n%s\n' % (name, seq))


if __name__ == '__main__':
    main()
