
namespace eval ::xounit::test {

    namespace import -force ::xotcl::*

    Class TestTestCaseHierarchy -superclass ::xounit::TestCase

    TestTestCaseHierarchy instproc testSub { } {

        set case [ ::xounit::TestCase new ]
        set case2 [ ::xounit::TestCase new ]

        set formatter [ ::xounit::TestResultsTextFormatter new ]

        $case2 proc test { } {

            return sub
        }

        $case proc test { } "

            my runDependentTest $case2 test
            return main
        "

        $formatter printResults [ $case runAlone ]
        
        return
    }

    TestTestCaseHierarchy instproc testSubFail { } {

        set case [ ::xounit::TestCase new ]
        set case2 [ ::xounit::TestCase new ]

        set formatter [ ::xounit::TestResultsTextFormatter new ]

        $case2 proc test { } {

            my fail "ack"
        }

        $case proc test { } "

            my runDependentTest $case2 test
            return main
        "

        $formatter printResults [ $case runAlone ]
        
        return
    }

    TestTestCaseHierarchy instproc testFail { } {

        set case [ ::xounit::TestCase new ]
        set case2 [ ::xounit::TestCase new ]

        set formatter [ ::xounit::TestResultsTextFormatter new ]

        $case2 proc test { } {

            my fail fail
        }

        $case proc test { } "

            my runDependentTest $case2 test
            return main
        "

        $formatter printResults [ $case runAlone ]

        return
    }

    TestTestCaseHierarchy instproc testError { } {

        set case [ ::xounit::TestCase new ]
        set case2 [ ::xounit::TestCase new ]

        set formatter [ ::xounit::TestResultsTextFormatter new ]

        $case2 proc test { } {

            error error
        }

        $case proc test { } "

            my runIndependentTest $case2 test
            return main
        "

        $formatter printResults [ $case runAlone ]

        return
    }

    TestTestCaseHierarchy instproc testSubSub { } {

        set case [ ::xounit::TestCase new ]
        set case2 [ ::xounit::TestCase new ]
        set case3 [ ::xounit::TestCase new ]

        set formatter [ ::xounit::TestResultsTextFormatter new ]

        $case3 proc test { } {

            return subsub
        }

        $case2 proc test { } "

            my runIndependentTest $case3 test
            return main
        "

        $case proc test { } "

            my runIndependentTest $case2 test
            return main
        "

        $formatter printResults [ $case runAlone ]
        
        return
    }

    TestTestCaseHierarchy instproc testSubSelf { } {

        set case [ ::xounit::TestCase new ]
        set case2 [ ::xounit::TestCase new ]

        set formatter [ ::xounit::TestResultsTextFormatter new ]

        $case2 proc test2 { } {

            return subself
        }

        $case2 proc test { } "

            my runIndependentTest $case2 test2
            return main
        "

        $case proc test { } "

            my runIndependentTest $case2 test
            return main
        "

        $formatter printResults [ $case runAlone ]
        
        return
    }

    TestTestCaseHierarchy instproc testRunExternalTest { } {

        set case [ ::xounit::TestCase new ]
        set case2 [ ::xounit::TestCase new ]

        set formatter [ ::xounit::TestResultsTextFormatter new ]

        $case2 proc test { } {

            return 1
        }

        $case proc test { } "

            my runExternalTest $case2 test
            return main
        "

        $formatter printResults [ $case runAlone ]
        
        return
    }

    TestTestCaseHierarchy instproc testIndependentTest { } {

        set case [ ::xounit::TestCase new ]
        set case2 [ ::xounit::TestCase new ]

        $case2 proc setUp { } {

            my set b 5
        }

        $case2 proc test { } {

            my set a 5
        }

        $case2 proc tearDown { } {

            my set c 5
        }

        $case result [ $case newResult ]

        my debug "$case is a [ $case info class ]"

        my debug "[ $case result ] is a [ [ $case result ] info class ]"

        my assertFalse [ $case2 exists a ]
        my assertFalse [ $case2 exists b ]
        my assertFalse [ $case2 exists c ]

        $case runIndependentTest $case2 test

        my assertEquals [ $case2 set a ] 5
        my assertEquals [ $case2 set b ] 5
        my assertEquals [ $case2 set c ] 5
    }
}
