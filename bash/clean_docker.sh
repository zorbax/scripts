#!/bin/sh

exited_containers() {
  docker ps -a -q -f status=exited
}

untagged_containers() {
    docker ps -a | tail -n +2 | awk '$2 ~ "^[0-9a-f]+$" {print $'$1'}'
}

untagged_images() {
    docker images | tail -n +2 | awk '$1 == "<none>" {print $'$1'}'
}

untagged_volumes() {
    docker volume ls -qf dangling=true
}

if [ "$1" = "-n" ]; then
    exited_containers
    untagged_containers 0
    untagged_images 0
    untagged_volumes
    exit
fi

if [ -n "$1" ]; then
    echo "Remove untagged containers and images."
    echo "Usage: ${0##*/} [-n]"
    echo " -n: dry run"
    exit 1
fi

echo "Removing exited containers:" >&2
exited_containers | xargs --no-run-if-empty docker rm -v

echo "Removing containers:" >&2
untagged_containers 1 | xargs --no-run-if-empty docker rm --volumes=true

echo "Removing images:" >&2
untagged_images 3 | xargs --no-run-if-empty docker rmi

echo "Removing volumes:" >&2
untagged_volumes | xargs --no-run-if-empty docker volume rm
