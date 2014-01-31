#! /usr/bin/env bash
ARG=1000
if [ "$1" != "" ]; then
    ARG="$1"
fi
/usr/bin/env time /usr/bin/env php -n -d "extension=modules/treffynnon.so" -f test.php "$ARG" > /dev/null
