#!/bin/bash

SAMPLE_FILE='sample'
OUTPUT_FOLDER='RESULTS'

# Initial sample processing #
MOCAT.pl -sf $SAMPLE_FILE -rtf

# Generate mOTU profiles #
MOCAT.pl -sf $SAMPLE_FILE -s mOTU.v1.padded -r reads.processed -identity 97
MOCAT.pl -sf $SAMPLE_FILE -f mOTU.v1.padded -r reads.processed -identity 97
MOCAT.pl -sf $SAMPLE_FILE -p mOTU.v1.padded -r reads.processed -identity 97 -mode mOTU -o $OUTPUT_FOLDER

# Generate taxonomic profiles #
MOCAT.pl -sf $SAMPLE_FILE -s RefMG.v1.padded -r mOTU.v1.padded -e -identity 97
MOCAT.pl -sf $SAMPLE_FILE -f RefMG.v1.padded -r mOTU.v1.padded -e -identity 97
MOCAT.pl -sf $SAMPLE_FILE -p RefMG.v1.padded -r mOTU.v1.padded -e -identity 97 -mode RefMG -previous_db_calc_tax_stats_file -o $OUTPUT_FOLDER

# Done
echo "-----------------------------------------------------------------"
echo "mOTU and taxonomic profiles are in:"
echo "$OUTPUT_FOLDER"
echo "-----------------------------------------------------------------"
