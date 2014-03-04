#! /usr/bin/env bash
echo "Starting FCGI process"
$HPHP_HOME/hphp/hhvm/hhvm --mode daemon -vServer.Type=fastcgi -vServer.FileSocket="/tmp/treffynnon_bench.socket" -vEval.Jit=1 &
echo "Sleep for a second to allow process to ready itself"
sleep 1
