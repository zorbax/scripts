#!/bin/bash

fasta=$1
linenumber=$(wc -l ${fasta} | cut -f1 -d ' ' -)
idx=1

declare -A samples=([colA]="10"  [colT]="33"    [colG]="214"
                    [colC]="9"   [colN1]="87"   [colN2]="205"
                    [colBg]="17" [colBond2]="0" [colHelix]="250")

for i in "${!samples[@]}"
do
    ${i}="$(tput setaf ${samples[$i]})"
done

for N in $(seq 3 ${linenumber}) # iterate each line of FA
do
    seq=$(sed -n "$N"p ${fasta}) # extract Nth line

    if [[ ${seq} =~ ^N+$ ]]; then # if all N line; skip
        sleep 0
    else
        for base in $(echo ${seq} | sed -e 's/\(.\)/\1\/g')
        do
            if [[ ${base} =~ [Aa] ]]; then
                W="${colA}"A"${colHelix}"
                C="${colT}"T"${colHelix}"
                bond='-'
            elif [[ ${base} =~ [TtUu] ]]; then
                W="${colT}"T"${colHelix}"
                C="${colA}"A"${colHelix}"
                bond='-'
            elif [[ ${base} =~ [Gg] ]]; then
                W="${colG}"G"${colHelix}"
                C="${colC}"C"${colHelix}"
                bond='='
            elif [[ ${base} =~ [Cc] ]]; then
                W="${colC}"C"${colHelix}"
                C="${colG}"G"${colHelix}"
                bond='='
            else
                W="${colN1}"O"${colHelix}"
                C="${colN2}"X"${colHelix}"
                bond='-'
            fi

            BP_1="${colBg}.... ${colHelix}\$${W}---${C}\$${colBg} ....."
            BP_2="${colBg}.... ${colHelix}\$${W}----${C}\$${colBg} ...."
            BP_3="${colBg}..... ${colHelix}\$${W}----${C}\$${colBg} ..."
            BP_4="${colBg}...... ${colHelix}\$${W}---${C}\$${colBg} ..."
            BP_5="${colBg}....... ${colHelix}\$${W}-${C}\$${colBg} ...."
            BP_6="${colBg}........ ${C}\$${colBg} ......"
            BP_7="${colBg}...... ${colHelix}\$${C}${colBond2}---${W}\$${colBg} ..."
            BP_8="${colBg}..... ${colHelix}\$${C}${colBond2}----${W}\$${colBg} ..."
            BP_9="${colBg}.... ${colHelix}\$${C}${colBond2}----${W}\$${colBg} ...."
            BP_10="${colBg}.... ${colHelix}\$${C}${colBond2}---${W}\$${colBg} ....."
            BP_11="${colBg}...... ${colHelix}\$${W}${colBg} ........"
            BP_12="${colBg}..... ${colHelix}\$${W}-${C}\$${colBg} ......"
            output="BP_${idx}"

            eval echo -e '$'${output}

            if [[ ${idx} -eq 12 ]]; then
                idx=1
            else
                idx=$((idx + 1))
            fi
            sleep 0.2s
        done
    fi
done
