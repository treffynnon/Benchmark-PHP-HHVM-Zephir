#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include<stdio.h>
#include<string.h>
#include<stdarg.h>
#include<stdlib.h>
#include<stdbool.h>

#include "php.h"
#include "php_ini.h"
#include "ext/standard/info.h"
#include "SAPI.h"
#include "php_treffynnon.h"

ZEND_BEGIN_ARG_INFO_EX(arginfo_treffynnon_mandelbrot_to_file, 0, 0, 4)
    ZEND_ARG_INFO(0, filename)
    ZEND_ARG_INFO(0, w)
    ZEND_ARG_INFO(0, h)
    ZEND_ARG_INFO(0, binary_output)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_INFO_EX(arginfo_treffynnon_mandelbrot_to_mem, 0, 0, 3)
    ZEND_ARG_INFO(0, w)
    ZEND_ARG_INFO(0, h)
    ZEND_ARG_INFO(0, binary_output)
ZEND_END_ARG_INFO()

/* {{{ treffynnon_functions[]
 */
const zend_function_entry treffynnon_functions[] = {
    PHP_FE(treffynnon_mandelbrot_to_file, arginfo_treffynnon_mandelbrot_to_file)
    PHP_FE(treffynnon_mandelbrot_to_mem, arginfo_treffynnon_mandelbrot_to_mem) {
        NULL, NULL, NULL}
};
/* }}} */

/* {{{ PHP_MINFO_FUNCTION
*/
PHP_MINFO_FUNCTION(treffynnon) {
    php_info_print_table_start();
    php_info_print_table_row(2, PHP_TREFFYNNON_EXTNAME " Module", "enabled");
    php_info_print_table_row(2, "version", PHP_TREFFYNNON_VERSION);
    if (sapi_module.phpinfo_as_text) {
        /* No HTML for you */
        php_info_print_table_row(2, "By",
                "Simon Holywell\nhttp://www.simonholywell.com");
    } else {
        /* HTMLified version */
        php_printf("<tr>"
                "<td class=\"v\">By</td>"
                "<td class=\"v\">"
                "<a href=\"http://www.simonholywell.com\""
                " alt=\"Simon Holywell\">"
                "Simon Holywell"
                "</a></td></tr>");
    }
    php_info_print_table_end();
}
/* }}} */


/*
 * Function adapted from example in The Computer
 * Languages Benchmark Game
 *
 * ASCII switch added by Simon Holywell and inspired
 * by code from Glenn Rhoads
 * (http://docs.parrot.org/parrot/0.9.1/html/examples/pir/mandel.pir.html)
 */
bool write_mandelbrot_to_stream(int w, int h, FILE *stream, bool bitmap) {
    int bit_num = 0;
    char byte_acc = 0;
    int i, iter = 50;
    double x, y, limit = 2.0;
    double Zr, Zi, Cr, Ci, Tr, Ti;
    const char* ochars = " .:-;!/>)|&IH%*#";

    if(bitmap)
        fprintf(stream, "P4\n%d %d\n", w, h);

    for(y=0;y<h;++y) 
    {
        for(x=0;x<w;++x)
        {
            Zr = Zi = Tr = Ti = 0.0;
            Cr = (2.0*x/w - 1.5); Ci=(2.0*y/h - 1.0);

            for (i=0;i<iter && (Tr+Ti <= limit*limit);++i)
            {
                Zi = 2.0*Zr*Zi + Ci;
                Zr = Tr - Ti + Cr;
                Tr = Zr * Zr;
                Ti = Zi * Zi;
            }

            if(bitmap) {
                byte_acc <<= 1; 
                if(Tr+Ti <= limit*limit) byte_acc |= 0x01;

                ++bit_num; 

                if(bit_num == 8)
                {
                    putc(byte_acc, stream);
                    byte_acc = 0;
                    bit_num = 0;
                }
                else if(x == w-1)
                {
                    byte_acc <<= (8-w%8);
                    putc(byte_acc, stream);
                    byte_acc = 0;
                    bit_num = 0;
                }
            } else {
                if(iter == i) {
                    putc(ochars[0], stream);
                } else {
                    putc(ochars[i & 15], stream);
                }
            }
        }
        if(!bitmap)
            putc('\n', stream);
    }
    return true;
}

bool mandelbrot_to_file(const char *filename, const int w, const int h, bool binary_output) {
    FILE *stream;
    char *file_open_type = "w";

    if(binary_output) {
        file_open_type = "wb";
    }

    stream = fopen(filename, file_open_type);
    if(stream == NULL)
        return false;

    write_mandelbrot_to_stream(w, h, stream, binary_output);
    fclose(stream);
    return true;
}

char* mandelbrot_to_mem(const int w, const int h, bool binary_output) {
    FILE *stream;
    char *char_buffer;
    size_t buffer_size = 0;

    stream = open_memstream(&char_buffer, &buffer_size);
    if(stream == NULL)
        return "";

    write_mandelbrot_to_stream(w, h, stream, binary_output);
    fclose(stream);
    return char_buffer;
}

/* {{{ proto bool treffynnon_mandelbrot_to_file(string filename, int w, int h, bool binary_output)
*/
PHP_FUNCTION(treffynnon_mandelbrot_to_file) {
    char filename;
    int filename_len;
    long w,h;
    bool binary_output;

    if (zend_parse_parameters(ZEND_NUM_ARGS() TSRMLS_CC, "sllb", &filename, &filename_len, &w, &h, &binary_output) == FAILURE) {
        RETURN_NULL();
    }

    if(mandelbrot_to_file(filename, (int) w, (int) h, binary_output)) {
        RETURN_TRUE;
    } else {
        RETURN_FALSE;
    }
}
/* }}} */

/* {{{ proto string treffynnon_mandelbrot_to_mem(int w, int h, bool binary_output)
*/
PHP_FUNCTION(treffynnon_mandelbrot_to_mem) {
    long w,h;
    bool binary_output;

    if (zend_parse_parameters(ZEND_NUM_ARGS() TSRMLS_CC, "llb", &w, &h, &binary_output) == FAILURE) {
        RETURN_NULL();
    }

    // the 1 at the end here stops the code from trying to free our
    // stream for us, which would throw a segfault!
    RETURN_STRING(mandelbrot_to_mem((int) w, (int) h, binary_output), 1);
}
/* }}} */

/* {{{ treffynnon_module_entry
*/
zend_module_entry treffynnon_module_entry = {
#if ZEND_MODULE_API_NO >= 20010901
    STANDARD_MODULE_HEADER,
#endif
    PHP_TREFFYNNON_EXTNAME,
    treffynnon_functions,
    NULL /* PHP_MINIT(treffynnon) */,
    NULL /* PHP_MSHUTDOWN(treffynnon) */,
    NULL /* PHP_RINIT(treffynnon) */, /* Replace with NULL if there's nothing to do at request start */
    NULL /* PHP_RSHUTDOWN(treffynnon)*/, /* Replace with NULL if there's nothing to do at request end */
    PHP_MINFO(treffynnon),
#if ZEND_MODULE_API_NO >= 20010901
    PHP_TREFFYNNON_VERSION,
#endif
    STANDARD_MODULE_PROPERTIES
};
/* }}} */

#ifdef COMPILE_DL_TREFFYNNON
ZEND_GET_MODULE(treffynnon)
#endif
