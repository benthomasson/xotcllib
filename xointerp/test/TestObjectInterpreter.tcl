# Created at Fri Jan 04 12:21:13 EST 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestObjectInterpreter -superclass ::xounit::TestCase

    TestObjectInterpreter parameter {

    }

    TestObjectInterpreter instproc setUp { } {

        my instvar env oi

        set env [ ::xointerp::test::TestObject new ]
        set oi [ ::xointerp::ObjectInterpreter new -environment $env ]
    }

    TestObjectInterpreter instproc testBasic { } {

        my instvar env oi

        $oi tclEval {

            set a 5
            puts $a
            set b [ my info class ]
            set ae [ exists a ]
            set ae2 [ ::info exists a ]
        }

        my assertEquals [ $env set a ] 5
        my assertEquals [ $env set b ] ::xointerp::test::TestObject
        my assertTrue [ $env set ae ] 
        my assertTrue [ $env set ae2 ] 
    }

    TestObjectInterpreter instproc testVariables { } {

        my instvar env oi

        $env set a 5

        $oi tclEval {

            puts $a
            set b $a
        }

        my assertEquals [ $env set a ] 5
        my assertEquals [ $env set b ] 5
    }


    TestObjectInterpreter instproc testArrayVariables { } {

        my instvar env oi


        $env set a(1) 6

        $oi tclEval {

            puts $a(1)
            set b(1) $a(1)
        }

        my assertEquals [ $env set a(1) ] 6
        my assertEquals [ $env set b(1) ] 6
    }

    TestObjectInterpreter instproc testProcs { } {

        my instvar env oi

        $env proc do { } {
            my set a 5
            return 6
        }

        $oi tclEval {
            do
            set b [ do ]
        }

        my assertEquals [ $env set a ] 5
        my assertEquals [ $env set b ] 6
    }

    TestObjectInterpreter instproc testDefineProc { } {

        my instvar env oi

        $oi tclEval {

            proc do { } {
                my set a 5
                return 6
            }

            do
            set b [ do ]
        }

        my assertEquals [ $env set a ] 5
        my assertEquals [ $env set b ] 6
    }

    TestObjectInterpreter instproc testTestCase { } {

        set env [ ::xointerp::test::TestCase new ]
        set oi [ ::xointerp::ObjectInterpreter new -environment $env ]

        my assertFailure {

            $oi tclEval {
                fail ack
            }
        }

        $oi tclEval {

            set a 5
            assertEquals $a 5
            assertListEqualsTrim $a 5
        }

        my assertEquals [ $env set a ] 5

        my assertFailure {

            $oi tclEval {

                set b 6
                assertEquals $b 5
            }
        }

        my assertEquals [ $env set b ] 6
    }

    TestObjectInterpreter instproc testError { } {

        set env [ ::xointerp::test::TestCase new ]
        set oi [ ::xointerp::ObjectInterpreter new -environment $env ]

        my assertError {

        $oi tclEval {

            notACommand
        }

        }
    }

    TestObjectInterpreter instproc testSemiColon { } {

        my instvar env oi

        $oi tclEval {

            set a 5; set b 6
        }

        my assertEquals [ $env set a ] 5
        my assertEquals [ $env set b ] 6
    }

    TestObjectInterpreter instproc testSemiColon2 { } {

        my instvar env oi

        $oi tclEval {
            <do>
        }

        my assertEquals [ $env set a ] 5

        $env unset a

        $oi tclEval {
            <do>
            <do2>
        }

        my assertEquals [ $env set a ] 2

        $env unset a

        $oi tclEval {
            <do>;
        }
    }

    TestObjectInterpreter instproc testGlobal { } {

        my instvar env oi

        proc ::xyz123456 { x } {

            return [ incr x ]
        }

        my assertEquals [ $oi tclEval {
            ::xyz123456 5
        } ] 6
    }

    TestObjectInterpreter instproc testAround { } {

        my instvar env oi

        my assertEquals [ $oi tclEval {
            xyz 1 2 3
        } ] 6
    }

    TestObjectInterpreter instproc testForeach { } {

        my instvar env oi

        my assertEquals [ $oi tclEval {
            set sum 0
            foreach x { 1 2 3 4 5 6 } {
                incr sum $x
            }
            set sum
        } ] 21

        my assertEquals [ $oi tclEval {
            set sum 0
            set list { 1 2 3 4 5 6 }
            foreach x $list {
                incr sum $x
            }
            set sum
        } ] 21
 
        my assertEquals [ $oi tclEval {
            set sum 0
            set list { 1 2 3 4 5 6 }
            set y x
            foreach $y $list {
                incr sum $x
            }
            set sum
        } ] 21
    }

    TestObjectInterpreter instproc testForeach2 { } {

        my instvar env oi

        my assertEquals [ $oi tclEval {
            set sum 0
            foreach { x y } { 1 2 3 4 5 6 } {
                incr sum $x
            }
            set sum
        } ] 9
    }

    TestObjectInterpreter instproc testForeach3 { } {

        my instvar env oi

        my assertEquals [ $oi tclEval {
            set sum 0
            foreach x { 1 3 5 } y { 2 4 6 } {
                incr sum $x
                incr sum $y
            }
            set sum
        } ] 21
    }

    TestObjectInterpreter instproc testIncr { } {

        my instvar env oi

        my assertEquals [ $oi tclEval {
            set b 5
            incr b
        } ] 6
    }

    TestObjectInterpreter instproc testIncr2 { } {

        my instvar env oi

        $env set b 5

        my assertEquals [ $oi tclEval {
            incr b
        } ] 6
    }

    TestObjectInterpreter instproc testExpr { } {

        my instvar env oi

        my assertEquals [ $oi tclEval {
            expr 1 + 1
        } ] 2

        my assertEquals [ $oi tclEval {
            expr { 1 + 1 }
        } ] 2

        $env set a 5

        my assertEquals [ $oi tclEval {
            expr $a + $a
        } ] 10

        $env set b 6

        my assertEquals [ $oi tclEval {
            expr { $b + $b }
        } ] 12

        my assertError { 
            $oi tclEval {
                expr { $c + $c }
            } 
        }
    }

    TestObjectInterpreter instproc testInterpretScript { } {

        my assertEquals [ ::xointerp::interpretScript ::xointerp::test::TestObject {
            set a 5
        } ] 5

        my assertEquals [ ::xointerp::interpretScript ::xointerp::test::TestObject {
            <do>
        } ] 5

        my assertEquals [ ::xointerp::interpretScript ::xointerp::test::TestObject {
            <do>
            <do2>
            <do3> 4
            return $a
        } ] 2

    }

    TestObjectInterpreter instproc testBreak { } {

        my instvar env oi

        my assertEquals [ $oi tclEval {
            set sum 0
            foreach x { 1 2 3 4 5 6 } {
                incr sum $x
                break
            }
            set sum
        } ] 1

        my assertEquals [ $oi tclEval {
            set sum 0
            while {1} {
                incr sum 
                break
            }
            set sum
        } ] 1
    }

    TestObjectInterpreter instproc testContinue { } {

        my instvar env oi

        my assertEquals [ $oi tclEval {
            set sum 0
            foreach x { 1 2 3 4 5 6 } {
                incr sum $x
                continue
            }
            set sum
        } ] 21

        my assertEquals [ $oi tclEval {
            set sum 0
            foreach x { 1 2 3 4 5 6 } {
                continue
                incr sum $x
            }
            set sum
        } ] 0

        my assertEquals [ $oi tclEval {
            set sum 0
            while { $sum < 10 } {
                incr sum 
                continue
            }
            set sum
        } ] 10
    }

    TestObjectInterpreter instproc testFor { } {

        my instvar env oi

        my assertEquals [ $oi tclEval {
            set sum 0
            for { set i 0 } { $i <= 6 } { incr i } {
                incr sum $i
            }
            set sum
        } ] 21

        my assertEquals [ $oi tclEval {
            set sum 0
            for { set i 1 } { $i <= 6 } { incr i } {
                incr sum $i
                break
            }
            set sum
        } ] 1
    
        my assertEquals [ $oi tclEval {
            set sum 0
            for { set i 1 } { $i <= 6 } { incr i } {
                incr sum $i
                continue
            }
            set sum
        } ] 21
    
        my assertEquals [ $oi tclEval {
            set sum 0
            for { set i 1 } { $i <= 6 } { incr i } {
                continue
                incr sum $i
            }
            set sum
        } ] 0
       }

    TestObjectInterpreter instproc testTime { } {

        my instvar env oi

        my assertEquals [ $oi tclEval {
            set sum 0
            time { for { set i 0 } { $i <= 6 } { incr i } {
                incr sum $i
            } } 1
            set sum
        } ] 21

        my assertEquals [ $oi tclEval {
            set sum 0
            puts [ time { for { set i 0 } { $i <= 6 } { incr i } {
                incr sum $i
            } } 1 ]
            set sum
        } ] 21
    }

    TestObjectInterpreter instproc testVariableCommand { } {

        my instvar env oi

        set library [ ::xointerp::Interpretable new ]
        $library proc doXYZ { var } {
            my set variable $var
        }
        set env [ Object new ]
        set oi [ ::xointerp::ObjectInterpreter new -library $library -environment $env ]

        $oi tclEval {
            doXYZ 5
        }

        my assertEquals [ $library set variable ] 5

        my assertError {

            $oi tclEval {
                set command doXYZ
                $command 6
            }
        }

        $oi tclEval {
            set command doXYZ
            eval $command 6
        }

        my assertEquals [ $library set variable ] 6

        Object create ${library}::child

        $oi tclEval {
            child
        }

        $oi tclEval {
            eval child
        }

        my assertError {

            $oi tclEval {
                set command child
                $command
            }
        }

        $oi tclEval {
            set command child
            eval $command
        }

        $oi tclEval {
            set command [ child ]
            $command
        }
    }

    TestObjectInterpreter instproc testCatch { } {

        my instvar env oi

        my assertFalse [ $env exists result ] result
        my assertFalse [ $env exists a ] a

        $oi tclEval {

            catch {
                error e
            } result
        }

        my assertEquals [ $env set result ] e

        $oi tclEval {
            catch {
                <do> 
            }
        }

        my assertEquals [ $env set a ] 5
    }
}


