#! /usr/bin/env bash
echo "Starting FCGI process"
php-cgi -n -d "extension=../cli-php-zephir-optimizer/treffynnonoptimizer/ext/modules/treffynnonoptimizer.so" -b /tmp/treffynnon_bench.socket &
echo "Sleep for a second to allow process to ready itself"
sleep 1

echo "Attempting to warm up the server"
for ((n=0;n<15;n++)); do
    # Using a low number for the seed to make the warm up faster
    ./"$1" 100 > /dev/null 2>&1
done