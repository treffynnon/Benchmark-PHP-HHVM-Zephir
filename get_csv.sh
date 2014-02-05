#! /usr/bin/env bash

OUTPUT="results.csv"
SEED=1000
ITERATIONS=10
if [ "$1" != "" ]; then
    SEED="$1"
fi
if [ "$2" != "" ]; then
    ITERATIONS="$2"
fi
if [ "$3" != "" ]; then
    OUTPUT="$3"
fi

# Print CSV headers out
echo '"Dir", "Title", "Seed", "CPU - user mode", "CPU - kernel mode", "Time elapsed", "Percentage CPU for job", "Mem: Shared text space (Kb)", "Mem: Unshared data area (Kb)", "Mem: Max resident set size (Kb)", "I/O: FS inputs", "I/O: FS outputs", "Major page faults", "Minor page faults", "Swaps"' > "$OUTPUT"

for ((n=0;n<$ITERATIONS;n++))
do
 echo "Iterating"
 ./exec.sh "$SEED" csv > /dev/null 2>> "$OUTPUT"
done
