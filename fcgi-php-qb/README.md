QB
==

There are a couple of caveats with this implementation:

1. QB doesn't handle streams being passed as parameters so I am printing the output and catching it using `ob_start()` to simulate a memory stream. When I emailed Chung he said this would probably be the closest to the original algorithm I'd be able to get.
2. You can't echo the result of a PHP function from QB directly and you must assign it to a variable first hence the lines like `print $tmp = pack()`. You can print directly from QB functions though.
