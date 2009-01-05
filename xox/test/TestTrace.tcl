package provide xox::test::TestTrace 1.0

package require XOTcl
package require xox
package require xounit

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    Class TestTrace -superclass ::xounit::TestCase

    TestTrace instproc testExists {} {

        my assertObject ::xox::Trace
    }
}

