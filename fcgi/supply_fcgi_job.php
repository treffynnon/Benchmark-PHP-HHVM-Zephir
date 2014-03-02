<?php

require __DIR__ . '/../vendor/autoload.php';
use Crunch\FastCGI\Client as FastCGI;

if(!$argc) {
   echo "You must supply parameters.\n";
   exit(1);
}

$socket = $argv[1];
$file_to_work_on = $argv[2];
$seed = (int) $argv[3];

$fastCgi = new FastCGI('unix://' . $socket, null);
$connection = $fastCgi->connect();
$request = $connection->newRequest();
$request->parameters = array(
    'GATEWAY_INTERFACE' => 'FastCGI/1.0',
    'REQUEST_METHOD' => 'GET',
    'SCRIPT_FILENAME' => $file_to_work_on,
    'CONTENT_TYPE' => '',
    'CONTENT_LENGTH' => 0,
    'QUERY_STRING' => http_build_query(array('seed' => $seed)),
);
$response = $connection->request($request);
echo $response->content. "\n";
