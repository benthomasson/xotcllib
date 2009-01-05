# Created at Mon Dec 15 12:52:08 EST 2008 by ben

namespace eval ::xodsl::test {

    Class TestNullEnvironment -superclass ::xounit::TestCase

    TestNullEnvironment parameter {

    }

    TestNullEnvironment instproc setUp { } {

        my instvar environment

        set environment [ ::xodsl::NullEnvironment new -scope #0 -namespace "" ]
        catch { unset ::a }
    }

    TestNullEnvironment instproc testSet { } {

        my instvar environment

        my assertFalse [ info exists ::a ] before

        $environment set a 5

        my assert [ info exists ::a ] after
    }

    TestNullEnvironment instproc testEval { } {

        my instvar environment

        my assertFalse [ info exists ::a ] before

        $environment eval {
            set a 5
        }

        my assert [ info exists ::a ] after
    }

    TestNullEnvironment instproc testForward { } {

        my instvar environment

        $environment forward hello [ self ] hello

        my assertEquals [ ::hello ] olleh
    }

    TestNullEnvironment instproc hello { } {

        return olleh
    }

    TestNullEnvironment instproc tearDown { } {

        #add tear down code here
    }
}


