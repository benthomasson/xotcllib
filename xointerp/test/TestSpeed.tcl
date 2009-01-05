# Created at Fri Sep 05 11:00:00 AM EDT 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestSpeed -superclass ::xounit::TestCase

    TestSpeed parameter {

    }

    TestSpeed instproc setUp { } {

        #add set up code here
    }

    TestSpeed instproc testTclForLoop { } {

        set value 0

        time { 
            for { set loop 0 } { $loop < 10000 } { incr loop } {
                incr value
            }
        } 1
    }

    TestSpeed instproc testTclEvalForLoop { } {

        set value 0

        time { 
            eval {
                for { set loop 0 } { $loop < 10000 } { incr loop } {
                    incr value
                }
            }
        } 1
    }

    TestSpeed instproc testTclEvalInnerForLoop { } {

        set value 0

        time { 
            for { set loop 0 } { $loop < 10000 } { incr loop } {
                eval {
                    incr value
                }
            }
        } 1
    }

    TestSpeed instproc testXointerpForLoop { } {

        set env [ ::xointerp::test::TestObject new ]
        set oi [ ::xointerp::ObjectInterpreter new -environment $env ]

        $env set value 0

        time { 
            $oi tclEval {
                for { set loop 0 } { $loop < 100 } { incr loop } {
                    incr value
                }
            }
        } 1
    }

    TestSpeed instproc tearDown { } {

        #add tear down code here
    }
}


