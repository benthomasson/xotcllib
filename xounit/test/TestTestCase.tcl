
namespace eval ::xounit::test {

    namespace import -force ::xotcl::*

    Class TestTestCase -superclass ::xounit::TestCase

    TestTestCase parameter aTestVariable

    TestTestCase instproc setUp {} {

        my aTestVariable 5
    }

    TestTestCase instproc test {} {

        set test [ ::xounit::TestCase new ]

        my assertEquals [ $test name ] ::xounit::TestCase

        #my assertEquals [ $test toString ] ""
    }

    TestTestCase instproc testTestCase {} {

        my assert [ expr [ my aTestVariable ] == 5 ] { Should be 5 }
    }

    TestTestCase instproc tearDown {} {

        my unset aTestVariable 

        my assertFalse [ my exists aTestVariable ] { Should have unset aTestVariable }
    }

    TestTestCase instproc testReturnValue {} {

        return 5
    }

    TestTestCase instproc testtestReturnValue {} {

        my assertEquals 5 [ my testReturnValue ]
    }

    TestTestCase instproc testPass {} {

        set testCase [ ::xounit::TestCase new A ]

        $testCase proc testPass { } {

            return 1
        }

        set result [ $testCase runAlone ]

        my assert [ $result passed ]
        set sub [ $result results ]

        my assertEquals [ $result name ] ::xounit::TestCase
        my assertEquals [ $sub name ] ::xounit::TestCase
        my assertEquals [ $sub test ] testPass
        my assertEquals [ $sub return ] 1
        my assertEquals [ $sub message ] 1
    }

    TestTestCase instproc testFailure {} {

        set testCase [ ::xounit::TestCase new A ]

        $testCase proc testFailure { } {

            my fail 2
        }

        set result [ $testCase runAlone ]

        my assertFalse [ $result passed ]
        set sub [ $result results ]

        my assertEquals [ $result name ] ::xounit::TestCase
        my assertEquals [ $sub name ] ::xounit::TestCase
        my assertEquals [ $sub test ] testFailure
        my assertEquals [ $sub error ] 2
        my assertEquals [ $sub message ] 2
    }

    TestTestCase instproc testError {} {

        set testCase [ ::xounit::TestCase new A ]

        $testCase proc testError { } {

            error 3
        }

        set result [ $testCase runAlone ]

        my assertFalse [ $result passed ]
        set sub [ $result results ]

        my assertEquals [ $result name ] ::xounit::TestCase
        my assertEquals [ $sub name ] ::xounit::TestCase
        my assertEquals [ $sub test ] testError
        my assertEquals [ lindex [ split [ $sub error ] "\n" ] 0 ] 3
        my assertEquals [ lindex [ split [ $sub message ] "\n" ] 0 ] 3
        my debug [ $sub error ] 
    }

    TestTestCase instproc testAssertTestRun { } {

        set tc [ ::xounit::TestCase new -name A1A ]

        $tc proc test { } {

        }

        $tc proc test2 { } {

        }

        set result [ $tc runAlone ]
        my assertEquals [ $result name ] A1A
        set sub [ $result TestFinished ]

        my assertEquals [ $sub name ] A1A 
        my assertEquals [ $sub test ] test

        my assert [ $sub passed ]

        set sub1 [ $result TestFinished1 ]

        my assertEquals [ $sub1 name ] A1A 
        my assertEquals [ $sub1 test ] test2

        my assert [ $sub1 passed ]

        my debug [ $result dumpTreeData ]

        my assertEquals [ $result name ] A1A
        my assertEquals [ $result TestFinished name ] A1A
        my assertEquals [ $result TestFinished1 name ] A1A

        set ::xounit::currentResult $result

        $tc assertTestRan A1A
        $tc assertTestRan A1A test
        $tc assertTestRan A1A test2

        $tc assertTestPassed A1A
        $tc assertTestPassed A1A test
        $tc assertTestPassed A1A test2

        my assertFailure { $tc assertTestFailed A1A }

        my assertSetEquals [ $result allResults ] [ list $result $sub $sub1 ]
    }

    TestTestCase instproc testGlobalVars { } {

        my assertEquals [ my result ] $::xounit::currentResult
        my assertEquals [ my currentTestMethod ] $::xounit::currentTestMethod
    }
}
