#!/usr/bin/env bash

script="$1"
log=$2

if [[ "$log" == "" ]]; then
    log="/dev/null"
fi

export script

nohup bash -c "$(cat <<EOF
    echo "Start time: $(date +%T)"

    if [[ -x "${script}" ]]; then
        ./${script}
    else
        chmod +x ${script} && ./${script}
    fi

    echo "End time: $(date +%s)"
EOF
)" 2> ${log}.err > ${log}.out < /dev/null & echo $! > ${log}.pid