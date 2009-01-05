
namespace eval ::xogrid::test {

    namespace import -force ::xotcl::*

    Class TestProcess -superclass ::xounit::TestCase

    TestProcess instproc testInit { } {

        set p [ ::xogrid::Process new -name "tclsh test/loop" ]
    }
    
    TestProcess instproc testShell { } {

        set p [ ::xogrid::Process new -name "tclsh test/loop" ]
    }

    TestProcess instproc testStart { } {

        set p [ ::xogrid::Process new -name "tclsh test/loop" ]
        $p start
        my assertNotEquals [ $p pid ] 0
    }

    TestProcess instproc testClose { } {

        set p [ ::xogrid::Process new -name "tclsh test/loop" ]
        $p start
        $p close
    }

    TestProcess instproc testPrintStdout { } {

        set p [ ::xogrid::Process new -name "tclsh test/loop" ]
        $p start
        after 10000
        $p printStdout
        $p close
    }

    TestProcess instproc testIsAlive { } {

        set p [ ::xogrid::Process new -name "tclsh test/loop" ]
        $p start

        my assert [ $p isAlive ]
        $p close
        my assertFalse [ $p isAlive ]
    }
}
