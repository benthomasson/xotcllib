# Created at Tue Feb 17 03:53:05 PM EST 2009 by dsivasub

namespace eval ::xounit::test {

    Class TestTestSkip -superclass ::xounit::TestCase

    TestTestSkip parameter {

    }

    TestTestSkip instproc setUp { } {

        #add set up code here
    }

    TestTestSkip instproc test { } {

        #implement test here
    }

    TestTestSkip instproc tearDown { } {

        #add tear down code here
    }
}


