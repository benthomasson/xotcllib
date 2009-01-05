package provide xox::test::TestDebugging 1.0

package require XOTcl
package require xox
package require xounit

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    Class TestDebugging -superclass ::xounit::TestCase

    TestDebugging instproc testDebug {} {

        set object [ Object new ]
        $object debug debug
    }

    TestDebugging instproc testStackTrace {} {

        set object [ Object new ]
        $object debug debug
        my procA
    }

    TestDebugging instproc procA {} {

        my procB

    }
    TestDebugging instproc procB {} {

        my procC

    }
    TestDebugging instproc procC {} {

        my procD

    }
    TestDebugging instproc procD {} {
        set object [ Object new ]
        puts [ $object stackTrace ]
    }

    TestDebugging instproc testError { } {

        if [ catch {
            error A
        } ] {
            puts [ my stackTrace ]
        }
        #set object [ Object new ]
        #puts [ $object stackTrace ]
    }
}

