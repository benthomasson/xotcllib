# Created at Mon Sep 29 14:21:39 EDT 2008 by ben

namespace eval ::xoide::test {

    Class TestTkTestCase -superclass ::xoide::TkTestCase

    TestTkTestCase parameter {

    }

    TestTkTestCase instproc testInteractButton { } {
        my interact
    }

    TestTkTestCase instproc testInteractTime { } {
        my interact 3000
    }
}


