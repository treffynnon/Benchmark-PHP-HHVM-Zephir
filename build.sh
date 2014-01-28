#! /usr/bin/env bash
echo " "
echo "Treffynnon benchmarker"
echo "^^^^^^^^^^^^^^^^^^^^^^"
echo " "
echo "#################################"
echo "# Treffynnon build script begin #"
echo "#################################"
echo " "
echo " "
echo "Clearing previous builds"
echo "========================"
git clean -fd

echo " "
echo "Building HHVM extension"
echo "======================="
cd hhvm-ext
./build.sh

cd ..

echo " "
echo "Building PHP extension"
echo "======================"
cd php-ext
./build.sh

cd ..

echo " "
echo "####################################"
echo "# Treffynnon build script complete #"
echo "####################################"
echo " "
