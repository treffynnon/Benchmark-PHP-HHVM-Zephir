<?php
/**
 * Adapted by Simon Holywell to allow for ASCII output as
 * a return value or to file via streams
 */

/* The Computer Language Benchmarks Game
   http://benchmarksgame.alioth.debian.org/
   contributed by Thomas GODART (based on Greg Buchholz's C program) 
   modified by anon
*/

/**
* Write mandelbrot_to_stream
*
* @engine qb
* @param int32 $[hw]
* @param bool $bitmap
* @local int32 $[xy]
* @local char $byte_acc
* @local int32 $bit_num
* @local string $ochars
* @local float64 $.*
*
* @return bool
*
*/
function write_mandelbrot_to_stream($w, $h, $bitmap) {
    if($bitmap)
        printf("P4\n%d %d\n", $w, $h);

    $bit_num = 128;
    $byte_acc = 0;
    $iter = 50;

    $yfac = 2.0 / $h;
    $xfac = 2.0 / $w;

    $ochars = ' .:-;!/>)|&IH%*#';

    for ($y = 0 ; $y < $h ; ++$y) {
       $Ci = $y * $yfac - 1.0;
       for ($x = 0 ; $x < $w ; ++$x) {
          $Zr = 0; $Zi = 0; $Tr = 0; $Ti = 0.0;
          $Cr = $x * $xfac - 1.5;
          do {
             for ($i = 0; $i < $iter; ++$i) {
                $Zi = 2.0 * $Zr * $Zi + $Ci;
                $Zr = $Tr - $Ti + $Cr;
                $Tr = $Zr * $Zr;
                if (($Tr+($Ti = $Zi * $Zi)) > 4.0) break 2;
             }
             $byte_acc += $bit_num;
          } while (false);

          if($bitmap) {
              if ($bit_num === 1) {
                 echo $byte_acc;
                 $bit_num = 128;
                 $byte_acc = 0;
              } else {
                 $bit_num >>= 1;
              }
          } else {
              if($i == $iter) {
                  echo $ochars[0];
              } else {
                  echo $ochars[($i+1) & 15];
              }
          }
       }
       if($bitmap) {
           if ($bit_num !== 128) {
              echo $byte_acc;
              $bit_num = 128;
              $byte_acc = 0;
           }
       } else {
          echo "\n";
       }
    }
    return true;
}

function treffynnon_mandelbrot_to_file($filename, $w, $h, $binary_output) {
    $file_open_type = 'w';
    if($binary_output)
        $file_open_type = 'wb';

    $stream = fopen((string) $filename, $file_open_type);
    if(false === $stream)
        return false;

    ob_start();
    write_mandelbrot_to_stream((int) $w, (int) $h, (bool) $binary_output);
    fwrite($stream, ob_get_clean());
    return true;
}

function treffynnon_mandelbrot_to_mem($w, $h, $binary_output) {
    ob_start();
    write_mandelbrot_to_stream((int) $w, (int) $h, (bool) $binary_output);
    return ob_get_clean();
}

echo treffynnon_mandelbrot_to_mem((int) $argv[1], (int) $argv[1], false);
