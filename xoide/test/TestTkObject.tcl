# Created at Thu Sep 25 23:13:44 EDT 2008 by bthomass

namespace eval ::xoide::test {

    Class TestTkObject -superclass ::xounit::TestCase

    TestTkObject parameter {

    }

    TestTkObject instproc setUp { } {

        #add set up code here
    }

    TestTkObject instproc test { } {

        #implement test here
    }

    TestTkObject instproc tearDown { } {

        #add tear down code here
    }
}


