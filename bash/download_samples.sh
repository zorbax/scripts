#!/bin/bash

samples="SAMN07374521 SAMN07429351 SAMN07429356 SAMN07429359 SAMN07429362
         SAMN07429345 SAMN07429352 SAMN07429355 SAMN07429360 SAMN07429346
         SAMN07429347 SAMN07429348 SAMN07429349 SAMN07429354 SAMN07429357
         SAMN07429361 SAMN07423569"
:<<'END'
SRR5921431
SRR5888364
SRR5888413
SRR5932688
SRR5921432
SRR5921441
SRR5921437
END

for sample in ${samples}
do
  IFS=$'\n'
  for line in $(./sra-download-sample.py $sample)
  do
    echo $sample $line >> runs
  done
  unset IFS
done

if [ -f runs ]
then
  wget -i $(cut -d ' ' -f 3 runs)
  wait
  rm runs
fi

for i in *sra
do
  fastq-dump -I --split-files --gzip $i
  rm $i
done

#Install SRA Toolkit
#cd $HOME/bin
#wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.8.2/sratoolkit.2.8.2-ubuntu64.tar.gz
#tar -zxvf sratoolkit.2.8.2-ubuntu64.tar.gz
#mv sratoolkit.2.8.2-ubuntu64 sratoolkit.2.8.2 && rm -rf *tar.gz
#find sratoolkit.2.8.2 -type l -name "fastq-dump*" -exec ln -s {} . \;
