#!/bin/bash

echo "========================"
echo "  Esto es un simulacro  "
echo "========================"
echo ""
date
echo ""

fasta_file=$1
start=$(date +%s)

for ((k=33, i =1; k<99; k=k+2, i++))
do
    echo "[$i] Iteration - k = $k"
    velveth Velvet $k -fasta -long $fasta_file
    echo "   "
    velvetg Velvet -exp_cov auto -cov_cutoff auto -min_contig_lgth 100
    echo "   "
    echo "--------------------------------------------------------------------------"
done

end=$(date +%s)
diff=$(( $end - $start ))
echo "RUN TIME = $diff seconds"



