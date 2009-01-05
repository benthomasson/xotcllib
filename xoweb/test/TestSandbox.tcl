# Created at Mon Oct 27 17:58:12 EDT 2008 by ben

namespace eval ::xoweb::test {

    Class TestSandbox -superclass ::xounit::TestCase

    TestSandbox parameter {

    }

    TestSandbox instproc setUp { } {

        #add set up code here
    }

    TestSandbox instproc test { } {

        #implement test here
    }

    TestSandbox instproc tearDown { } {

        #add tear down code here
    }
}


