#! /usr/bin/env bash
ARG=1000
TIMEFORMAT="-v"
if [ "$1" != "" ]; then
    ARG="$1"
fi
if [ "$2" != "" ]; then
    TIMEFORMAT="--format=$2"
fi
/usr/bin/env time "$TIMEFORMAT" /usr/bin/env php -n -d "extension=modules/treffynnon.so" -d "zend_extension=opcache.so" -d "opcache.enable_cli=1" -f test.php "$ARG"
