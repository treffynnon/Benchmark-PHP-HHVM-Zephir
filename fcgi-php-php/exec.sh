#! /usr/bin/env bash
ARG=1000
TIMEFORMAT="-v"
if [ "$1" != "" ]; then
    ARG="$1"
fi
if [ "$2" != "" ]; then
    TIMEFORMAT="--format=$2"
fi
/usr/bin/env time "$TIMEFORMAT" ../fcgicli/fcgicli "/tmp/treffynnon_bench.socket" "`pwd`/test.php" "$ARG"
