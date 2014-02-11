#! /usr/bin/env bash

SEED=1000
if [ "$1" != "" ]; then
    SEED="$1"
fi

TIMEFORMAT=""
if [ "$2" != "" ]; then
    TIMEFORMAT="$2"
fi

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
    echoerr "\"$2\", \"$1\", $SEED, "
    ./$SCRIPT "$SEED" "$TIMEFORMAT"

    cd ..
}

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
exec_dir "## Extension - no opcache" php-ext exec_no_opcache.sh
exec_dir "## Userland code- no opcache" php-php exec_no_opcache.sh


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
