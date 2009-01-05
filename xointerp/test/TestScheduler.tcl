# Created at Sun Jan 06 22:10:21 EST 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestScheduler -superclass ::xounit::TestCase

    TestScheduler parameter {

    }

    TestScheduler instproc setUp { } {

        my instvar scheduler interpreter thing

        set thing [ ::xointerp::test::TestObject new ]
        set scheduler [ ::xointerp::TestableScheduler new ]
        set interpreter [ ::xointerp::SchedulableInterpreter new -environment $thing -library $thing -scheduler $scheduler ]
        $scheduler interpreters $interpreter
    }

    TestScheduler instproc testSchedule { } {

        my instvar scheduler interpreter thing

        $interpreter schedule {

            <do>
            <do2>
            <do3> [ <do> ]

            puts ho

            if { 1 } {
                puts hi
                set c 99
            }
        }

        my assertEquals [ $interpreter return ] ""

        $scheduler schedule
        my assertEquals [ $interpreter return ] 5

        $scheduler schedule
        my assertEquals [ $interpreter return ] 2

        $scheduler schedule
        my assertEquals [ $interpreter return ] 6

        $scheduler schedule
        my assertEquals [ $interpreter return ] ""

        my assertFalse [ $thing exists c ] 

        $scheduler schedule
        my assertEquals [ $interpreter return ] ""

        my assertEquals [ $thing set c ] 99
    }

    TestScheduler instproc testSchedule2 { } {

        my instvar scheduler interpreter thing

        $interpreter schedule {

            <do>
            <do2>
            <do3> [ <do> ]

            if { 1 } {
                puts hi
                set c 99
            }
        }

        my assertEquals [ $interpreter return ] ""

        $scheduler schedule
        my assertEquals [ $interpreter return ] 5

        $scheduler schedule
        my assertEquals [ $interpreter return ] 2

        $scheduler schedule
        my assertEquals [ $interpreter return ] 6

        my assertFalse [ $thing exists c ] C1

        $scheduler schedule
        my assertEquals [ $interpreter return ] ""

        my assertEquals [ $thing set c ] 99
    }

    TestScheduler instproc testChildren { } {

        my instvar scheduler interpreter thing

        $interpreter schedule {

            if { 1 } {
                puts hi
                set c 99
            }

            set d 5
        }

        my assertFalse [ $thing exists c ] C1
        my assertFalse [ $thing exists d ] D1

        $scheduler schedule
        my assertEquals [ $interpreter return ] ""

        my assert [ $thing exists c ] C2
        my assertFalse [ $thing exists d ] D2

        my assertEquals [ $thing set c ] 99

        $scheduler schedule
        my assertEquals [ $interpreter return ] 5

        my assert [ $thing exists c ] C3
        my assert [ $thing exists d ] D3

        my assertEquals [ $thing set c ] 99
        my assertEquals [ $thing set d ] 5
    }

    TestScheduler instproc testChildrenOnly { } {

        my instvar scheduler interpreter thing

        $interpreter schedule {

            if { 1 } {
                puts hi
                set c 99
            }
        }

        my assertFalse [ $thing exists c ] C1

        $scheduler schedule
        my assertEquals [ $interpreter return ] ""

        my assert [ $thing exists c ] C2

        my assertEquals [ $thing set c ] 99
    }

    TestScheduler instproc testMultipleInterpreters { } {

        my instvar scheduler interpreter thing

        set interpreter2 [ ::xointerp::SchedulableInterpreter new -environment $thing -library $thing -scheduler $scheduler ]

        $scheduler interpreters [ list $interpreter $interpreter2 ]

        $interpreter schedule {
            set a 5
        }

        $interpreter2 schedule {
            set b 6
        }

        $scheduler schedule

        my assertEquals [ $thing set a ] 5
        my assertEquals [ $thing set b ] 6
    }

    TestScheduler instproc testMultipleInterpreters2 { } {

        my instvar scheduler interpreter thing

        set interpreter2 [ ::xointerp::SchedulableInterpreter new -environment $thing -library $thing -scheduler $scheduler ]

        $scheduler interpreters [ list $interpreter $interpreter2 ]

        $interpreter schedule {
            set a 5
        }

        $interpreter2 tclEval {
            set b 6
        }

        my assertEquals [ $thing set a ] 5
        my assertEquals [ $thing set b ] 6
    }

    TestScheduler instproc testLoop { } {

        my instvar scheduler interpreter thing

        $scheduler maxSteps 20

        $interpreter schedule {

            set a 5

            while { 1 } {

                incr a
            }
        }

        $scheduler schedule
        my assertEquals [ $thing set a ] 5 1

        my assertError {
            $scheduler schedule
        }
        my assertEquals [ $thing set a ] 10 2
    }

    TestScheduler instproc notestManyInterpreters { } {

        my instvar scheduler interpreter thing

        interp recursionlimit {} 100000000

        $thing set a 5

        $scheduler maxSteps 1000

        for { set i 0 } { $i < 90 } { incr i } {

            set int [ ::xointerp::SchedulableInterpreter new -environment $thing -library $thing -scheduler $scheduler ]

            $scheduler lappend interpreters $int

            $int schedule { 

                while { 1 } {

                    incr a
                }
            }
        }

        my assertError {

        $scheduler schedule 

        }

        my assertEquals [ $thing set a ] 210
    }

}


