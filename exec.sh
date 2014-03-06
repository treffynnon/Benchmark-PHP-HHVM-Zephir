#! /usr/bin/env bash

SEED=1000
if [ "$1" != "" ]; then
    SEED="$1"
fi

ITERATIONS=1
if [ "$2" != "" ]; then
    ITERATIONS="$2"
fi

TIMEFORMAT=""
if [ "$3" != "" ]; then
    TIMEFORMAT="$3"
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
    if [[ -x "setup.sh" ]]; then
        # Pass in script name as argument for any required warm up
        ./setup.sh "$SCRIPT"
    fi
    
    for ((n=0;n<$ITERATIONS;n++))
    do
     echo "Iterating"
     echoerr "\"$2\", \"$1\", $SEED, "
     ./$SCRIPT "$SEED" "$TIMEFORMAT"
    done
    if [[ -x "teardown.sh" ]]; then
        ./teardown.sh
    fi

    cd ..
}

echo " "
echo "Treffynnon benchmarker"
echo "^^^^^^^^^^^^^^^^^^^^^^"
echo " "
echo "################################"
echo "# Command line benching        #"
echo "################################"
echo " "
echo " "
echo "HHVM"
echo "===="
echo "## Extension"
exec_dir "### No options" cli-hhvm-ext
exec_dir "### JITed" cli-hhvm-ext exec_jitted.sh

echo "## PHP userland code"
exec_dir "### No options" cli-hhvm-php
exec_dir "### JITed" cli-hhvm-php exec_jitted.sh

echo "## HACK/PHP++/PHQ userland code"
exec_dir "### No options" cli-hhvm-hack
exec_dir "### JITed" cli-hhvm-hack exec_jitted.sh

echo " "
echo "PHP"
echo "==="
echo "## Extension"
exec_dir "### No options" cli-php-ext exec_no_opcache.sh
exec_dir "### OPcached" cli-php-ext

echo "## PHP userland code"
exec_dir "### No options" cli-php-php exec_no_opcache.sh
exec_dir "### OPcached" cli-php-php


echo " "
echo "C"
echo "="
exec_dir "" c

echo " "
echo "Zephir"
echo "======"
echo "## CBLOCK"
exec_dir "### No options" cli-php-zephir-cblock exec_no_opcache.sh
exec_dir "### OPcached" cli-php-zephir-cblock

echo "## Optimizer"
exec_dir "### No options" cli-php-zephir-optimizer exec_no_opcache.sh
exec_dir "### OPcached" cli-php-zephir-optimizer

echo "## Zephir Lang"
exec_dir "### No options" cli-php-zephir exec_no_opcache.sh
exec_dir "### OPcached" cli-php-zephir

echo " "
echo " "
echo "################################"
echo "# FCGI benchmarking            #"
echo "################################"
echo " "
echo " "
echo "HHVM"
echo "===="
echo "## Extension"
exec_dir "### JITed" fcgi-hhvm-ext

echo "## PHP userland code"
exec_dir "### JITed" fcgi-hhvm-php

echo "## HACK/PHP++/PHQ userland code"
exec_dir "### JITed" fcgi-hhvm-hack

echo " "
echo "PHP"
echo "==="
echo "## Extension"
exec_dir "### OPcached" fcgi-php-ext

echo "## PHP userland code"
exec_dir "### OPcached" fcgi-php-php

echo " "
echo "Zephir"
echo "======"
echo "## CBLOCK"
exec_dir "### OPcached" fcgi-php-zephir-cblock

echo "## Optimizer"
exec_dir "### OPcached" fcgi-php-zephir-optimizer

echo "## Zephir Lang"
exec_dir "### OPcached" fcgi-php-zephir

echo " "
echo " "
echo "###################################"
echo "# Treffynnon exec script complete #"
echo "###################################"
echo " "
