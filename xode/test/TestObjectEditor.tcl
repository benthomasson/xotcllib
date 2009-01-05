# Created at Tue Dec 23 14:08:03 EST 2008 by ben

namespace eval ::xode::test {

    Class TestObjectEditor -superclass ::xounit::TestCase

    TestObjectEditor parameter {

    }

    TestObjectEditor instproc setUp { } {

        #add set up code here
    }

    TestObjectEditor instproc test { } {

        set o [ Object new ]

        $o set a 5
        $o set b "\$a"
        $o set c "7 7 7 7"

        my assertSetEquals [ $o info vars ] {a b c}

        [ ::xode::ObjectEditor getInstance ] edit -noninteractive $o

        my assertSetEquals [ $o info vars ] {a b c}

        my assertEquals [ $o set a ] 5
        my assertEquals [ $o set b ] "\$a"
        my assertEquals [ $o set c ] "7 7 7 7"
    }

    TestObjectEditor instproc tearDown { } {

        #add tear down code here
    }
}


