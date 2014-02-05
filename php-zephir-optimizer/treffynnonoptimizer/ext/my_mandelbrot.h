#include<stdio.h>
#include<string.h>
#include<stdarg.h>
#include<stdlib.h>
#include<stdbool.h>

#include <php.h>

char* my_mandelbrot_to_mem(zval* w, zval* h, zval* binary_output);
bool my_mandelbrot_to_file(zval* filename, zval* w, zval* h, zval* binary_output);
