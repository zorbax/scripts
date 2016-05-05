#!/bin/bash
#FASTQ TO FASTA
convert_fastaqual_fastq.py -c fastq_to_fastaqual -f V3-341F1_28.fastq -o V3-341F1_28

#COMBINE ALL DEMULTIPLEXED FILES
add_qiime_labels.py -i ratas_probiotic/fastaqual -m fasting_map_combine.txt -c InputFileName -n 100000000 -o combined_fasta

#OTU PICKING- TAXONOMY ASSIGNMENT
pick_de_novo_otus.py -i combined_fasta/combined_seqs.fna -o otus

#REMOVAL OF CHIMERA
identify_chimeric_seqs.py -m ChimeraSlayer -i otus/pynast_aligned_seqs/combined_seqs_rep_set_aligned.fasta -a otus/core_set_aligned.fasta.imputed -o chimeric_seqs.txt

filter_otus_from_otu_table.py -i otus/otu_table.biom -o otus/otu_table_non_chimeric.biom -e chimeric_seqs.txt

#SORT IN SAMPLE ID ORDER
sort_otu_table.py -i otus/otu_table_non_chimeric_.biom -o sorted_otu_table.biom -l sample_id.txt

#SUMMARIZE TAXA
summarize_taxa_through_plots.py -i sorted_otu_table.biom -o taxa_summary_ratas_abundance/ -s -p qiime_parameters_selva.txt -m fasting_map_combine.txt

biom summarize-table -i sorted_otu_table.biom -o otu_table_summary_table.txt

#LIST OF ALPHA DIVERSITY MATRIX
echo "alpha_diversity:metrics berger_parker_d,chao1,chao1_confidence,fisher_alpha,goods_coverage,observed_species,osd,simpson_reciprocal,shannon,simpson,simpson_e,PD_whole_tree" > alpha_params.txt

alpha_rarefaction.py -i sorted_otu_table.biom -m fasting_map_combine.txt -o wf_arare_ratas/ -p alpha_params.txt -t otus/rep_set.tre

#BETA DIVERSITY MATRIX 
beta_diversity_through_plots.py -i sorted_otu_table.biom -m fasting_map_combine.txt -o wf_bdiv_even12_ratas/ -t otus/rep_set.tre
jackknifed_beta_diversity.py -i sorted_otu_table.biom -t otus/rep_set.tre -m fasting_map_combine.txt -o wf_jack_ratas_probiotic -e 110
