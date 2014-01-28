#! /usr/bin/env bash
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
./exec.sh

cd ..

echo " "
echo "PHP: Extension"
echo "=============="
cd php-ext
./exec.sh

cd ..
echo " "
echo " "
echo "###################################"
echo "# Treffynnon exec script complete #"
echo "###################################"
echo " "
