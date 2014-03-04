#! /usr/bin/env bash
if [[ "$ZPHP_HOME" == "" ]]; then
    echo "ZPHP_HOME environment variable must be set!"
    echo 'export ZPHP_HOME=/path/to/zephir'
    exit 1
fi
cd treffynnonoptimizer
$ZPHP_HOME/bin/zephir compile
cd ..
