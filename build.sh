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
echo "Building plain C"
echo "================"
cd c
./build.sh

cd ..

echo " "
echo "Zephir: CBLOCK"
echo "=============="
cd php-zephir-cblock
./build.sh

cd ..

echo " "
echo "Zephir: Optimizer"
echo "================="
cd php-zephir-optimizer
./build.sh

cd ..

echo " "
echo "Zephir: Zephir lang"
echo "==================="
cd php-zephir
./build.sh

cd ..

echo " "
echo "####################################"
echo "# Treffynnon build script complete #"
echo "####################################"
echo " "