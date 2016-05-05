### mOTU AND TAXONOMIC PROFILES 

SAMPLE_FILE='$1'
CONFIG_FILE='$2'
OUTPUT_FOLDER='RESULTS'
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
echo "The generated mOTU and taxonomic profiles should be available in:"
echo "$OUTPUT_FOLDER"
echo "-----------------------------------------------------------------"