# Created at Thu Oct 23 20:52:27 EDT 2008 by ben

namespace eval ::xoweb::test {

    Class TestClassDoc -superclass ::xounit::TestCase

    TestClassDoc parameter {

    }

    TestClassDoc instproc setUp { } {

        #add set up code here
    }

    TestClassDoc instproc test { } {

        #implement test here
    }

    TestClassDoc instproc tearDown { } {

        #add tear down code here
    }
}


