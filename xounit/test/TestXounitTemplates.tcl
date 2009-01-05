# Created at Fri Jun 01 08:18:21 EDT 2007 by bthomass


namespace eval ::xounit::test {

    namespace import -force ::xotcl::*

    Class TestXounitTemplates -superclass ::xounit::TestCase

    TestXounitTemplates parameter {

    }

    TestXounitTemplates instproc setUp { } {

        #add set up code here
    }

    TestXounitTemplates instproc test { } {

        #implement test here
    }

    TestXounitTemplates instproc tearDown { } {

        #add tear down code here
    }
}


