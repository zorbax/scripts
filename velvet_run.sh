#!/bin/bash

echo "=================================================================="
echo "                      Esto es un simulacro                        "
echo "=================================================================="
echo ""
date
echo ""

fasta_file=$1
START=$(date +%s)

for ((k=33, i =1; k<99; k=k+2, i++))
do
    echo "[$i] Iteration - k = $k"
    velveth Velvet $k -fasta -long $fasta_file
    echo "   "
    velvetg Velvet -exp_cov auto -cov_cutoff auto -min_contig_lgth 100
    echo "   "
    echo "--------------------------------------------------------------------------"
done

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "RUN TIME = $DIFF seconds"



