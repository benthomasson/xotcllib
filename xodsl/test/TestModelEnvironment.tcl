# Created at Mon Oct 20 11:27:01 EDT 2008 by ben

namespace eval ::xodsl::test {

    Class TestModelEnvironment -superclass ::xounit::TestCase

    TestModelEnvironment parameter {

    }

    TestModelEnvironment instproc setUp { } {

        #add set up code here
    }

    TestModelEnvironment instproc test { } {

        #implement test here
    }

    TestModelEnvironment instproc tearDown { } {

        #add tear down code here
    }
}


