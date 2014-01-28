#! /usr/bin/env bash
git clean -fd
cd hhvm-ext
./build.sh

cd ..

cd php-ext
./build.sh

cd ..
