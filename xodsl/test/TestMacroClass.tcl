# Created at Wed Oct 29 01:39:01 EDT 2008 by ben

namespace eval ::xodsl::test {

    Class TestMacroClass -superclass ::xounit::TestCase

    TestMacroClass parameter {

    }

    TestMacroClass instproc setUp { } {

        #add set up code here
    }

    TestMacroClass instproc test { } {

        #implement test here
    }

    TestMacroClass instproc tearDown { } {

        #add tear down code here
    }
}


