# Created at Mon Mar 03 09:50:42 EST 2008 by bthomass

namespace eval ::xounit::test {

    Class TestSystem -superclass ::xounit::TestCase

    TestSystem parameter {

    }

    TestSystem instproc assertPasses { args } {

        my assertNoError {

            eval exec $args >@ stdout
        } "$args failed"
    }

    TestSystem instproc assertFails { args } {

        my assertError {

            eval exec $args >@ stdout
        } "$args passed"
    }

    TestSystem instproc testRunTests { } {

        my assertPasses runTests xox
        my assertPasses runTests xoexception
    }

    TestSystem instproc testRunTest { } {

        my assertPasses runTest xox TestPackage
        my assertPasses runTest xoexception TestException
    }

    TestSystem instproc testRunATest { } {

        my assertPasses runATest xox TestPackage testIsPackage
        my assertPasses runATest xoexception TestException testThrowExceptionWithTclError
    }

    TestSystem instproc testRunSuite { } {

        my assertPasses runSuite test/smallSuite.xml
    }

    TestSystem instproc tearDown { } {

        #add tear down code here
    }
}


