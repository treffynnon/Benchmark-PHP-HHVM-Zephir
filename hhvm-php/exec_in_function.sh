#! /usr/bin/env bash

# This run exists due to: http://www.hhvm.com/blog/713/hhvm-optimization-tips
# tl;dr any code in global scope cannot be jitted by HHVM

if [[ "$HPHP_HOME" == "" ]]; then
    echo "HPHP_HOME environment variable must be set!"
    echo 'export HPHP_HOME=/path/to/hhvm'
    exit 1
fi
ARG=1000
if [ "$1" != "" ]; then
    ARG="$1"
fi
/usr/bin/env time $HPHP_HOME/hphp/hhvm/hhvm test.php "$ARG" > /dev/null
