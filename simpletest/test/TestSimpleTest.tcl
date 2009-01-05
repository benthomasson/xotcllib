# Created at Mon Feb 04 10:04:54 AM EST 2008 by bthomass

namespace eval ::simpletest::test {

    Class TestSimpleTest -superclass ::xounit::TestCase

    TestSimpleTest parameter {

    }

    TestSimpleTest instproc setUp { } {

        foreach instance [ ::simpletest::SimpleTestCaseClass info instances ] {

            $instance destroy
        }
    }

    TestSimpleTest instproc testCreate { } {

        set tc [ ::simpletest::test TestXYZ {

        } ]

        my assert [ string match "::simpletest::test::TestXYZ*" $tc ]

        #my assertEquals $tc ::simpletest::test::TestXYZ3
        my assertEquals [ $tc set name ] TestXYZ 1
        my assertEquals [ $tc name ] TestXYZ 2
    }

    TestSimpleTest instproc testResults { } {

        set tc [ ::simpletest::test TestXYZ {

        } ]

        my assertEquals [ ::simpletest::SimpleTestCaseClass info instances ] $tc
        my assertEquals [ ::simpletest::SimpleTestCaseClass info instances "::*" ] $tc

        set results [ ::simpletest::runTests ]

        my assert [ $results passed ]
    }

    TestSimpleTest instproc testAssert { } {

        ::simpletest::test TestXYZ {

            assert 1 "True"
        } 

        set results [ ::simpletest::runTests ]

        my assert [ $results passed ]
    }

    TestSimpleTest instproc testAssertFail { } {

        ::simpletest::test TestXYZ {

            assert 0 "False"
        } 

        set results [ ::simpletest::runTests ]

        my assertFalse [ $results passed ]
    }

    TestSimpleTest instproc testAssertEquals { } {

        ::simpletest::test TestXYZ {

            set a 5
            assertEquals $a 5
        } 

        set results [ ::simpletest::runTests ]

        my assert [ $results passed ]
    }
}


