#! /usr/bin/env bash
if [[ "$HPHP_HOME" == "" ]]; then
    echo "HPHP_HOME environment variable must be set!"
    echo 'export HPHP_HOME=/path/to/hhvm'
    exit 1
fi
$HPHP_HOME/hphp/tools/hphpize/hphpize
cmake .
make
