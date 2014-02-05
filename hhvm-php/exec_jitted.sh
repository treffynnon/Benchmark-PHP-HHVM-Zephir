#! /usr/bin/env bash

# This run exists because of http://www.hhvm.com/blog/713/hhvm-optimization-tips
# tl;dr HHVM cannot JIT code in global space
#
# Additionally as we are running it via the CLI we must manually enable JIT: http://www.leaseweblabs.com/2013/09/benchmarking-hiphopvm-php-5-3-ubuntu-12-04/#comment-6630


if [[ "$HPHP_HOME" == "" ]]; then
    echo "HPHP_HOME environment variable must be set!"
    echo 'export HPHP_HOME=/path/to/hhvm'
    exit 1
fi
ARG=1000
if [ "$1" != "" ]; then
    ARG="$1"
fi
if [ "$2" != "" ]; then
    TIMEFORMAT="--format=$2"
fi
/usr/bin/env time "$TIMEFORMAT" $HPHP_HOME/hphp/hhvm/hhvm -vEval.Jit=1 ../php-php/test.php "$ARG"