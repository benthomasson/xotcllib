# Created at Fri Oct 17 03:28:37 PM EDT 2008 by bthomass

namespace eval ::xodsl::test {

    Class TestLanguage -superclass ::xounit::TestCase

    TestLanguage parameter {

    }

    TestLanguage instproc setUp { } {

        #add set up code here
    }

    TestLanguage instproc test { } {

        ::xodsl::Language new 
    }

    TestLanguage instproc tearDown { } {

        #add tear down code here
    }
}


