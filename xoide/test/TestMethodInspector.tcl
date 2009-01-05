# Created at Fri Sep 26 00:57:36 EDT 2008 by bthomass

namespace eval ::xoide::test {

    Class TestMethodInspector -superclass ::xoide::TkTestCase

    TestMethodInspector parameter {

    }

    TestMethodInspector instproc test { } {

        my instvar root
        ::xoide::MethodInspector new -name $root -inspectClass ::xounit::Assert -method assertTrue -application [ ::xox::NullObject new ]

        my interact 3000
    }
}


