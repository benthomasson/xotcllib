# Created at Mon Sep 29 14:30:37 EDT 2008 by ben

namespace eval ::xoide::test {

    Class TestTestRunner -superclass ::xoide::TkTestCase

    TestTestRunner parameter {

    }

    TestTestRunner instproc test { } {

        my instvar root

        set runner [ ::xoide::TestRunner new -name $root ]

        my interact 3000
    }
}


