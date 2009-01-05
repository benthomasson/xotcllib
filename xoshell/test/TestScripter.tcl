# Created at Tue Apr 08 22:56:39 EDT 2008 by bthomass

namespace eval ::xoshell::test {

    Class TestScripter -superclass ::xounit::TestCase

    TestScripter parameter {

    }

    TestScripter instproc setUp { } {

        #add set up code here
    }

    TestScripter instproc test { } {

        #implement test here
    }

    TestScripter instproc tearDown { } {

        #add tear down code here
    }
}


