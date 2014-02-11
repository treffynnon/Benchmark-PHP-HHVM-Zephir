#! /usr/bin/env bash
ARG=1000
if [ "$1" != "" ]; then
    ARG="$1"
fi
TIMEFORMAT="-p"
if [ "$2" != "" ]; then
    TIMEFORMAT="--format=$2"
fi
/usr/bin/env time "$TIMEFORMAT" /usr/bin/env php -n -d "zend_extension=opcache.so" -d "opcache.enable_cli=1" -f test.php "$ARG"
