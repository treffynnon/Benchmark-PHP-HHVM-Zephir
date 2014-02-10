<?php

echo "Parsing the file...\n";

$tmp = [];
$out_filename = 'graph.csv';

$i = 1;
while($i < $argc) {
    if(($fh = fopen($argv[$i], 'r')) !== false) {
        $row = 0;
        while(($data = fgetcsv($fh, 2000, ",")) !== false) {
            if(++$row == 1 && 1 == $i) {
                $tmp['Header'][] = 'Language';
            } else {
                if(1 == $i) {
                    $tmp['Header'][] = $data[0] . ' ' . $data[1];
                }
                if($row == 2) {
                    $tmp[$i][] = $data[2];
                }
                if($row > 1) {
                    $tmp[$i][] = $data[4];
                }
            }
        }
    }
    unset($data);
    fclose($fh);
    $i++;
}

if(($fh = fopen($out_filename, 'w')) !== false) {
    foreach($tmp as $line) {
        foreach($line as $key => $field) {
            if(is_string($field)) {
                $line[$key] = '"' . $field . '"';
            }
        }
        fwrite($fh, implode(',', $line) . "\n", 2000);
    }
}
fclose($fh);

echo "Done\n";
