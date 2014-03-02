#! /usr/bin/env bash
php-cgi -n -d "zend_extension=opcache.so" -b /tmp/treffynnon_php.socket &
