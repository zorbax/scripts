import argparse


def read_fasta_file_handle(fasta_file_handle):
    """
    Parse a fasta file and return a generator
    """
    # Variables initialization
    header = ''
    seqlines = list()
    sequence_nb = 0
    # Reading input file
    for line in (l.strip() for l in fasta_file_handle if l.strip()):
        if line[0] == '>':
            # Yield the last read header and sequence
            if sequence_nb:
                yield (header, ''.join(seqlines))
                seqlines = list()
            # Get header
            header = line[1:]
            sequence_nb += 1
        else:
            # Concatenate sequence
            seqlines.append(line)
    # Yield the input file last sequence
    yield (header, ''.join(seqlines))
    # Close input file
    fasta_file_handle.close()


def format_seq(seq, linereturn=80):
    """
    Format an input sequence
    """
    buff = list()
    for i in range(0, len(seq), linereturn):
        buff.append("{0}\n".format(seq[i:(i + linereturn)]))
    return ''.join(buff).rstrip()


if __name__ == '__main__':

    # Initiate argument parser
    parser = argparse.ArgumentParser(description='Sort a fasta file by increasing sequence length.')

    # -i / --input_fasta
    parser.add_argument('-i', '--input_fasta',
                        action='store',
                        metavar='INFILE',
                        type=argparse.FileType('r'),
                        default='-',
                        help="Input fasta file. "
                             "Default is <stdin>")

    # -o / --output_fasta
    parser.add_argument('-o', '--output_fasta',
                        action='store',
                        metavar='OUTFILE',
                        type=argparse.FileType('w'),
                        default='-',
                        help="Ouput fasta file. "
                             "Default is <stdout>")

    # -r / --reverse
    parser.add_argument('-r', '--reverse',
                        action='store_true',
                        help='Sort by decreasing length')

    # Parse arguments from command line
    args = parser.parse_args()

    # Variables initialization
    seq_list = list()

    # Load all sequences
    for header, sequence in read_fasta_file_handle(args.input_fasta):
        seq_list.append((header, sequence))

    # Sort sequences by length
    if args.reverse:
        seq_list.sort(key=lambda x: len(x[1]), reverse=True)
    else:
        seq_list.sort(key=lambda x: len(x[1]))

    # Write sorted sequences to output file
    for header, sequence in seq_list:
        args.output_fasta.write(">{0}\n{1}\n".format(header, format_seq(sequence)))
