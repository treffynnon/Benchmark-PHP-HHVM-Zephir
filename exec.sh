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
echo "HHVM: Extension"
echo "==============="
cd hhvm-ext
./exec.sh "$SEED"

cd ..

echo " "
echo "PHP: Extension"
echo "=============="
cd php-ext
./exec.sh "$SEED"

cd ..


echo " "
echo "PHP: userland code"
echo "=================="
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
echo " "
echo "###################################"
echo "# Treffynnon exec script complete #"
echo "###################################"
echo " "
