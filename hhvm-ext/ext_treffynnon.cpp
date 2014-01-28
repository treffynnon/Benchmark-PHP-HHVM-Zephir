/**
 * @author Simon Holywell <treffynnon@php.net>
 * @license BSD <http://opensource.org/licenses/BSD-3-Clause>
 */

#include "hphp/runtime/base/base-includes.h"
#include<stdio.h>

int64_t mandelbrot (int64_t arg)
{
    int64_t w, h = 0;
    int64_t bit_num = 0;
    char byte_acc = 0;
    int64_t i, iter = 50;
    double x, y, limit = 2.0;
    double Zr, Zi, Cr, Ci, Tr, Ti;
    
    w = h = arg;

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
       
            byte_acc <<= 1; 
            if(Tr+Ti <= limit*limit) byte_acc |= 0x01;
                
            ++bit_num; 

            if(bit_num == 8)
            {
                putc(byte_acc,stdout);
                byte_acc = 0;
                bit_num = 0;
            }
            else if(x == w-1)
            {
                byte_acc <<= (8-w%8);
                putc(byte_acc,stdout);
                byte_acc = 0;
                bit_num = 0;
            }
        }
    }   
    return 0;
}

namespace HPHP {
    static String HHVM_FUNCTION(treffynnon, int64_t arg) {
        mandelbrot(arg);
        return String("Function has returned something.");
    }

    class treffynnonExtension: public Extension {
        public:
            treffynnonExtension(): Extension("treffynnon") { /* null */ }
            virtual void moduleInit() {
                HHVM_FE(treffynnon);
                loadSystemlib();
            }
    } s_treffynnon_extension;
    HHVM_GET_MODULE(treffynnon);
}
