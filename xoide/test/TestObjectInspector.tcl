# Created at Fri Sep 26 00:56:39 EDT 2008 by bthomass

namespace eval ::xoide::test {

    Class TestObjectInspector -superclass ::xoide::TkTestCase

    TestObjectInspector parameter {

    }

    TestObjectInspector instproc test { } {

        my instvar root
        ::xoide::ObjectInspector new -name $root -object [ self ] -application [ ::xox::NullObject new ] 
        my interact 3000
    }
}


