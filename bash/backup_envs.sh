#!/bin/bash

yml_folder="$HOME/Documents/Dropbox/Bioinformatics/Code/Python"

display_usage(){
    echo -e "\nUsage:"
    echo -e "\t$(basename $0) backup"
    echo -e "\t$(basename $0) restore"
}

if [[ $# -lt 1 ]]; then
    display_usage
    exit 1
fi

backup() {
    local envs
    envs=$(conda env list | awk -e '$0 ~ /^\w/ {print $1}')

    for i in ${envs}
    do
        conda env export -n ${i} > ${yml_folder}/yaml/${i}.yml
    done
}

restore() {
    for i in "${yml_folder}"/*yml
    do
        conda env create -f ${i};
    done
}

if [[ $1 == "backup" ]]; then
    backup
elif [[ $2 == "restore" ]]; then
   restore
else
    display_usage
    exit 1
fi
