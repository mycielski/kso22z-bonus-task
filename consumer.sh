#!/bin/bash

expensive_operation=cksum
workdir=$1

function usage() {
    echo "Usage: $0 <workdir> [--slow|--fast [parallel processes]]"
    exit 1
}

function slow_work() {
    files=$(ls -d -Sr $workdir/*)
    total=$(echo $files | wc -w)
    for file in $files
    do
        $expensive_operation $file
    done
}

function fast_work() {
    ls -Sr workdir/ | xargs -P $processes -n 1 -I{} $expensive_operation ./$workdir/{}
}

if [ "$workdir" = "" ]; then
    usage
fi

if [ ! -d "$workdir" ]; then
    echo "Directory $workdir does not exist"
    exit 1
fi

if [ "$2" = "--slow" ]; then
    slow_work
    exit 0
elif [ "$2" = "--fast" ]; then
    if [ "$3" != "" ] && [ "$3" -eq "$3" ] 2>/dev/null
    then
        processes=$3
    else
        processes=4
    fi
    fast_work
    exit 0
else
    usage
fi

function main() {
    slow_work
    fast_work
}

main