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
CSV_HEADERS='

Dir,
Title,
Seed,
Time: Elapsed real time (in [hours:]minutes:seconds),
Time: Elapsed real time (in seconds) (Not in tcsh),
Time: Total number of CPU-seconds that the process spent in kernel mode,
Time: Total number of CPU-seconds that the process spent in user mode,
"Percentage of the CPU that this job got, computed as (%U + %S) / %E",
"Mem: Maximum resident set size of the process during its lifetime, in Kbytes",
"Mem: Average resident set size of the process, in Kbytes (Not in tcsh)",
"Mem: Average total (data+stack+text) memory use of the process, in Kbytes",
"Mem: Average size of the process unshared data area, in Kbytes",
"Mem: Average size of the process unshared stack space, in Kbytes (Not in tcsh.)",
"Mem: Average size of the process shared text space, in Kbytes",
"Mem: System page size, in bytes. This is a per-system constant, but varies between systems (Not in tcsh.)",
Mem: Number of major page faults that occurred while the process was running. These are faults where the page has to be read in from disk,
"Mem: Number of minor, or recoverable, page faults. These are faults for pages that are not valid but which have not yet been claimed by other virtual pages. Thus the data in the page is still valid but the system tables must be updated.",
Mem: Number of times the process was swapped out of main memory,
Mem: Number of times the process was context-switched involuntarily (because the time slice expired),
"Mem: Number of waits: times that the program was context-switched voluntarily, for instance while waiting for an I/O operation to complete",
I/O: Number of file system inputs by the process,
I/O: Number of file system outputs by the process,
I/O: Number of socket messages received by the process,
I/O: Number of socket messages sent by the process,
I/O: Number of signals delivered to the process,
I/O: Name and command-line arguments of the command being timed (Not in tcsh.),
I/O: Exit status of the command (Not in tcsh.)

'

# Strip new lines from the headers
CSV_HEADERS=`echo "$CSV_HEADERS" | tr -d '\n'`

echo "$CSV_HEADERS" > "$OUTPUT"

# See: http://linux.die.net/man/1/time
TIMEFORMAT='%E, %e, %S, %U, %P, %M, %t, %K, %D, %p, %X, %Z, %F, %R, %W, %c, %w, %I, %O, %r, %s, %k, "%C", %x'

# Strip spaces from the format string to reduce filesize
TIMEFORMAT=`echo "$TIMEFORMAT" | tr -d ' '`

for ((n=0;n<$ITERATIONS;n++))
do
 echo "Iterating"
 ./exec.sh "$SEED" "$TIMEFORMAT" > /dev/null 2>> "$OUTPUT"
done