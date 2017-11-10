#! /usr/bin/python
'''
FASTQ to FASTA 02
'''
import sys, os
import screed

'''
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
'''

def main():
    if len(sys.argv) != 3:
        print('This script use Python3\nUsage: ./%s <input.fastq> <output.fna>' \
                                % os.path.basename(sys.argv[0]), file=sys.stderr)
        sys.exit(1)

    with screed.open(sys.argv[1]) as infile:
        with open(sys.argv[2], "w") as outfile:
            for i, record in enumerate(infile):
                name = record['name']
                seq = record['sequence']
                outfile.write('>%s\n%s\n' %(name, seq))

if __name__ == '__main__':
    main()
