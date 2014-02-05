#! /usr/bin/env bash

SEED=1000
if [ "$1" != "" ]; then
    SEED="$1"
fi

CSV=false;

if [ "$2" == "csv" ]; then
    CSV=true
fi

TIMEFORMAT="%Uuser %Ssystem %Eelapsed %PCPU (%Xtext+%Ddata %Mmax)k
%Iinputs+%Ooutputs (%Fmajor+%Rminor)pagefaults %Wswaps"

# Function from SO answer by James Roth
# http://stackoverflow.com/a/2990533/461813
echoerr() {
    echo -ne "$@" 1>&2;
}

exec_dir() {
    SCRIPT="exec.sh"

    if [ "" != "$3" ]; then
        SCRIPT="$3"
    fi
    echo " "
    echo "$1"
    cd "$2"
    echoerr "\"$2\", \"$1\", \"$SEED\", "
    ./$SCRIPT "$SEED" "$TIMEFORMAT"

    cd ..
}

if [ $CSV ]; then
    TIMEFORMAT='"%U", "%S", "%E", "%P", "%X", "%D", "%M", "%I", "%O", "%F", "%R", "%W"'
fi

echo " "
echo "Treffynnon benchmarker"
echo "^^^^^^^^^^^^^^^^^^^^^^"
echo " "
echo "################################"
echo "# Treffynnon exec script begin #"
echo "################################"
echo " "
echo " "
echo "HHVM"
echo "===="
exec_dir "## Extension" hhvm-ext

echo "## PHP userland code"
exec_dir "### No options" hhvm-php
exec_dir "### JITed" hhvm-php exec_jitted.sh

echo " "
echo "PHP"
echo "==="
exec_dir "## Extension" php-ext
exec_dir "## Userland code" php-php


echo " "
echo "C"
echo "="
exec_dir "" c

echo " "
echo "Zephir"
echo "======"
echo " "
exec_dir "## CBLOCK" php-zephir-cblock
exec_dir "## Optimizer" php-zephir-optimizer
exec_dir "## Zephir Lang" php-zephir

echo " "
echo " "
echo "###################################"
echo "# Treffynnon exec script complete #"
echo "###################################"
echo " "