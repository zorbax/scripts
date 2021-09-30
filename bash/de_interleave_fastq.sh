#!/bin/bash

display_usage(){
  echo "This script interleave and de-interleave paired fastq files."
  echo -e "\nUsage:\n $0 -z -m read1.fastq[.gz] read2.fastq[.gz]\n"
  echo -e "\nUsage:\n $0 -z -s read_12.fastq[.gz]\n"
}

if [ $# -le 1 ]; then
  display_usage
  exit 1
fi

merge=false
split=false

while getopts ":md:zh" opt
do
  case $opt in
    m) merge=true
       shift 2
    ;;
    d) split=true
       shift 2
    ;;
    z) out_zip=true
       shift 2
    ;;
    h) display_usage
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
        exit 1
    ;;
  esac
done

if [ $merge == true ]; then
  if [ $(file $3 | cut -d ' ' -f2) == $(file $4 | cut -d ' ' -f2) ]; then
    echo "Both files have the same format"
  else
    echo "ERROR: $3 and $4 are not in the same format"
    exit
  fi
  format=$( file $2 $3 | cut -d ' ' -f2 | sort | uniq )
fi

# Check filenames
#Check R1/R1 1/2 syntax in filename. Choose
threads=$(nproc)
name=$( basename $2 )

if [ $(file $2 | cut -d ' ' -f2) == $(file $3 | cut -d ' ' -f2) ]; then
  echo "Both files have the same format"
else
  echo "ERROR: $2 and $3 are not in the same format"
  exit
fi

format=$( file $2 $3 | cut -d ' ' -f2 | sort | uniq )

paste <(zcat $1) <(zcat $2) | paste - - - - | awk -v OFS="\n" -v FS="\t" '{print($1,$3,$5,$7,$2,$4,$6,$8)}' > $name\_combo.fastq


paste $1 $2 | paste - - - - | awk -v OFS="\n" -v FS="\t" '{print($1,$3,$5,$7,$2,$4,$6,$8)}' |  pigz --best --processes ${threads} > interleaved.fastq

# If the third argument is the word "compress" then we'll compress the output using pigz
if [[ $format == "gzip" ]]; then
  if [[ $2 == "compress" ]]; then
    zcat $1 | paste - - - - - - - -  | tee >(cut -f 1-4 | tr "\t" "\n" | pigz --best --processes ${threads} > $name\_1.fastq.gz ) | cut -f 5-8 | tr "\t" "\n" | pigz --best --processes ${threads} > $name\_2.fastq.gz
  else
    zcat $1 | paste - - - - - - - -  | tee >(cut -f 1-4 | tr "\t" "\n" > $name\_1.fastq ) | cut -f 5-8 | tr "\t" "\n" > $name\_2.fastq.gz
  fi
elif [[ $1 =~ \.f?q$ ]]; then
  if [[ $2 == "compress" ]]; then
    cat $1 | paste - - - - - - - -  | tee >(cut -f 1-4 | tr "\t" "\n" | pigz --best --processes ${threads} > $name\_1.fastq.gz ) | cut -f 5-8 | tr "\t" "\n" | pigz --best --processes ${threads} > $name\_2.fastq.gz
  else
    cat $1 | paste - - - - - - - -  | tee >(cut -f 1-4 | tr "\t" "\n" > $name\_1.fastq ) | cut -f 5-8 | tr "\t" "\n" > $name\_2.fastq
  fi
else
  echo "Maybe your input file is not a fastq/fq file"
fi
