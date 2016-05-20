#!/bin/bash


#for i in $(<taxon_id)
#do
#    name=$(basename "$i")
#    epost -db taxonomy -id $i | elink -target nuccore | efetch -format fasta > id.fa.tmp
#    perl -pe 'if(/\>/){s/\n/\t/}; s/\n//; s/\>/\n\>/' id.fa.tmp | perl -pe 's/\t/\n/' | tail -n+2 > tmp
#    mv tmp id.fa && rm id.fa.tmp
#    cat id.fa | perl -pe 'if(/\>/){s/\n/\#/g}' | grep -vi plasmid | grep "NC_\|genome\|cds\|gene\|chromosome"  | grep -iv "minisatellite\|patent\|tRNA\|mRNA\|ribosomal\|rRNA" | sed 's/#/\n/g'> $name\_nc.fa
#    rm id.fa
#    echo "Done $i"
#done


#for i in $(<taxon_id)
#do
#    name=$(basename "$i")
#    epost -db taxonomy -id $i | elink -target nuccore | efetch -format fasta > id.fa.tmp
#    perl -pe 'if(/\>/){s/\n/\t/}; s/\n//; s/\>/\n\>/' id.fa.tmp | perl -pe 's/\t/\n/' | tail -n+2 > tmp
#    mv tmp id.fa && rm id.fa.tmp
#	cat id.fa | perl -pe 'if(/\>/){s/\n/\@/g}' | sed 's/|ref|/#ref$>/g' | grep \#ref\$\> | grep -v "ribosomal\|plasmid" | cut -d\$ -f2 | sed 's/@/\n/g'> $name\_nc.fa
#    rm id.fa
#    echo "Done $i"
#done

#for i in $(<file.txt); do echo "$i"; epost -db taxonomy -id $i | elink -target nuccore | efetch -format fasta >> 265genomes10c.fa done

for i in $(<$1)
do
	name=$(basename "$i")
	#download all the sequences associated with $i tax id
	epost -db taxonomy -id $i | elink -target nuccore | efetch -format fasta > $name.fa
	#one liner
#    	perl -pe 'if(/\>/){s/\n/\t/}; s/\n//; s/\>/\n\>/' id.fa.tmp | perl -pe 's/\t/\n/' | tail -n+2 > tmp
#    	mv tmp id.fa && rm id.fa.tmp
#	cat id.fa | perl -pe 'if(/\>/){s/\n/\@/g}' | sed 's/|ref|/#ref$>/g' | grep \|#ref\$\> | grep -v "ribosomal\|plasmid" | cut -d\$ -f2 | sed 's/@/\n/g'> $name\_nc.fa
#	cat id.fa | perl -pe 'if(/\>/){s/\n/\@/g}' | grep -v "ribosomal\|plasmid\|RNA\|gene" | grep -v Patent | sed 's/@/\n/g' > $name\_nc.fa
#	rm id.fa
    echo "Done $i"
done
