#!/bin/bash

n=10
min_size=$((1024/16*1))
max_size=$((1024/16*20))
dir_name="workdir"

if [ "$1" = "--cleanup" ]; then
    rm -rf $dir_name
    exit 0
fi

if [ "$1" != "" ] && [ "$1" -eq "$1" ] 2>/dev/null
then
    n=$1
fi

function random() {
    min=$1
    max=$2
    echo $(( $RANDOM % ($max - $min + 1) + $min ))
}

function create_file() {
    size=$1
    filename=$2
    dd if=/dev/urandom of=$filename bs=16K count=$size #> /dev/null 2>&1
}

function main() {
    mkdir $dir_name
    for i in `seq $n`
    do
        filename="$dir_name/file$i"
        size=$(random $min_size $max_size)
        printf "Creating file %s/%s\r" $i $n
        create_file $size $filename
    done
}

main