#!/bin/bash
trap "echo ----; exit;" SIGINT SIGTERM

start=$1
end=$2
retries=24
i=0

false

while [[ $? -ne 0 && ${i} -lt ${retries} ]]
do
    i=$(( i + 1 ))
    rsync -aPvz ${start} ${end}
done

if [[ ${i} -eq ${retries} ]]; then
    echo "Hit maximum number of retries, giving up."
fi
