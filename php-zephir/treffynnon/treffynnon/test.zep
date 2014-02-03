namespace Treffynnon;

class Test {
    public static function write_mandelbrot_to_stream(int w, int h, stream, bool bitmap) -> bool
    {
        if(bitmap) {
            fprintf(stream, "P4\n%d %d\n", w, h);
        }

        int bit_num = 128;
        int byte_acc = 0;
        int iter = 50;

        int yfac = 0; let yfac = (2.0 / h);
        int xfac = 0; let xfac = (2.0 / w);

        string curr_char = "", space = "";
        string ochars = " .:-;!/>)|&IH%*#";
        let space = ochars[0];
        string pack_format = "c*";

        double iter_check = 4.0;

        int y = 0;
        int x = 0;
        int i = 0;
        while(y < h) {
            let y += 1;
            double Ci = 0; let Ci = y * yfac - 1.0;

            let x = 0;
            while (x < w) {
                let x += 1;
                double Zr = 0;
                double Zi = 0;
                double Tr = 0;
                double Ti = 0.0;

                double Cr = 0; let Cr = x * xfac - 1.5;

                do {
                    let i = 0;
                    while (i < iter) {
                        let i += 1;
                        let Zi = 2.0 * Zr * Zi + Ci;
                        let Zr = $Tr - $Ti + $Cr;
                        let Tr = Zr * Zr;
                        let Ti = Zi * Zi;
                        double a_tmp = 0;
                        let a_tmp = Tr + Ti;
                        // this would normally be written as if((Tr+Ti) > 4.0)
                        // but must be done with variables as the Zephir compiler
                        // doesn't understand how to do the comparison otherwise
                        if (a_tmp > iter_check) { break; }
                    }
                    if (a_tmp > iter_check) { break; }
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

    public static function treffynnon_mandelbrot_to_file(string filename, long w, long h, bool binary_output) -> bool
    {
        bool ret = false;
        %{
        ret = mandelbrot_to_file(Z_STRVAL_P(filename), w, h, binary_output);
        }%
        return ret;
    }
}
