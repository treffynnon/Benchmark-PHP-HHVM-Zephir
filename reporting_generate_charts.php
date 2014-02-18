<?php

echo "Parsing the files...\n";

$tmp = [];
$index_template_filename = 'graph_index_template.html';
$chart_template_filename = 'graph_chart_template.html';
$out_filename = 'index.html';

$graph_template = file_get_contents($chart_template_filename);

$i = 1;
while($i < $argc) {
    if(is_readable($argv[$i])) {
        // we have file we can graph
        $file_name = $argv[$i];
        $chart_name = 'chart-' . preg_replace('/[^a-z0-9_]/i', '-', basename($file_name));
        $chart_title = str_replace(array('parsed', 'results', '.csv', '_'), '', basename($file_name));
        $chart_title = 'Average of ' . str_replace('x', ' iterations with a seed of ', $chart_title);
        $tmp[] = str_replace(
            array('{{ chart_title }}', '{{ file_name }}', '{{ chart_name }}'),
            array($chart_title, $file_name, $chart_name),
            $graph_template
        );
    }
    $i++;
}

$index_template = file_get_contents($index_template_filename);
file_put_contents($out_filename, str_replace('{{ graphs }}', implode("\n", $tmp), $index_template));

echo "Done\n";
