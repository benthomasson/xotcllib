package provide xox::test::TestSpy 1.0

package require XOTcl
package require xox

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    ::xotcl::Class TestSpy -superclass ::xounit::TestCase

    TestSpy instproc test {} {

        ::xox::Spy countAllInstances
        ::xox::Spy countInstances
    }
}
