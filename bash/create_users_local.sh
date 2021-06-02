#!/bin/bash

if [[ $(id -u) -eq 0 ]]; then
    while read -r line
    do
        username="${line}"
        password="${line}atg"
        grep -E "^${username}" /etc/passwd >/dev/null
        if [[ $? -eq 0 ]]; then
            echo "${username} exists!"
            exit 1
        else
            pass=$(perl -e 'print crypt($ARGV[0], "password")' ${password})
            useradd -m -d /home/${line} -s /bin/bash -p ${pass} ${username}
            [[ $? -eq 0 ]] && echo "User has been added to system!" || echo "Failed to add a user!"
        fi
    done < users.txt
else
    echo "Only root may add a user to the system"
    exit 2
fi
