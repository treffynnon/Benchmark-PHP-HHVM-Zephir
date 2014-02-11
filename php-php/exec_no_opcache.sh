#! /usr/bin/env bash
ARG=1000
TIMEFORMAT="-v"
if [ "$1" != "" ]; then
    ARG="$1"
fi
if [ "$2" != "" ]; then
    TIMEFORMAT="--format=$2"
fi
/usr/bin/env time "$TIMEFORMAT" /usr/bin/env php -n -f test.php "$ARG"
