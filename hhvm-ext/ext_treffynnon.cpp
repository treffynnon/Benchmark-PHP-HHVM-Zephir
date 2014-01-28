/**
 * @author Simon Holywell <treffynnon@php.net>
 * @license BSD <http://opensource.org/licenses/BSD-3-Clause>
 */

#include "hphp/runtime/base/base-includes.h"

namespace HPHP {
    static String HHVM_FUNCTION(treffynnon, int64_t arg) {
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
