#! /usr/bin/env bash
$HPHP_HOME/hphp/hhvm/hhvm -c config.hdf -v "DynamicExtensionPath=`pwd`" test.php
