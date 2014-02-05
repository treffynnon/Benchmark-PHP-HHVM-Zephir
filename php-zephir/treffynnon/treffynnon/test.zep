namespace Treffynnon;

class Test {
    public static function write_mandelbrot_to_stream(int w, int h, stream, bool bitmap) -> bool
    {
        int bit_num = 128,
            byte_acc = 0,
            iter = 50,
            y = 0,
            x = 0,
            i = 0;

        double Ci = 0,
               Cr = 0,
               Zr = 0,
               Zi = 0,
               Tr = 0,
               Ti = 0.0,
               yfac = 0,
               xfac = 0,
               iter_check = 4.0,
               Tr_and_Ti = 0.0;

        string curr_char = "",
               space = "",
               ochars = " .:-;!/>)|&IH%*#",
               pack_format = "c*";

        if(bitmap) {
            fprintf(stream, "P4\n%d %d\n", w, h);
        }

        let yfac = (2.0 / h);
        let xfac = (2.0 / w);

        let space = ochars[0];

        while(y < h) {
            let Ci = y * yfac - 1.0;

            let x = 0;
            while (x < w) {
                let Zr = 0;
                let Zi = 0;
                let Tr = 0;
                let Ti = 0.0;

                let Cr = x * xfac - 1.5;

                do {
                    let i = 0;
                    while (i < iter) {
                        let Zi = 2.0 * Zr * Zi + Ci;
                        let Zr = Tr - Ti + Cr;
                        let Tr = Zr * Zr;
                        let Ti = Zi * Zi;
                        let Tr_and_Ti = Tr + Ti;
                        // this would normally be written as if((Tr+Ti) > 4.0)
                        // but must be done with variables as the Zephir compiler
                        // doesn't understand how to do the comparison otherwise
                        if (Tr_and_Ti > iter_check) { break; }
                        let i += 1;
                    }
                    if (Tr_and_Ti > iter_check) { break; }
                    let byte_acc += bit_num;
                } while (false);

                if(bitmap) {
                    if (bit_num === 1) {
                        fwrite(stream, pack(pack_format, byte_acc));
                        let bit_num = 128;
                        let byte_acc = 0;
                    } else {
                        // Zephir doesn't understand bitwise operations in tandem with
                        // assignment so we must either drop down to C in a CBLOCK to
                        // perform the operation or break it into its constituent
                        // parts. Otherwise it would be:
                        // let bit_num >>= 1;
                        let bit_num = bit_num >> 1;

                        // the CBLOCK version would look like:
                        // %{
                        // bit_num >>= 1;
                        // }%
                    }
                } else {
                    if(i == iter) {
                        fwrite(stream, space);
                    } else {
                        let curr_char = ochars[i & 15];
                        fwrite(stream, curr_char);
                    }
                }
                let x += 1;
            }
            if(bitmap) {
                if (bit_num !== 128) {
                    fwrite(stream, pack(pack_format, byte_acc));
                    let bit_num = 128;
                    let byte_acc = 0;
                }
            } else {
                fwrite(stream, "\n");
            }
            let y += 1;
        }
        return true;
    }

    public static function treffynnon_mandelbrot_to_mem(int w, int h, bool binary_output) -> string
    {
        var stream; // it is a resource so we can use a static type here unfortunately in Zephir
        string file_open_type = "w+";
        var ret = ""; // return values from PHP functions can only be assigned to variant variables so we can't use a static here either
        if(binary_output) {
            let file_open_type = "w+b";
        }

        let stream = fopen("php://memory", file_open_type);
        // yoda conditions don't appear to be supported so false === stream below will not work
        // as Zephir appears to try to resolve the keyword false to a variable
        if(stream === false) {
            return "";
        }

        self::write_mandelbrot_to_stream(w, h, stream, binary_output);
        rewind(stream);
        let ret = stream_get_contents(stream);
        fclose(stream);
        return ret;
    }

    public static function treffynnon_mandelbrot_to_file(string filename, int w, int h, bool binary_output) -> bool
    {
        var stream; // it is a resource so we can use a static type here unfortunately in Zephir
        string file_open_type = "w";
        if(binary_output) {
            let file_open_type = 'wb';
        }

        let stream = fopen(filename, file_open_type);
        if(stream === false) {
            return false;
        }

        return self::write_mandelbrot_to_stream(w, h, stream, binary_output);
    }
}
