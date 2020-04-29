#!/bin/bash

let count_all=0
let count_changed=0
let count_unchanged=0

let verbose=0

for repo in $(find . -type d -name ".git")
do
  let count_all=${count_all}+1

  dir=$(echo ${repo} | sed -e 's/\/.git/\//')
  cd ${dir}

  git status -s | grep -v '??' &> /dev/null && {
	  echo -e "\n\n \E[1;31m ${dir}\E[0m"
    git branch -vvra
	  git status -s | grep -v '??'
	  let count_changed=${count_changed}+1
  }

  git status -s | grep -v '??' &> /dev/null || {
	   if [[ ${verbose} -ne 0 ]]; then
       echo "Nothing to do for ${dir}"
     fi
	   let count_unchanged=${count_unchanged}+1
  }

  cd - &> /dev/null
done

echo -ne "\n\n${count_all} git repositories found: "
echo -ne "${count_changed} have changes, "
echo -ne "${count_unchanged} are unchanged.\n\n"
