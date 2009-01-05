# Created at Fri Jan 11 17:08:15 EST 2008 by bthomass

namespace eval ::xox::test {

    Class TestEventLoop -superclass ::xounit::TestCase

    TestEventLoop parameter {
        {a ""}
        {schedulerEvent}
    }

    TestEventLoop instproc setUp { } {

        my set a 5
        my unset a
    }

    TestEventLoop instproc tearDown { } {

        my instvar schedulerEvent

        if [ my exists schedulerEvent ] {

            after cancel $schedulerEvent
            my unset schedulerEvent
        }
    }

    TestEventLoop instproc testSetUp { } {

        my assertFalse [ my exists a ]
    }

    TestEventLoop instproc testUpdate { } {

        update
    }

    TestEventLoop instproc testUpdate { } {

        set id [ after 0 "[ self ] set a 5" ]

        my assertEquals [ after info $id ] [ list "[ self ] set a 5" timer ]
        my assertFalse [ my exists a ] 1

        update

        my assert [ my exists a ] 2
        my assertEquals [ my set a ] 5
    }

    TestEventLoop instproc testUpdate2 { } {

        set id [ after 0 "[ self ] set a 5" ]

        my assertEquals [ after info $id ] [ list "[ self ] set a 5" timer ]
        my assertFalse [ my exists a ] 1

        after cancel $id

        update

        my assertFalse [ my exists a ] 2
    }

    TestEventLoop instproc testUpdate3 { } {

        set id [ after idle "[ self ] set a 5" ]

        my assertEquals [ after info $id ] [ list "[ self ] set a 5" idle ]
        my assertFalse [ my exists a ] 1

        update

        my assert [ my exists a ] 2
        my assertEquals [ my set a ] 5
    }

    TestEventLoop instproc testUpdate4 { } {

        my instvar a

        set ::xox::test::aZZZ 0

        set id [ after idle "set ::xox::test::aZZZ 1" ]

        my assertEquals [ after info $id ] [ list "set ::xox::test::aZZZ 1" idle ]
        my assertEquals $::xox::test::aZZZ 0

        vwait ::xox::test::aZZZ

        my assert [ info exists ::xox::test::aZZZ ] 2
        my assertEquals $::xox::test::aZZZ 1
    }

    TestEventLoop instproc testInfiniteLoop { } {

        after idle "[ self ] infiniteLoop"
        update

        my assertEquals [ my set a ] 100
    }

    TestEventLoop instproc infiniteLoop { } {

        my set a 0

        for { set a 0 } { $a < 100 } { incr a } {

            my incr a
        }
    }

    TestEventLoop instproc schedulerLoop { } {

        my instvar schedulerEvent

        my incr a

        my schedulerEvent [ after 1 "[ self ] schedulerLoop" ]
    }

    TestEventLoop instproc testSchedulerLoop { } {

        my set a 0

        my schedulerLoop

        update
        after 10
        update
        after 10
        update

        my assertEquals [ my set a ] 3
    }
}


