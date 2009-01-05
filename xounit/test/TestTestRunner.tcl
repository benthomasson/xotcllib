

namespace eval ::xounit::test {

    namespace import -force ::xotcl::*

    Class TestTestRunner -superclass ::xounit::TestCase

    TestTestRunner instproc testInit { } {

        set runner [ ::xounit::TestRunner new ]

        my assert [ $runner passed ]
        my assert [ $runner exists results ]
        my assertEquals [ llength [ $runner results ] ] 0 
    }

    TestTestRunner instproc testRunTests { } {

        set runner [ ::xounit::TestRunner new ]

        $runner runTests ::xounit::test::TestAssert

        my assert [ $runner passed ]
        my assert [ $runner exists results ]
        my assertEquals [ llength [ $runner results ] ] 1
    }

    TestTestRunner instproc testRunAllTests { } {

        set runner [ ::xounit::TestRunner new ]
        
        #$runner runAllTests ::xox::test

        my assert [ $runner passed ]
        my assert [ $runner exists results ]
        #my assertEquals [ llength [ $runner results ] ] 1
    }

    TestTestRunner instproc testRunAllTestsTextUI { } {

        set runner [ ::xounit::TestRunnerTextUI new ]
        
        #$runner runAllTests ::xox::test

        my assert [ $runner passed ]
        my assert [ $runner exists results ]
        #my assertEquals [ llength [ $runner results ] ] 1
    }
}

