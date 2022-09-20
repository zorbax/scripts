#!/bin/bash
from=$1
if [[ "$#" -eq 1 ]]; then to=$1; else to=$2; fi
if [[ ${to} -lt ${from} ]]; then to=$((from + to)); fi
head -n ${to} | tail -n $((to - from + 1))