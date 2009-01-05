# Created at Fri Sep 26 00:56:43 EDT 2008 by bthomass

namespace eval ::xoide::test {

    Class TestClassInspector -superclass ::xoide::TkTestCase

    TestClassInspector parameter {

    }

    TestClassInspector instproc test { } {

        my instvar root
        ::xoide::ClassInspector new -name $root -inspectClass ::xotcl::Object -application [ ::xox::NullObject new ]

        my interact 3000
    }
}


