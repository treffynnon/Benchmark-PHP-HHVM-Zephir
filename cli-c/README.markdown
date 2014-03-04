Mandelbrot in C
===============

This is a simple C programme to print the Mandelbrot set as ASCII or as a .pbm (Portable Bitmap). ASCII can be read in a console and the .pbm can be viewed in something like GIMP.

The [original code](http://benchmarksgame.alioth.debian.org/u64q/program.php?test=mandelbrot&lang=gcc&id=2#sourcecode) is from [The Computer Languages Benchmark Game](http://benchmarksgame.alioth.debian.org) and I have modified it (with inspiration from [Glenn Rhoads code](http://docs.parrot.org/parrot/0.9.1/html/examples/pir/mandel.pir.html)) to include the ASCII output.

## Build

Run `./build.sh`.

## Usage

To run the benchmark you can call `./exec.sh`.

You can run the code manually by running `./mandelbrot 100` for a set that is 100 heigh and 100 wide in ASCII printed to STDOUT.

Specify `./mandelbrot 100 1` for binary or `./mandelbrot 100 0` for the default ASCII.

Finally, you can call `./mandelbrot 100 1 output.pbm` to have it save the portable bitmap to a file. To save the ASCII as a file you can run `./mandelbrot 100 0 output.txt`.
