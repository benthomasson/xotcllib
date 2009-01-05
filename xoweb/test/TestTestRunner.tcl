# Created at Fri Nov 14 22:58:48 EST 2008 by ben

namespace eval ::xoweb::test {

    Class TestTestRunner -superclass ::xounit::TestCase

    TestTestRunner parameter {

    }

    TestTestRunner instproc setUp { } {

        #add set up code here
    }

    TestTestRunner instproc test { } {

        #implement test here
    }

    TestTestRunner instproc tearDown { } {

        #add tear down code here
    }
}


