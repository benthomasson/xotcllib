# Created at Fri Jan 18 10:56:55 EST 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestInterpretedTestCaseEnvironment -superclass ::xounit::TestCase

    TestInterpretedTestCaseEnvironment parameter {

    }

    TestInterpretedTestCaseEnvironment instproc test { } {

        set environment [ ::xointerp::InterpretedTestCaseEnvironment new ]

        my assertEquals [ $environment info class ] ::xointerp::InterpretedTestCaseEnvironment 
        my assert [ $environment hasclass ::xounit::Assert ]
        my assert [ $environment hasclass ::xounit::TestCase ]

        my assertListEquals [ $environment  interpretableProcs ] {if while for foreach assertError assertInfoExists assertNoError assertFailure assertNoFailure}

        $environment assert 1
        $environment assertEquals 1 1
        $environment assertListEqualsTrim 1 1
        $environment assertFalse 0
    }
}


