#!/bin/bash

for i in *fna;
do
	taxid=`echo $i | cut -d\. -f1`
	name=`echo $i | sed 's/_genomic/#/g' | cut -d\# -f1`
	echo "Print $name variable"
	echo "cat to $i and replacing name in fasta header: DONE"
	cat $i | perl -pe "s/\>/\>$taxid\#/;s/^\s+$/\n/g"  | sed 's/#/./g' | sed '/^$/d' >> $name.fna
#	perl -pe "if(/\>/){s/\^/\#$i/;s/^\s+$/\n/g}"  | cut -d\. -f1 | sed '/^$/d' >> $name.fna
done

