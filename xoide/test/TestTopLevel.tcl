# Created at Thu Sep 25 23:09:32 EDT 2008 by bthomass

namespace eval ::xoide::test {

    Class TestTopLevel -superclass ::xoide::TkTestCase

    TestTopLevel parameter {

    }

    TestTopLevel instproc test { } {

        my instvar root

        ::xoide::TopLevel new -name $root
        label "${root}.lname" -text "hello there"
        pack $root.lname
        raise $root
        my interact 3000
    }
}


