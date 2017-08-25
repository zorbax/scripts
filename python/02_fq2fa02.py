#! /usr/bin/python
"""
FASTQ to FASTA 02
"""
import sys, os
import screed

def main():
    if len(sys.argv) != 3:
        print >> sys.stderr, 'Usage: python %s <input.fastq> <output.fna>' \
                 %(os.path.basename(sys.argv[0]))
        sys.exit(1)

    infile = sys.argv[1]
    outfile = sys.argv[2]
    wrfile = open(outfile, 'wb')

    for i, record in enumerate(screed.open(infile)):
        name = record['name']
        seq = record['sequence']
        print >> wrfile, '>%s\n%s' %(name, seq)

    wrfile.close()

if __name__ == '__main__':
    main()
