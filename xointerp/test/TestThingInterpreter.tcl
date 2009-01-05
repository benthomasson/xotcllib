# Created at Sat Jan 05 00:10:40 EST 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestThingInterpreter -superclass ::xounit::TestCase

    TestThingInterpreter parameter {

    }

    TestThingInterpreter instproc setUp { } {

        my instvar thing ti

        set thing [ ::xointerp::test::TestObject new ]
        set ti [ ::xointerp::ObjectInterpreter new -environment $thing -library $thing ]
        $thing set name thingy
    }

    TestThingInterpreter instproc test { } {

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

    TestThingInterpreter instproc test1 { } {

        my instvar thing ti

        $ti tclEval {
            <do>
        }

        my assertEquals [ $thing set a ] 5
    }

    TestThingInterpreter instproc test2 { } {

        my instvar thing ti

        $ti tclEval {
            if {1} {
                <do>
            }
        }

        my assertEquals [ $thing set a ] 5
    }

    TestThingInterpreter instproc test3 { } {

        my instvar thing ti

        $ti tclEval {
            if {0} {

            } else {
                <do>
            }
        }

        my assertEquals [ $thing set a ] 5
    }

    TestThingInterpreter instproc test4 { } {

        my instvar thing ti

        $ti tclEval {
            if {0} {

            } elseif {1} {
                <do>
            }
        }

        my assertEquals [ $thing set a ] 5
    }

    TestThingInterpreter instproc test5 { } {

        my instvar thing ti

        $ti tclEval {
            if {0} {

            } elseif {0} {
                <do>
            }
        }

        my assertFalse [ $thing exists a ]
    }

    TestThingInterpreter instproc test6 { } {

        my instvar thing ti

        $thing set a 0
        $thing set b 0

        $ti tclEval {
            if { [ <do> ] } {

                set b 6
            }
        }

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

    TestThingInterpreter instproc testWhile { } {

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

    TestThingInterpreter instproc testTclWhile { } {

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

    TestThingInterpreter instproc testFor { } {

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

    TestThingInterpreter instproc testForEach { } {

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

    TestThingInterpreter instproc testOProc { } {

        my instvar ti thing

        $ti tclEval {

            oproc newproc { a b c } {

                puts "$a + $b + $c"

                set return [ expr $a + $b + $c ]
            }
        }

        my assertEquals [ $thing info procs newproc ] "newproc"

        my assertEquals [ $thing newproc $ti 1 2 3 ] 6 1

        my assertEquals [ $thing set a ] 1
        my assertEquals [ $thing set b ] 2
        my assertEquals [ $thing set c ] 3

        my assertEquals [ $thing set return ] 6 2
    }

    TestThingInterpreter instproc testIProc { } {

        my instvar ti thing

        $ti tclEval {

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

        my assertEquals [ $thing newproc2 $ti 1 2 3 ] 6 1

        my assertFalse [ $thing exists a ] 
        my assertFalse [ $thing exists b ] 
        my assertFalse [ $thing exists c ] 
        my assertFalse [ $thing exists asdf ] 

        my assertEquals [ $thing set d ] 6
        my assertEquals [ $thing set e ] a
    }
}


