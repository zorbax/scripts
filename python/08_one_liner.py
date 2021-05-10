#!/usr/bin/env python3

import os
import sys
import re


def main():
    """
    Convert multiline FASTA to single line FASTA
    """

    if len(sys.argv) != 2:
        print(f"\nUsage: ./{os.path.basename(sys.argv[0])} <sequence.fasta>\n",
              file=sys.stderr)
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = input_file

    with open(input_file, "r") as fasta_file:
        fasta_data = fasta_file.read()
        sequences = re.findall(">[^>]+", fasta_data)

    with open(output_file, "w") as fasta:
        for i in sequences:
            header, seq = i.split("\n", 1)
            header += "\n"
            seq = seq.replace("\n", "") + "\n"
            fasta.write(header + seq)


if __name__ == '__main__':
    main()
