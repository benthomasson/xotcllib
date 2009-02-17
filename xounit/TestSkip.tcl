# Created at Tue Feb 17 03:53:05 PM EST 2009 by dsivasub

namespace eval ::xounit {

    Class TestSkip -superclass ::xounit::TestResult

    TestSkip @doc TestSkip {

        Please describe the class TestSkip here.
    }

    TestSkip parameter {
        name 
        { test {} }
        { return {} }
    }

    TestSkip instproc passed { } {

        return 1
    }

    TestSkip instproc skipped { } {

        return 1
    }

    TestSkip instproc numberOfPasses { } {
        return 0
    }

    TestSkip instproc numberOfFailures { } {
        return 0
    }

    TestSkip instproc numberOfErrors { } {
        return 0
    }

    TestSkip instproc numberOfTests { } {
        return 0
    }
}


