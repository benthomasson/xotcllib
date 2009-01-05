# Created at Wed Oct 29 01:34:56 EDT 2008 by ben

namespace eval ::xodsl::test {

    Class TestMacro -superclass ::xounit::TestCase

    TestMacro parameter {

    }

    TestMacro instproc setUp { } {

        #add set up code here
    }

    TestMacro instproc test { } {

        #implement test here
    }

    TestMacro instproc tearDown { } {

        #add tear down code here
    }
}


