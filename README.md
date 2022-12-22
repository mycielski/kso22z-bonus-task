###### Tomasz Mycielski (304248)

# KSO22Z -- zadanie dodatkowe

## Scenariusz

Jest wieczór. Jutro rano wyjeżdżamy na długą podróż samochodem. Chcemy móc słuchać naszej muzyki podczas jazdy. Na naszym komputerze zapisana jest pokaźna biblioteka plików audio. Są one jednak zapisane w formacie innym, niż akceptowany przez nasz system multimedialny w samochodzie. Naszym zadaniem jest przekonwertować jak największą część z naszego zbioru na inny format zanim będziemy musieli wyjeżdżać. 


Innymi słowy, mamy zoptymalizować liczbę wykonanych zadań w krótkim czasie. Zadania są intensywne obliczeniowo.


## Realizacja

W celu zasymulowania intensywnego obliczeniowo zadania korzystam z programu `cksum` do liczenia CRC-32. Rolę plików audio pełnią pliki utworzone prgramem `dd` z `/dev/urandom` o wielkościach między 1 a 20 MB. Skrypty testowałem na maszynie wirtualnej Ubuntu 22.04 na AWS EC2 (T3.xlarge) z procesorem x86 (4vCPU). 

## Benchmark

Testy wykonywałem dla 1000 plików.

Wersja sekwencyjna:

```bash
$ time ./consumer.sh workdir --slow
...
real    0m52.650s
user    0m48.647s
sys     0m3.869s
```

Wersja równoległa (z ośmioma procesami):

```bash
$ time ./consumer.sh workdir --fast 8
...
real    0m10.003s
user    0m36.200s
sys     0m3.544s
```
Liczbę 8 ustaliłem eksperymentalnie. Zacząłem od 4 i zwiększałem aż do 11. Wartość 8 okazała się optymalna dla czasu wykonania skryptu.

## Kod źródłowy

### `consumer.sh`

```bash
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
```

### `producer.sh`

```bash
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
```

Kod stawiający infrastrukturę dostępny jest w [repozytorium](https://github.com/mycielski/kso22z-bonus-task).
