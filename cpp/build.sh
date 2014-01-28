#! /usr/bin/env bash
/usr/bin/env g++ -c -pipe -O3 -fomit-frame-pointer -march=native -mfpmath=sse -msse2 -fopenmp -mfpmath=sse -msse2 mandelbrot.cpp -o mandelbrot.gpp-5.c++.o &&  \
    /usr/bin/env g++ mandelbrot.gpp-5.c++.o -o mandelbrot -fopenmp
