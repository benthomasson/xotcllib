

namespace eval xounit {

    namespace import -force ::xotcl::*

    Class create TestPass -superclass ::xounit::TestResult

    TestPass # TestPass {

        TestFailure is a datastructure to hold information
        about a test passing.  It contains the information
        about the name of the test, the specific test component,
        and the return value received from the test.
    }

    TestPass # name { name of the test }
    TestPass # test { name of the test component }
    TestPass # return { returned string from the test }

    TestPass parameter { 
        name 
        { test {} }
        { return {} }
    }


    TestPass # message {

        returns the returned string
    }

    TestPass instproc message {} {

        return [ my return ] 
    }

    TestPass # passed {

        returns 1  (true)
    }

    TestPass instproc passed {} {

        return 1
    }

    TestPass instproc numberOfPasses { } {

        return 1
    }

    TestPass instproc numberOfFailures { } {

        return 0
    }
    TestPass instproc numberOfErrors { } {

        return 0
    }
    TestPass instproc numberOfTests { } {

        return 1
    }

    TestPass instproc getStatus {} {
        return passed
    }
}

