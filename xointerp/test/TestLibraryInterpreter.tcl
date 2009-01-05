# Created at Sat Feb 09 23:10:50 EST 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestLibraryInterpreter -superclass ::xounit::TestCase

    TestLibraryInterpreter parameter {

    }

    TestLibraryInterpreter instproc setUp { } {

        my instvar li library

        set library [ ::xointerp::test::TestObject new ]
        set li [ ::xointerp::LibraryInterpreter new -library $library ]
    }

    TestLibraryInterpreter instproc test { } {

        my instvar library li

        $li tclEval {

            set a 5
            puts $a
            set b [ info class ]
            set ae [ exists a ]
            set ae2 [ ::info exists a ]
        }

        my assert [ info exists a ]
        my assertEquals $a 5
        my assertEquals $b ::xointerp::test::TestObject
        my assertEquals $ae 0
        my assertEquals $ae2 1
    }

    TestLibraryInterpreter instproc testVariables { } {

        my instvar library li

        set a 5

        $li tclEval {

            puts $a
            set b $a
        }

        my assertEquals [ set a ] 5
        my assertEquals [ set b ] 5
    }


    TestLibraryInterpreter instproc testArrayVariables { } {

        my instvar library li


        set a(1) 6

        $li tclEval {

            puts $a(1)
            set b(1) $a(1)
        }

        my assertEquals [ set a(1) ] 6
        my assertEquals [ set b(1) ] 6
    }

    TestLibraryInterpreter instproc testProcs { } {

        my instvar library li

        $library proc do { } {
            my set a 5
            return 6
        }

        $li tclEval {
            do
            set b [ do ]
        }

        my assertEquals [ $library set a ] 5
        my assertEquals [ set b ] 6
    }

    TestLibraryInterpreter instproc testDefineProc { } {

        my instvar library li

        $li tclEval {

            proc do { } {
                my set a 5
                return 6
            }

            do
            set b [ do ]
        }

        my assertEquals [ $library set a ] 5
        my assertEquals [ set b ] 6
    }

    TestLibraryInterpreter instproc testTestCase { } {

        set library [ ::xointerp::test::TestCase new ]
        set li [ ::xointerp::LibraryInterpreter new -library $library ]

        my assertFailure {

            $li tclEval {
                fail ack
            }
        }

        $li tclEval {

            set a 5
            assertEquals $a 5
            assertListEqualsTrim $a 5
        }

        my assertEquals [ set a ] 5

        my assertFailure {

            $li tclEval {

                set b 6
                assertEquals $b 5
            }
        }

        my assertEquals [ set b ] 6
    }

    TestLibraryInterpreter instproc testError { } {

        set library [ ::xointerp::test::TestCase new ]
        set li [ ::xointerp::LibraryInterpreter new -library $library ]

        my assertError {

        $li tclEval {

            notACommand
        }

        }
    }

    TestLibraryInterpreter instproc testTclInterpreterMultilineCommand { } {

        my instvar library li

        $li tclEval {

            set a [ <do>
                    <do2>
                    <do3> 5 ]
        }

        my assertEquals $a 6 a
    }

    TestLibraryInterpreter instproc tearDown { } {

        #add tear down code here
    }
}


