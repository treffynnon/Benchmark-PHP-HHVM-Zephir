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

    string ochars = " .:-;!/>)|&IH%*#";
    string pack_format = "c*";

    double iter_check = 4.0;

    int y = 0;
    int x = 0;
    int i = 0;
    while(y < h)
    {
       let y += 1;
       double Ci = 0; let Ci = y * yfac - 1.0;

       let x = 0;
       while (x < w)
       {
          let x += 1;
          double Zr = 0;
          double Zi = 0;
          double Tr = 0;
          double Ti = 0.0;

          double Cr = 0; let Cr = x * xfac - 1.5;

          do {
         let i = 0;
         while (i < iter)
         {
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
             // Zephir doesn't understand bitwise operations so we must
             // drop down to C in a CBLOCK to perform the bitwise operation
             //let bit_num >>= 1;
             %{
             
             bit_num >>= 1;
      
             }%
          }
          } else {
          if(i == iter) {
              fwrite(stream, ochars[0]);
          } else {
              fwrite(stream, ochars[i & 15]);
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



    public static function treffynnon_mandelbrot_to_mem(long w, long h, bool binary_output) -> string
    {
        $file_open_type = 'w+';
    if($binary_output)
        $file_open_type = 'w+b';

    $stream = fopen('php://memory', $file_open_type);
    if(false === $stream)
        return '';

    write_mandelbrot_to_stream((int) $w, (int) $h, $stream, (bool) $binary_output);
    rewind($stream);
    $ret = stream_get_contents($stream);
    fclose($stream);
    return $ret;
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
