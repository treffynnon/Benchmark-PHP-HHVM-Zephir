#! /usr/bin/env bash
echo "Starting FCGI process"
php-cgi -n -d "zend_extension=opcache.so" -d "extension=../php-ext/modules/treffynnon.so" -b /tmp/treffynnon_bench.socket &
echo "Sleep for a second to allow process to ready itself"
sleep 1