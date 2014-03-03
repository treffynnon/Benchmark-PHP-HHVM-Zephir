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
read -p "All untracked and .gitignored files will be removed! Are you sure you wish to continue? " -n 1 -r
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

if [[ ! -f composer.phar ]]; then
    echo " "
    echo "Install Composer and Composer supplied dependencies"
    echo "==================================================="
    echo " " 
    curl -sS https://getcomposer.org/installer | php
    php composer.phar install
fi
php composer.phar dumpautoload -o

echo " "
echo "####################################"
echo "# Treffynnon build script complete #"
echo "####################################"
echo " "
