# Created at Mon Jun 04 16:07:43 EDT 2007 by bthomass

namespace eval ::xounit::test {

    namespace import -force ::xotcl::*

    Class TestPrintResults -superclass ::xounit::TestCase

    TestPrintResults parameter {

    }

    TestPrintResults instproc setUp { } {

        #add set up code here
    }

    TestPrintResults instproc test { } {

        #implement test here
    }

    TestPrintResults instproc tearDown { } {

        #add tear down code here
    }
}


