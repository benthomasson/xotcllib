# Created at Mon Aug 04 09:52:40 AM EDT 2008 by bthomass

namespace eval ::xounit::test {

    Class TestTestFinished -superclass ::xounit::TestCase

    TestTestFinished parameter {

    }

    TestTestFinished instproc setUp { } {

        #add set up code here
    }

    TestTestFinished instproc test { } {

        #implement test here
    }

    TestTestFinished instproc tearDown { } {

        #add tear down code here
    }
}


