# Created at Thu Oct 23 12:01:20 EDT 2008 by ben

namespace eval ::xohtml::test {

    Class TestApplicationClass -superclass ::xounit::TestCase

    TestApplicationClass parameter {

    }

    TestApplicationClass instproc setUp { } {

        #add set up code here
    }

    TestApplicationClass instproc test { } {

        #implement test here
    }

    TestApplicationClass instproc tearDown { } {

        #add tear down code here
    }
}


