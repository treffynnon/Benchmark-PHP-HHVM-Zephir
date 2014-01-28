#! /usr/bin/env bash
ARG=1000
if [ "$1" != "" ]; then
    ARG="$1"
fi
/usr/bin/env time ./mandelbrot "$ARG" >/dev/null
