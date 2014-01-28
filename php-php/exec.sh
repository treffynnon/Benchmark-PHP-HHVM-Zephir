#! /usr/bin/env bash
ARG=1000
if [ "$1" != "" ]; then
    ARG="$1"
fi
/usr/bin/env time /usr/bin/php5 -n -f mandelbrot.php "$ARG" >/dev/null
