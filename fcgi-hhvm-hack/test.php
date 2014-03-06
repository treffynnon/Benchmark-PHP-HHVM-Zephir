<?hh
/**
 * Adapted by Simon Holywell to allow for ASCII output as
 * a return value or to file via streams
 */

/* The Computer Language Benchmarks Game
   http://benchmarksgame.alioth.debian.org/
   contributed by Thomas GODART (based on Greg Buchholz's C program)
   modified by anon
*/

function write_mandelbrot_to_stream(int $w, int $h, $stream, bool $bitmap): bool {
    if($bitmap)
        fprintf($stream, "P4\n%d %d\n", $w, $h);

    $bit_num = 128;
    $byte_acc = 0;
    $iter = 50;

    $yfac = 2.0 / $h;
    $xfac = 2.0 / $w;

    $ochars = ' .:-;!/>)|&IH%*#';
    $pack_format = 'c*';

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
                 fwrite($stream, pack($pack_format, $byte_acc));
                 $bit_num = 128;
                 $byte_acc = 0;
              } else {
                 $bit_num >>= 1;
              }
          } else {
              if($i == $iter) {
                  fwrite($stream, $ochars[0]);
              } else {
                  fwrite($stream, $ochars[($i+1) & 15]);
              }
          }
       }
       if($bitmap) {
           if ($bit_num !== 128) {
              fwrite($stream, pack($pack_format, $byte_acc));
              $bit_num = 128;
              $byte_acc = 0;
           }
       } else {
          fwrite($stream, "\n");
       }
    }
    return true;
}

function treffynnon_mandelbrot_to_file(string $filename, int $w, int $h, bool $binary_output): bool {
    $file_open_type = 'w';
    if($binary_output)
        $file_open_type = 'wb';

    $stream = fopen((string) $filename, $file_open_type);
    if(false === $stream)
        return false;

    write_mandelbrot_to_stream($w, $h, $stream, $binary_output);
    fclose($stream);
    return true;
}

function treffynnon_mandelbrot_to_mem(int $w, int $h, bool $binary_output): string {
    $file_open_type = 'w+';
    if($binary_output)
        $file_open_type = 'w+b';

    $stream = fopen('php://memory', $file_open_type);
    if(false === $stream)
        return '';

    write_mandelbrot_to_stream($w, $h, $stream, $binary_output);
    rewind($stream);
    $ret = stream_get_contents($stream);
    fclose($stream);
    return $ret;
}

echo treffynnon_mandelbrot_to_mem((int) $_GET['seed'], (int) $_GET['seed'], false);