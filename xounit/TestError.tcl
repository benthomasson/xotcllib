


namespace eval xounit {

    namespace import -force ::xotcl::*

    Class create TestError -superclass ::xounit::TestResult

    TestError # TestError {

        TestError is a datastructure to hold information
        about a test failure.  It contains the information
        about the name of the test, the specific test component,
        and the error message received from the test.
    }

    TestError # name { name of the test }
    TestError # test { name of the test component }
    TestError # error { error message from the test failure }

    TestError parameter { name
                          { test "" }
                          { error "" } }

    TestError # message {

        returns the error message
    }

    TestError instproc message {} {

        return [ my error ] 
    }

    TestError # passed {

        returns 0  (false)
    }

    TestError instproc passed {} {

        return 0
    }

    TestError instproc numberOfPasses { } {

        return 0
    }

    TestError instproc numberOfFailures { } {

        return 0
    }
    TestError instproc numberOfErrors { } {

        return 1
    }
    TestError instproc numberOfTests { } {

        return 1
    }
    TestError instproc getStatus {} {
        return failed
    }
}

