#!/bin/bash

((count_all=0))
((count_changed=0))
((count_unchanged=0))
((verbose=0))

while IFS= read -r -d '' repo
do
    ((count_all=count_all+1))

    dir=$(echo ${repo} | sed -e 's/\/.git/\//')
    cd ${dir} || exit

    git status -s | grep -v '??' &> /dev/null && {
	    echo -e "\n\n \E[1;31m ${dir}\E[0m"
        git branch -vvra
	    git status -s | grep -v '??'
	    ((count_changed=count_changed+1))
    }

    git status -s | grep -v '??' &> /dev/null || {
	    if [[ ${verbose} -ne 0 ]]; then
            echo "Nothing to do for ${dir}"
        fi
	    ((count_unchanged=count_unchanged+1))
    }

    cd - &> /dev/null || exit
done < <(find . -type d -name ".git")

echo -ne "\n\n${count_all} git repositories found: "
echo -ne "${count_changed} have changes, "
echo -ne "${count_unchanged} are unchanged.\n\n"
