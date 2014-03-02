#! /usr/bin/env bash
php-cgi -n -d "zend_extension=opcache.so" -d "extension=../php-ext/modules/treffynnon.so" -b /tmp/treffynnon_bench.socket &
