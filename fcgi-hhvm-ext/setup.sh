#! /usr/bin/env bash
echo "Starting FCGI process"
H_CONFIG=$(readlink -f "`pwd`/../cli-hhvm-ext/config.hdf")
H_EXT_PATH=$(readlink -f "`pwd`/../cli-hhvm-ext")
$HPHP_HOME/hphp/hhvm/hhvm --mode server -c "$H_CONFIG" -v "DynamicExtensionPath=$H_EXT_PATH" -vServer.Type=fastcgi -vServer.FileSocket="/tmp/treffynnon_bench.socket" -vEval.Jit=1 > /dev/null 2>&1 &
echo "Sleep for a bit to allow process to ready itself"
sleep 5

echo "Attempting to warm up the server"
for ((n=0;n<15;n++)); do
    # Using a low number for the seed to make the warm up faster
    ./"$1" 100  > /dev/null 2>&1
done
