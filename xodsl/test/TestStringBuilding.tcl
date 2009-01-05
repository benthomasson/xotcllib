# Created at Fri Oct 17 18:44:57 EDT 2008 by ben

namespace eval ::xodsl::test {

    Class TestStringBuilding -superclass ::xounit::TestCase

    TestStringBuilding parameter {

    }

    TestStringBuilding instproc setUp { } {

        #add set up code here
    }

    TestStringBuilding instproc testNoFilter { } {

        set collector [ Object new -set string "" ]
        set sb [ ::xodsl::StringBuilding new -collector $collector ]

        $sb set a 5

        my assertEquals [ $collector set string ] ""

        $sb set a 5

        my assertEquals [ $collector set string ] ""
    }

    TestStringBuilding instproc testFilter { } {

        set collector [ Object new -set string "" ]

        set sb [ ::xodsl::StringBuilding new -installFilter -collector $collector ]

        $sb set a 5

        my assertEquals [ $collector set string ] 5

        $sb set a 5

        my assertEquals [ $collector set string ] {55}
    }

    TestStringBuilding instproc testForwardingObject { } {

        set forwarder [ Object new ]
        set collector [ Object new -set string "" ]

        set sb [ ::xodsl::StringBuilding new -installFilter -collector $collector ]

        $forwarder forward set $sb set

        $forwarder set a 5

        my assertEquals [ $collector set string ] 5

        $forwarder set a 7

        my assertEquals [ $collector set string ] {57}
    }

    TestStringBuilding instproc testForwardingObjectEval { } {

        set forwarder [ Object new ]
        set collector [ Object new -set string "" ]

        set sb [ ::xodsl::StringBuilding new -installFilter -collector $collector ]

        $forwarder forward set $sb set

        $forwarder eval {
            set a 5
        }

        my assertEquals [ $collector set string ] 5

        $forwarder eval {
            set a 6
        }

        my assertEquals [ $collector set string ] {56}
    }

    TestStringBuilding instproc testForwardingObjectEvalMultipleCalls { } {

        set forwarder [ Object new ]
        set collector [ Object new -set string "" ]

        set sb [ ::xodsl::StringBuilding new -installFilter -collector $collector ]

        $forwarder forward set $sb set

        $forwarder eval {
            set a 5
        }

        my assertEquals [ $collector set string ] 5

        $forwarder eval {
            set a 6
            set a 7
            set a 8
        }

        my assertEquals [ $collector set string ] {5678}
    }

    TestStringBuilding instproc tearDown { } {

        #add tear down code here
    }
}


