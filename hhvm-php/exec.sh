#! /usr/bin/env bash
if [[ "$HPHP_HOME" == "" ]]; then
    echo "HPHP_HOME environment variable must be set!"
    echo 'export HPHP_HOME=/path/to/hhvm'
    exit 1
fi
ARG=1000
if [ "$1" != "" ]; then
    ARG="$1"
fi
/usr/bin/env time $HPHP_HOME/hphp/hhvm/hhvm ../php-php/test.php "$ARG"
