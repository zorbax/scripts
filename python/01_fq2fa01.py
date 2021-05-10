#!/usr/bin/env python3

from Bio import SeqIO
import sys
import os


def main():
    if len(sys.argv) != 3:
        basename = os.path.basename(sys.argv[0])
        print(f"\nUsage: ./{basename} <input.fastq> <output.fna>\n",
              file=sys.stderr)
        sys.exit(1)

    with open(sys.argv[1], "rU") as infile:
        with open(sys.argv[2], "w") as outfile:
            """
            Convert and write with SeqIO.write in a multiline fasta format
            fasta_out = SeqIO.write(SeqIO.parse(infile, "fastq"), outfile, "fasta")
            Save in one_line fasta format
            """
            for record in SeqIO.parse(infile, "fastq"):
                sequence = str(record.seq)
                outfile.write('>' + record.id + '\n' + sequence + '\n')


if __name__ == '__main__':
    main()
