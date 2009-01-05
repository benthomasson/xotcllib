# Created at Fri Sep 26 00:56:51 EDT 2008 by bthomass

namespace eval ::xoide::test {

    Class TestErrorInspector -superclass ::xoide::TkTestCase

    TestErrorInspector parameter {

    }

    TestErrorInspector instproc test { } {

        my instvar root
        ::xoide::ErrorInspector new -name $root -result [ ::xoexception::Exception new ack ] -index 0

        my interact 3000
    }
}


