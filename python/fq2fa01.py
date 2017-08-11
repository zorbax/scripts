#!/usr/bin/python
"""
FASTQ to FASTA 01
"""
from Bio import SeqIO
import sys
import os

def main():
    if len(sys.argv) != 3:
        print >> sys.stderr, 'Usage: python %s <input.fastq> <output.fna>' \
                 %(os.path.basename(sys.argv[0]))
        sys.exit(1)

    infile = sys.argv[1]
    outfile = sys.argv[2]

    fasta_out = FastaIO.FastaWriter(SeqIO.convert(infile, "fastq", outfile, "fasta"), wrap=None)
    fasta_out.write_file()

if __name__ == '__main__':
    main()
