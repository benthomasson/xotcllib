

namespace eval xounit {

    namespace import -force ::xotcl::*

    Class create TestFailure -superclass ::xounit::TestResult

    TestFailure # TestFailure {

        TestFailure is a datastructure to hold information
        about a test failure.  It contains the information
        about the name of the test, the specific test component,
        and the error message received from the test.
    }

    TestFailure # name { name of the test }
    TestFailure # test { name of the test component }
    TestFailure # error { error message from the test failure }

    TestFailure parameter { name
                            test
                            error }

    TestFailure # message {

        returns the error message
    }

    TestFailure instproc message {} {

        return [ my error ] 
    }

    TestFailure # passed {

        returns 0  (false)
    }

    TestFailure instproc passed {} {

        return 0
    }

    TestFailure instproc numberOfPasses { } {

        return 0
    }

    TestFailure instproc numberOfFailures { } {

        return 1
    }
    TestFailure instproc numberOfErrors { } {

        return 0
    }
    TestFailure instproc numberOfTests { } {

        return 1
    }
    TestFailure instproc getStatus {} {
        return failed
    }
}
