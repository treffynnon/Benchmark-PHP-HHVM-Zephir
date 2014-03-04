PHP_ARG_WITH(treffynnon, for treffynnon support,
[ --with-treffynnon[=DIR] Include treffynnon support. DIR is the optional path to the treffynnon directory.], yes)
PHP_ARG_ENABLE(treffynnon-debug, whether to enable build debug output,
[ --enable-treffynnon-debug treffynnon: Enable debugging during build], no, no)

if test "$PHP_TREFFYNNON" != "no"; then
  withtreffynnon="$PHP_TREFFYNNON"
  treffynnon_enabledebug="$PHP_TREFFYNNON_DEBUG"
      PHP_NEW_EXTENSION(treffynnon, treffynnon.c, $ext_shared)
      PHP_SUBST(TREFFYNNON_SHARED_LIBADD)
else
  AC_MSG_RESULT([treffynnon was not enabled])
  AC_MSG_ERROR([Enable treffynnon to build this extension.])
fi
