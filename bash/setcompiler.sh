#!/bin/bash
usage() {
    cat << EOF

    Sets the default version of gcc, g++, etc

    Usage:
        set-compiler <VERSION>
        set-compiler gcc-4.7

EOF
  exit
}

# linux
# cd /usr/bin || exit
# macos + brew
cd /usr/local/bin || exit

if [[ -z $1 ]] ; then
    usage;
fi

set_default() {
    if [[ -e "$1-$2" ]] ; then
        echo "$1-$2 is now the default"
        sudo ln -sf $1-$2 $1
    else
        echo "$1-$2 is not installed"
    fi
}

for i in gcc cpp g++ gcov gccbug
do
    set_default $i $1
done
