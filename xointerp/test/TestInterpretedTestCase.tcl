# Created at Fri Jan 18 10:56:24 EST 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestInterpretedTestCase -superclass ::xounit::TestCase

    TestInterpretedTestCase parameter {

    }

    TestInterpretedTestCase instproc test { } {

        set test [ ::xointerp::InterpretedTestCase new -script {

        } ]

        $test test
    }

    TestInterpretedTestCase instproc testInfoClass { } {

        set test [ ::xointerp::InterpretedTestCase new -script {

            my info class
        } ]

        $test test
    }

    TestInterpretedTestCase instproc testAssert { } {

        set test [ ::xointerp::InterpretedTestCase new -script {

            assert 1
        } ]

        $test test
    }

    TestInterpretedTestCase instproc testAssertEquals { } {

        set test [ ::xointerp::InterpretedTestCase new -script {

            assertEquals 1 1
        } ]

        $test test
    }

    TestInterpretedTestCase instproc testAssertFalse { } {

        set test [ ::xointerp::InterpretedTestCase new -script {

            assertFalse 0
        } ]

        $test test
    }

    TestInterpretedTestCase instproc testAssertTrue { } {

        set test [ ::xointerp::InterpretedTestCase new -script {

            assertTrue 1
        } ]

        $test test
    }

    TestInterpretedTestCase instproc testAssertError { } {

        set test [ ::xointerp::InterpretedTestCase new -script {

            assertError {

                error ack
            }
        } ]

        $test test
    }

    TestInterpretedTestCase instproc testAssertNoError { } {

        set test [ ::xointerp::InterpretedTestCase new -script {

            assertError {

            }
        } ]

        my assertFailure { 

            $test test 
        } 
    }

    TestInterpretedTestCase instproc testAssertInfoExists { } {

        set test [ ::xointerp::InterpretedTestCase new -script {

            set a 5
            assertInfoExists a
        } ]

        $test test 
    }

    TestInterpretedTestCase instproc testAssertNoError2 { } {

        set test [ ::xointerp::InterpretedTestCase new -script {

            assertNoError {

                set a 5
                assertInfoExists a
            }

        } ]

        $test test 
    }

    TestInterpretedTestCase instproc testAssertFailure { } {

        set test [ ::xointerp::InterpretedTestCase new -script {

            assertFailure {

                fail ack
            }

        } ]

        $test test 
    }

    TestInterpretedTestCase instproc testAssertNoFailure { } {

        set test [ ::xointerp::InterpretedTestCase new -script {

            assertNoFailure {

                set a 5
                assertInfoExists a
                assertEquals $a 5

            }

        } ]

        $test test 
    }
}


