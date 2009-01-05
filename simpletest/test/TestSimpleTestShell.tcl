# Created at Tue Feb 19 19:44:24 EST 2008 by bthomass

namespace eval ::simpletest::test {

    Class TestSimpleTestShell -superclass ::xounit::TestCase

    TestSimpleTestShell parameter {

    }

    TestSimpleTestShell instproc setUp { } {

        #add set up code here
    }

    TestSimpleTestShell instproc test { } {

        #implement test here
    }

    TestSimpleTestShell instproc tearDown { } {

        #add tear down code here
    }
}


