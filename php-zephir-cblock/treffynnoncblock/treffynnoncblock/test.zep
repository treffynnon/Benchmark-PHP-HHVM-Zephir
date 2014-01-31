// We are using CBLOCK syntax to directly include a C function in Zephir
// See: https://github.com/phalcon/zephir/pull/21

namespace Treffynnoncblock;

%{

#include<stdio.h>
#include<string.h>
#include<stdarg.h>
#include<stdlib.h>
#include<stdbool.h>

}%

// this is the beginning of the C block
%{

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

static char* mandelbrot_to_mem(const long w, const long h, bool binary_output) {
    FILE *stream;
    char *char_buffer;
    size_t buffer_size = 0;

    stream = open_memstream(&char_buffer, &buffer_size);
    if(stream == NULL)
        return "";

    write_mandelbrot_to_stream((int) w, (int) h, stream, binary_output);
    fclose(stream);
    return char_buffer;
}

}%
// this is the end of C Block

class Test
{
    public static function treffynnon_mandelbrot_to_mem(long w, long h, bool binary_output) -> string
    {
        string ret = "";
        %{
	ret = string(mandelbrot_to_mem(w, h, binary_output));
        }%
echo ret;
        string ret2 = "SIMON";
        return ret2;
    }

    public static function treffynnon_mandelbrot_to_file(string filename, long w, long h, bool binary_output) -> bool
    {
        %{
        char *f2 = filename;
        mandelbrot_to_file(f2, w, h, binary_output);
        }%
        bool ret2 = false;
        return ret2;
    }
}
