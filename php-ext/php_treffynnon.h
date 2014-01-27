#ifndef PHP_TREFFYNNON_H
#    define PHP_TREFFYNNON_H 1
#    define PHP_TREFFYNNON_VERSION "1.0.0"
#    define PHP_TREFFYNNON_EXTNAME "treffynnon"
     PHP_FUNCTION(treffynnon);
     extern zend_module_entry php_treffynnon_module_entry;
#    define phpext_php_treffynnon_ptr &php_treffynnon_module_entry
#endif
