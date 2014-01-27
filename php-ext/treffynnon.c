#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "php.h"
#include "php_ini.h"
#include "ext/standard/info.h"
#include "SAPI.h"
#include "php_treffynnon.h"

ZEND_BEGIN_ARG_INFO(arginfo_treffynnon, 0, 0, 1)
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
PHP_MINFO_FUNCTION(ssdeep) {
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

/* {{{ proto string treffynnon(int arg)
*/
PHP_FUNCTION(treffynnon) {
    int *arg;
    int arg_len;

    if (zend_parse_parameters(ZEND_NUM_ARGS() TSRMLS_CC, "s", &arg, &arg_len) == FAILURE) {
        RETURN_NULL();
    }

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
    PHP_MINFO(ssdeep),
#if ZEND_MODULE_API_NO >= 20010901
    PHP_SSDEEP_VERSION,
#endif
    STANDARD_MODULE_PROPERTIES
};
/* }}} */

#ifdef COMPILE_DL_SSDEEP
ZEND_GET_MODULE(treffynnon)
#endif
