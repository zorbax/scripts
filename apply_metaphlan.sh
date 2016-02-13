#!/bin/bash

samples="SRS014459 SRS014464 SRS014472 SRS014470 SRS014476 SRS014494"
for s in ${samples}
do
    tar xjf input/${s}.tar.bz2 --to-stdout | metaphlan2.py --bowtie2db /home/drjaime/bin/metaphlan2/db_v20/mpa_v20_m200 --mpa_pkl /home/drjaime/bin/metaphlan2/db_v20/mpa_v20_m200.pkl --bt2_ps very-sensitive --input_type multifastq -t rel_ab --bowtie2out profiled_samples/${s}.bowtie2_out.bz2 -o profiled_samples/${s}.txt 
done

mkdir -p output
merge_metaphlan_tables.py profiled_samples/*.txt > output/merged_abundance_table.txt
mkdir -p output_images
metaphlan_hclust_heatmap.py -c bbcry --top 25 --minv 0.1 -s log --in output/merged_abundance_table.txt --out output_images/abundance_heatmap.png
mkdir -p tmp
export2graphlan.py --skip_rows 1,2 -i output/merged_abundance_table.txt --tree tmp/merged_abundance.tree.txt --annotation tmp/merged_abundance.annot.txt
graphlan_annotate.py --annot tmp/merged_abundance.annot.txt tmp/merged_abundance.tree.txt tmp/merged_abundance.xml
graphlan.py --dpi 200 tmp/merged_abundance.xml output_images/merged_abundance.png
