#! /usr/bin/env bash
echo "Starting FCGI process"
$HPHP_HOME/hphp/hhvm/hhvm --mode daemon -c ../cli-hhvm-ext/config.hdf -v "DynamicExtensionPath=`pwd`/../cli-hhvm-ext" -vServer.Type=fastcgi -vServer.FileSocket="/tmp/treffynnon_bench.socket" -vEval.Jit=1 &
echo "Sleep for a second to allow process to ready itself"
sleep 1
