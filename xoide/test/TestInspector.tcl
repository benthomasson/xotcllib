# Created at Thu Sep 25 23:47:42 EDT 2008 by bthomass

namespace eval ::xoide::test {

    Class TestInspector -superclass ::xoide::TkTestCase

    TestInspector parameter {

    }

    TestInspector instproc test { } {

        my instvar root

        ::xoide::Inspector new -name $root

        my interact 3000
    }
}


