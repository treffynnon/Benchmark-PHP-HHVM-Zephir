#! /usr/bin/env bash
ARG=1000
if [ "$1" != "" ]; then
    ARG="$1"
fi
if [ "$2" != "" ]; then
    TIMEFORMAT="--format=$2"
fi
/usr/bin/env time "$TIMEFORMAT" /usr/bin/php5 -n -d "zend_extension=opcache.so" -d "opcache.enable_cli=1" -d "opcache.memory_consumption=128" -d "opcache.interned_strings_buffer=8" -d "opcache.revalidate_freq=60" -d "opcache.fast_shutdown=1" -f test.php "$ARG"
