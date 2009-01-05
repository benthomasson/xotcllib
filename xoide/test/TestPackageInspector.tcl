# Created at Fri Sep 26 00:56:33 EDT 2008 by bthomass

namespace eval ::xoide::test {

    Class TestPackageInspector -superclass ::xoide::TkTestCase

    TestPackageInspector parameter {

    }

    TestPackageInspector instproc test { } {

        my instvar root
        ::xoide::PackageInspector new -name $root -package ::xox -application [ ::xox::NullObject new ]
        my interact 3000
    }
}


