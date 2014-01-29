#! /usr/bin/env bash

SEED=1000
if [ "$1" != "" ]; then
    SEED="$1"
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
echo " "
echo "## Extension"
cd hhvm-ext
./exec.sh "$SEED"

cd ..

echo " "
echo "## PHP userland code"
cd hhvm-php
echo "### No options"
./exec.sh "$SEED"
echo " "
echo "### In a function"
./exec_in_function.sh "$SEED"
echo " "
echo "### In a function and JITed"
./exec_jitted.sh "$SEED"
echo " "


cd ..

echo " "
echo "PHP"
echo "==="
echo " "
echo "## Extension"
cd php-ext
./exec.sh "$SEED"

cd ..


echo " "
echo "## Userland code"
cd php-php
./exec.sh "$SEED"

cd ..

echo " "
echo "C"
echo "="
cd c
./exec.sh "$SEED"

cd ..

echo " "
echo "C++"
echo "==="
cd cpp
./exec.sh "$SEED"

cd ..

echo " "
echo "Zephir"
echo "======"
echo " "
echo "## CBLOCK"
cd php-zephir-cblock
./exec.sh "$SEED"

cd ..

echo " "
echo " "
echo "###################################"
echo "# Treffynnon exec script complete #"
echo "###################################"
echo " "
