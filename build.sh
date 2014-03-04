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
echo "All untracked and .gitignored files will be removed! (This includes results from previous runs)"
read -p "Are you sure you wish to do this (y/n)? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    git clean -fdx
fi

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
echo "Setup FCGI CLI client"
echo "==================================================="
echo " "
git submodule init
git submodule update
cd fcgicli
git checkout master
git pull origin master
make
cd ..

echo " "
echo "####################################"
echo "# Treffynnon build script complete #"
echo "####################################"
echo " "
