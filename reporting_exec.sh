#! /usr/bin/env bash

iITERATIONS=20

if [ "$1" != "" ]; then
    iITERATIONS="$1"
fi

iSEEDS=(100 200 1000 5000 16000)

for iSEED in ${iSEEDS[*]}; do
    OUTPUT="results_${iITERATIONS}x${iSEED}.csv"
    echo "$OUTPUT"
    if [ ! -e "$OUTPUT" ]; then
        echo "./reporting_collect_csv_reports.sh $iSEED $iITERATIONS $OUTPUT"
        ./reporting_collect_csv_reports.sh "$iSEED" $iITERATIONS "$OUTPUT"
    fi
done

for file in results_*; do /usr/bin/env php -n -f reporting_parse_and_compile_csv.php "$file"; done
for file in parsed_*; do /usr/bin/env php -n -f reporting_generate_charts.php "$file"; done
