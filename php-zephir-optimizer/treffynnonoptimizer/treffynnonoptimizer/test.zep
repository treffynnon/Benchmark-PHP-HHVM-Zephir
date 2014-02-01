namespace Treffynnonoptimizer;

class Test
{
    public static function treffynnon_mandelbrot_to_mem(long w, long h, bool binary_output) -> string
    {
        return mandelbrot_to_mem(w, h, binary_output);
    }

    public static function treffynnon_mandelbrot_to_file(string filename, long w, long h, bool binary_output) -> bool
    {
        return mandelbrot_to_file(filename, w, h, binary_output);
    }
}
