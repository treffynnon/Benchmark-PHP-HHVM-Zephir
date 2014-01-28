#! /usr/bin/env bash
/usr/bin/gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -std=c99 -mfpmath=sse -msse2 -fopenmp mandelbrot.c -o mandelbrot
