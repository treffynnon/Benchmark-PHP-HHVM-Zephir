#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include<stdio.h>

#include "php.h"
#include "php_ini.h"
#include "ext/standard/info.h"
#include "SAPI.h"
#include "php_treffynnon.h"

ZEND_BEGIN_ARG_INFO_EX(arginfo_treffynnon, 0, 0, 1)
    ZEND_ARG_INFO(0, arg)
ZEND_END_ARG_INFO()

/* {{{ treffynnon_functions[]
 */
const zend_function_entry treffynnon_functions[] = {
    PHP_FE(treffynnon, arginfo_treffynnon) {
        NULL, NULL, NULL}
};

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

int mandelbrot (long arg)
{
    long w, h = 0;
    int bit_num = 0;
    char byte_acc = 0;
    int i, iter = 50;
    double x, y, limit = 2.0;
    double Zr, Zi, Cr, Ci, Tr, Ti;
    
    w = h = arg;

//    printf("P4\n%d %d\n",w,h);

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
       
            byte_acc <<= 1; 
            if(Tr+Ti <= limit*limit) byte_acc |= 0x01;
                
            ++bit_num; 

            if(bit_num == 8)
            {
                putc(byte_acc,stdout);
                byte_acc = 0;
                bit_num = 0;
            }
            else if(x == w-1)
            {
                byte_acc <<= (8-w%8);
                putc(byte_acc,stdout);
                byte_acc = 0;
                bit_num = 0;
            }
        }
    }   
}

/* {{{ proto string treffynnon(int arg)
*/
PHP_FUNCTION(treffynnon) {
    long arg;

    if (zend_parse_parameters(ZEND_NUM_ARGS() TSRMLS_CC, "l", &arg) == FAILURE) {
        RETURN_NULL();
    }

    mandelbrot(arg);

    RETURN_STRING("treffynnon function executed.", 0);
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
