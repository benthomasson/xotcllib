# Created at Thu Sep 25 20:17:22 EDT 2008 by bthomass

namespace eval ::xoide::test {

    Class TestScrolledText -superclass ::xoide::TkTestCase

    TestScrolledText parameter {

    }

    TestScrolledText instproc test { } {

        my instvar root

        toplevel $root

        ::xoide::ScrolledText new $root.text -width 10 -height -10
    }

    TestScrolledText instproc testNamed { } {

        my instvar root

        toplevel $root

        ::xoide::ScrolledText new $root.text -width 10 -height -10 -name ScrolledText
        my interact 3000
    }
}


