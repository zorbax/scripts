#!/usr/bin/python3
'''
FASTQ to FASTA 01
'''

from Bio import SeqIO
import sys,os

'''
#PYTHON2
def main():
    if len(sys.argv) != 3:
        print >> sys.stderr, 'Usage: python %s <input.fastq> <output.fna>' \
                 %(os.path.basename(sys.argv[0]))
        sys.exit(1)

    infile = sys.argv[1]
    outfile = sys.argv[2]

    fasta_out = FastaIO.FastaWriter(SeqIO.convert(infile, "fastq", outfile, "fasta"), wrap=None)
    fasta_out.write_file()
'''

def main():
    if len(sys.argv) != 3:
        print('This script use Python3\nUsage: ./%s <input.fastq> <output.fna>' \
                                 % os.path.basename(sys.argv[0]), file=sys.stderr)
        sys.exit(1)

    with open(sys.argv[1], "rU") as infile:
        with open(sys.argv[2], "w") as outfile:
            #Convert and write with SeqIO.write in a multiline fasta format
            #fasta_out = SeqIO.write(SeqIO.parse(infile, "fastq"), outfile, "fasta")
            #Save in one_line fasta format
            for record in SeqIO.parse(infile, "fastq"):
                sequence = str(record.seq)
                outfile.write('>'+record.id+'\n'+sequence+'\n')

if __name__ == '__main__':
    main()
