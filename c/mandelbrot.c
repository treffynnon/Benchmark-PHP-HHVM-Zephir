#include<stdio.h>
#include<string.h>
#include<stdarg.h>
#include<stdlib.h>

/*
 * Function adapted from example in The Computer
 * Languages Benchmark Game
 *
 * ASCII switch added by Simon Holywell and inspired
 * by code from Glenn Rhoads
 * (http://docs.parrot.org/parrot/0.9.1/html/examples/pir/mandel.pir.html)
 */
int write_mandelbrot_to_stream(int w, int h, FILE *stream, int bitmap) {
    int bit_num = 0;
    char byte_acc = 0;
    int i, iter = 50;
    double x, y, limit = 2.0;
    double Zr, Zi, Cr, Ci, Tr, Ti;
    const char* ochars = " .:-;!/>)|&IH%*#";

    if(1 == bitmap)
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

            if(1 == bitmap) {
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
        if(0 == bitmap)
            putc('\n', stream);
    }
    return 0;
}

/*
 * Function written by ThiefMaster@StackOverflow
 * http://stackoverflow.com/a/5309508/461813
 */
const char *get_filename_ext(const char *filename) {
    const char *dot = strrchr(filename, '.');
    if(!dot || dot == filename) return "";
    return dot + 1;
}

int main (int argc, char **argv)
{
    FILE *stream;
    int w, h = 0;
    char *opentype = "w";
    char *filename = "mandelbrot.txt";
    const char *binary_ext = "pbm";
    int binary = 0;
    int memory_stream = 1;
        char *bp;
        size_t size;

    w = h = atoi(argv[1]);

    if(get_filename_ext(filename) == binary_ext) {
        opentype = "wb";
        binary = 1;
    }

    if(1 == memory_stream) {
        stream = open_memstream(&bp, &size);
    } else {
        stream = fopen(filename, opentype);
    }
    if(stream == NULL)
        exit(-1);

    write_mandelbrot_to_stream(w, h, stream, binary);

    fclose(stream);

    if(1 == memory_stream) {
        char *ret = malloc(size);
        sprintf(ret, "%s", bp);
        printf("%s", ret);
    }
    return 0;
}
