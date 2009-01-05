# Created at Sun Oct 26 15:43:13 EDT 2008 by ben

namespace eval ::xoweb::test {

    Class TestProcedureInspector -superclass ::xounit::TestCase

    TestProcedureInspector parameter {

    }

    TestProcedureInspector instproc setUp { } {

        #add set up code here
    }

    TestProcedureInspector instproc test { } {

        #implement test here
    }

    TestProcedureInspector instproc tearDown { } {

        #add tear down code here
    }
}


