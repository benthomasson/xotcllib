# Created at Thu Nov 13 16:09:59 EST 2008 by ben

namespace eval ::xodsl::test {

    Class TestStringBuildingLanguage -superclass ::xounit::TestCase

    TestStringBuildingLanguage parameter {

    }

    TestStringBuildingLanguage instproc setUp { } {

        #add set up code here
    }

    TestStringBuildingLanguage instproc testEmpty { } {

        my assertEquals [ ::xodsl::buildString { } ] {}
    }

    TestStringBuildingLanguage instproc testQuote { } {

        my assertEquals [ ::xodsl::buildString { ' Hi there } ] {Hi there}
    }

    TestStringBuildingLanguage instproc testComma { } {

        my assertEquals [ ::xodsl::buildString { , expr 1 + 1 } ] 2
    }

    TestStringBuildingLanguage instproc testCommaQuote { } {

        my assertEquals [ ::xodsl::buildString { , ' Hi } ] {Hi}
    }

    TestStringBuildingLanguage instproc testCommaQuote { } {

        my assertEquals [ ::xodsl::buildString { , ' Hi } ] {Hi}
    }

    TestStringBuildingLanguage instproc testForeach { } {

        my assertEquals [ ::xodsl::buildString {
            foreach x { 1 2 3 4 5} {
                ' $x 
            }
        } ] {12345}
    }

    TestStringBuildingLanguage instproc testVariable { } {

        set list {1 2 3 4 5}

        my assertEquals [ ::xodsl::buildString {
            foreach x $list {
                ' $x 
            }
        } ] {12345}
    }

    TestStringBuildingLanguage instproc tearDown { } {

        #add tear down code here
    }
}


