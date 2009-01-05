# Created at Sun Jan 06 16:24:11 EST 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestSchedulableInterpreter -superclass ::xounit::TestCase

    TestSchedulableInterpreter parameter {

    }

    TestSchedulableInterpreter instproc setUp { } {

        my instvar thing si ti

        set thing [ ::xointerp::test::TestObject new ]
        set si [ ::xointerp::SchedulableInterpreter new -environment $thing -library $thing ]
        set ti $si
        $thing set name thingy
    }
    

    TestSchedulableInterpreter instproc test { } {

        my instvar thing si 

        $si tclEval {

            <do>
            <do2>
        }

        my assertEquals [ $thing set a ] 2

    }

    TestSchedulableInterpreter instproc testSchedule { } {

        my instvar thing si 

        $si schedule {

            <do>
            <do2>
        }

        my assert [ $si hasNextCommand ] 1
        my assertEquals [ $si nextCommand ] <do> 2
        my assertEquals [ $si nextCommand ] <do> 2.5

        my assertListEqualsTrim [ $si commands ] { {} {} {<do>} {<do2>}} 3

        $si evalOneCommand

        my assert [ $si hasNextCommand ] 4
        my assertEquals [ $si nextCommand ] <do2> 5

        my assertListEqualsTrim [ $si commands ] { {<do2>}}
        my assertEquals [ $thing set a ] 5

        $si evalOneCommand

        my assertFalse [ $si hasNextCommand ]
        my assertEquals [ $si nextCommand ] ""

        my assertListEqualsTrim [ $si commands ] { }
        my assertEquals [ $thing set a ] 2
        
        $si evalOneCommand

        my assertFalse [ $si hasNextCommand ]
        my assertEquals [ $si nextCommand ] ""

        my assertListEqualsTrim [ $si commands ] { }
    }

    TestSchedulableInterpreter instproc testSchedule2 { } {

        my instvar thing si 

        $si schedule {

            <do>
            <do2>
            <do3> 5555
        }

        my assert [ $si hasNextCommand ] 1

        $si evalOneCommand

        my assertEquals [ $si return ] 5
        my assert [ $si hasNextCommand ] 2

        $si evalOneCommand
        my assertEquals [ $si return ] 2

        my assert [ $si hasNextCommand ] 3
        $si evalOneCommand

        my assertEquals [ $si return ] 5556
    }

    TestSchedulableInterpreter instproc testSchedule3 { } {

        my instvar thing si 

        $si schedule {

            <do3> [ <do> ]
            <do>
        }

        $si evalOneCommand

        my assertEquals [ $si return ] 6
    }

    TestSchedulableInterpreter instproc testIf { } {

        my instvar thing ti

        $ti tclEval {

            set a 5
            puts $name

            if { 1 } {

                set b 6
            }
        }

        my assertEquals [ $thing set a ] 5
        my assertEquals [ $thing set b ] 6
    }

    TestSchedulableInterpreter instproc test1 { } {

        my instvar thing ti

        $ti tclEval {
            <do>
        }

        my assertEquals [ $thing set a ] 5
    }

    TestSchedulableInterpreter instproc test2 { } {

        my instvar thing ti

        $ti tclEval {
            if {1} {
                <do>
            }
        }

        my assertEquals [ $thing set a ] 5
    }

    TestSchedulableInterpreter instproc test3 { } {

        my instvar thing ti

        $ti tclEval {
            if {0} {

            } else {
                <do>
            }
        }

        my assertEquals [ $thing set a ] 5
    }

    TestSchedulableInterpreter instproc test4 { } {

        my instvar thing ti

        $ti tclEval {
            if {0} {

            } elseif {1} {
                <do>
            }
        }

        my assertEquals [ $thing set a ] 5
    }

    TestSchedulableInterpreter instproc test5 { } {

        my instvar thing ti

        $ti tclEval {
            if {0} {

            } elseif {0} {
                <do>
            }
        }

        my assertFalse [ $thing exists a ]
    }

    TestSchedulableInterpreter instproc test6 { } {

        my instvar thing ti

        $thing set a 0
        $thing set b 0

        $ti tclEval {
            if { [ <do> ] } {

                set b 6
            }
        }

        my assertEquals [ $thing set a ] 5
        my assertEquals [ $thing set b ] 6

        $thing set a 0
        $thing set b 0

        $ti tclEval {

            set c 1

            if { $c } {

                <do>
            }
        }

        my assertEquals [ $thing set c ] 1
        my assertEquals [ $thing set a ] 5
    }

    TestSchedulableInterpreter instproc testWhile { } {

        my instvar thing ti

        $thing set a 0
        $thing set b 0

        $ti tclEval {
            while { $a < 10 } {
                incr a
            }
        }

        my assertEquals [ $thing set a ] 10

        $ti tclEval {
            while { 0 } {
                set a 5
            }
        }

        my assertEquals [ $thing set a ] 10

        return

        $ti tclEval {
            while { 1 } {
                set a 5
                break
            }
        }

        my assertEquals [ $thing set a ] 10
    }

    TestSchedulableInterpreter instproc testTclWhile { } {

        set a 0

        while { $a < 10 } {

            incr a
        }

        my assertEquals $a 10

        while { 0 } {

            set a 5
        }

        my assertEquals $a 10

        while { 1 } {

            set a 5
            break
        }

        my assertEquals $a 5
    }

    TestSchedulableInterpreter instproc testFor { } {

        my instvar thing ti

        $thing set b 0

        $ti tclEval {
            for { set a 0 } { $a < 10 } { incr a } {
                incr b 
            }
        }

        my assertEquals [ $thing set a ] 10
        my assertEquals [ $thing set b ] 10

        $thing set b 0

        $ti tclEval {
            for { set a 10 } { $a < 10 } { incr a } {
                incr b
            }
        }

        my assertEquals [ $thing set a ] 10
        my assertEquals [ $thing set b ] 0
    }

    TestSchedulableInterpreter instproc testForEach { } {

        my instvar thing ti

        $thing set b 0

        $ti tclEval {
            foreach a { 1 2 3 4 5 6 7 9 10 } {
                set b $a
            }
        }

        my assertEquals [ $thing set a ] 10
        my assertEquals [ $thing set b ] 10

        $ti tclEval {
            foreach { a c } { 1 2 3 4 5 6 7 9 10 } {
                set b $a
            }
        }

        my assertEquals [ $thing set a ] 10 1
        my assertEquals [ $thing set b ] 10 2 
        my assertEquals [ $thing set c ] 9 3
    }

    TestSchedulableInterpreter instproc testChildSchedule { } {

        my instvar thing si 

        $si schedule {

            if { [ <do> ] == 5 } {
                <do2>
            }
        }

        my assert [ $si hasNextCommand ] 1
        my assertEqualsByLine [ $si nextCommand ] \
"if { \[ <do> \] == 5 } {
<do2>
}"
        $si evalOneCommand

        my assertFalse [ $si hasNextCommand ] 4
        my assertEquals [ $thing set a ] 2
    }

    TestSchedulableInterpreter instproc testScheduleEvalOneCommand { } {

        my instvar thing si 

        $si schedule {

            <do>
            <do2>
        }

        $si evalOneCommand

        my assertEquals [ $si return ] 5

        $si evalOneCommand
        my assertEquals [ $si return ] 2

        $si evalOneCommand
        my assertEquals [ $si return ] 2

        $si evalOneCommand
        my assertEquals [ $si return ] 2

        $si evalOneCommand
        my assertEquals [ $si return ] 2
    }

    TestSchedulableInterpreter instproc testOProc { } {

        my instvar si thing

        $si tclEval {

            oproc newproc { a b c } {

                puts "$a + $b + $c"

                set return [ expr $a + $b + $c ]
            }
        }

        my assertEquals [ $thing info procs newproc ] "newproc"

        my assertEquals [ $thing newproc $si 1 2 3 ] 6 1

        my assertEquals [ $thing set a ] 1
        my assertEquals [ $thing set b ] 2
        my assertEquals [ $thing set c ] 3

        my assertEquals [ $thing set return ] 6 2
    }

    TestSchedulableInterpreter instproc testIProc { } {

        my instvar si thing

        $si tclEval {

            set d 6
            set e a

            iproc newproc2 { a b c } {

                puts "$a + $b + $c"

                set asdf [ expr $a + $b + $c ]

                set d 7

                lappend e 1

                return $asdf
            }
        }

        my assertEquals [ $thing info procs newproc2 ] "newproc2"

        my assertEquals [ $thing newproc2 $si 1 2 3 ] 6 1

        my assertFalse [ $thing exists a ] 
        my assertFalse [ $thing exists b ] 
        my assertFalse [ $thing exists c ] 
        my assertFalse [ $thing exists asdf ] 

        my assertEquals [ $thing set d ] 6
        my assertEquals [ $thing set e ] a
    }
}


