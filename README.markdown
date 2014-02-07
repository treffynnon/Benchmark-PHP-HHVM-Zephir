PHP vs HHVM vs Zephir
=====================

This benchmark is using the [Mandelbrot set](http://en.wikipedia.org/wiki/Mandelbrot_set) as it's task.

![Image of the Mandelbrot set](http://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Mandel_zoom_00_mandelbrot_set.jpg/320px-Mandel_zoom_00_mandelbrot_set.jpg)

## Mandelbrot

The actual algorithm code is not mine and was written by contributors to [The Computer Language Benchmarks Game](http://benchmarksgame.alioth.debian.org/u64/performance.php?test=mandelbrot):

 - [C](http://benchmarksgame.alioth.debian.org/u64q/program.php?test=mandelbrot&lang=gcc&id=2#sourcecode)
 - [PHP](http://benchmarksgame.alioth.debian.org/u64q/program.php?test=mandelbrot&lang=php&id=1#sourcecode)

The code in the game is all licenced under a [Revised BSD license](http://benchmarksgame.alioth.debian.org/license.php).

## Running the tests

### Building
#### Prerequisites

To run the builds you will need to first ensure you have built the following from source:

 - [PHP](https://github.com/php/php)
 - [HHVM](https://github.com/facebook/hhvm/wiki#wiki-building-hhvm)
 - [Zephir](http://zephir-lang.com/install.html)

It is best to build PHP from source instead of using a precompiled package to level the playing field. You must build HHVM from source otherwise the HHVM extension won't be installable.

#### Setting environment vars

So that the build script knows where Zephir and HHVM are installed you'll need to specify the following to environment variables. Run the next two commands in your console (after adjusting the paths!):

```bash
export HPHP_HOME=/path/to/hhvm
export ZPHP_HOME=/path/to/zephir
```

#### Building the project in one hit

In the root directory of this project running the following command (turn on unlimited scrollback in your console first):

```bash
./build.sh
```

Keep an eye out for any build errors that will need to be rectified before continuing.

### Executing the tests

Tests are run a number of times so that an average can be taken (by default this is 20 times). Additionally there is a seed value - this is the value that is used to seed the Mandelbrot set calculations. The higher the seed number the more complex the calculation that the programmes must complete.

#### To screen

This can take some time to complete as it does a number of iterations with a static seed value (currently defaults to 1000).

```bash
./exec.sh
```

You can specify some options at execution time.

##### Supply the seed

This is the value that is used to seed the Mandelbrot set calculations. The higher the seed number the more complex the calculation that the programmes must complete.

```bash
./exec.sh 16000
```

##### Supply an alternate format for `time`

See the [`time` man page](http://unixhelp.ed.ac.uk/CGI/man-cgi?time) for more information on the tokens you can use.

```bash
./exec.sh 1600 "Time in seconds: %e CPU: %P"
```

#### To reporting CSVs

This will be quite slow as it does a number of iterations with a number of different seeds:

 - iterations x seed
 - 20 x 100
 - 20 x 200
 - 20 x 1000
 - 20 x 5000
 - 20 x 16000
 
```bash
./reporting_exec.sh
```

This will output a csv file for each item listed above and additionally a parsed (averaged and prettified) csv for each test.

You can specify some options at execution time.

##### How many iterations?

Tests are run a number of times so that an average can be taken (by default this is 20 times). The following would run all the tests 100 times.

```bash
./reporting_exec.sh 100
```

## Licence

This package falls under the [3-clause BSD licence](http://opensource.org/licenses/BSD-3-Clause). See LICENCE.markdown for more.
