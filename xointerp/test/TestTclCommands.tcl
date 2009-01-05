# Created at Fri Aug 22 18:30:39 EDT 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestTclCommands -superclass ::xounit::TestCase

    TestTclCommands parameter {

    }

    TestTclCommands instproc setUp { } {

        my instvar env oi

        set env [ ::xointerp::test::TestObject new ]
        set oi [ ::xointerp::ObjectInterpreter new -environment $env ]
    }

    TestTclCommands instproc testAfter { } {

        my instvar env oi

        $oi tclEval { after 100 }
    }

    TestTclCommands instproc testAppend { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { append a b } ] b 
        my assertEquals [ $env set a ] b
    }

    TestTclCommands instproc testBreak { } {

        my instvar env oi

        set error [ my assertError { $oi tclEval { break } } ]
        my assertEquals [ $error info class ] ::xointerp::BreakSignal
    }

    TestTclCommands instproc testCatch { } {

        my instvar env oi

        my assertFalse [ $oi tclEval { catch {} } ] 
        my assertTrue [ $oi tclEval { catch { error e } } ] 
        my assertTrue [ $oi tclEval { catch { error e } x } ] 
        
        my assertEquals [ $env set x ] e
    }

    TestTclCommands instproc testContinue { } {

        my instvar env oi

        set error [ my assertError { $oi tclEval { continue } } ]
        my assertEquals [ $error info class ] ::xointerp::ContinueSignal
    }

    TestTclCommands instproc testCd { } {

        my instvar env oi

        $oi tclEval { cd / } 
        my assertEquals [ pwd ] /

        cd [ ::xointerp packagePath ]
    }

    TestTclCommands instproc testClock { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { clock seconds } ] [ clock seconds ]
    }

    TestTclCommands instproc testClose { } {

        my instvar env oi

        $oi tclEval {

            set file [ open /tmp/boo w ]
            close $file 
        }
    }

    TestTclCommands instproc testConcat { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { concat {a b} {1 2} } ] [ list a b 1 2 ]
    }

    TestTclCommands instproc testEof { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { eof stdin } ] 0
    }

    TestTclCommands instproc testError { } {

        my instvar env oi

        set e [ my assertError { $oi tclEval { error x123 } } ] 
        my assertEquals [ $e message ] x123
    }

    TestTclCommands instproc testEval { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { eval { set a 5 } } ] 5
        my assertEquals [ $env set a ] 5
    }

    TestTclCommands instproc testEval2 { } {

        my instvar env oi

        my assertError {
            $oi tclEval { eval { <do> } } 
        }
    }

    TestTclCommands instproc testUpLevel { } {

        my instvar env oi

        my assertError {
            $oi tclEval { uplevel { <do> } }
        }
    }

    TestTclCommands instproc testUpVar { } {

        my instvar env oi

        my assertError {
             $oi tclEval { upvar x x }
        }
    }

    TestTclCommands instproc testExec { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { exec pwd } ] [ pwd ]
    }

    TestTclCommands instproc testExpr { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { expr 1 > 0 } ] 1
        my assertEquals [ $oi tclEval { expr 1 < 0 } ] 0
        my assertEquals [ $oi tclEval { expr { 1 == 0 } } ] 0
        
        $env set a 5
        my assertEquals [ $oi tclEval { expr { $a == 5 } } ] 1

        $env set a 5
        my assertEquals [ $oi tclEval { expr $a == 5 } ] 1

        $env set a 5
        my assertEquals [ $oi tclEval { expr "$a" == "5" } ] 1
        my assertEquals [ $oi tclEval { expr { "$a" == "5" } } ] 1
        my assertEquals [ $oi tclEval { expr { $a == 4 + 1 } } ] 1
    }

    TestTclCommands instproc testFile { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { file join a b } ] a/b
        my assertEquals [ $oi tclEval { set x [ file join a b ] } ] a/b
        my assertEquals [ $env set x ] a/b
    }

    TestTclCommands instproc testFlush { } {

        my instvar env oi

        $oi tclEval { flush stdout }
    }

    TestTclCommands instproc testFor { } {

        my instvar env oi

        $oi tclEval { 

            set a 0
            for { set i 0 } { $i <= 10 } { incr i } { incr a $i }
        }

        my assertEquals [ $env set i ] 11
        my assertEquals [ $env set a ] 55
    }

    TestTclCommands instproc testForEach { } {

        my instvar env oi

        $oi tclEval { 

            set a 0
            foreach i {0 1 2 3 4 5 6 7 8 9 10} {

                incr a $i
            }
        }

        my assertEquals [ $env set i ] 10
        my assertEquals [ $env set a ] 55
    }

    TestTclCommands instproc testGlob { } {

        my instvar env oi

        $oi tclEval { glob -nocomplain * }
        return
    }

    TestTclCommands instproc testGlobal { } {

        my instvar env oi

        catch { unset ::x }

        $oi tclEval { 
            global x 
            set x 5 
        }

        my assertEquals $::x 5
    }

    TestTclCommands instproc testIf { } {

        my instvar env oi

        $oi tclEval {

            if 1 {
                set a 1
            }

            if 0 {
                set b 1

            }

            if { 1 < 0 } {
                set c 1

            }

            if { 1 > 0 } {
                set d 1
            }
        }

        my assertTrue [ $env exists a ]
        my assertFalse [ $env exists b ]
        my assertFalse [ $env exists c ]
        my assertTrue [ $env exists d ]

    }

    TestTclCommands instproc testInfo { } {

        my instvar env oi

        catch { unset ::x }

        $env set a 5

        my assertTrue [ $oi tclEval { exists a } ]
        my assertTrue [ $oi tclEval { info exists a } ]
    }

    TestTclCommands instproc testIncr { } {

        my instvar env oi

        my assertEquals [ $oi tclEval {

            set a 5
            incr a

        } ] 6

        my assertEquals [ $env set a ] 6
    }

    TestTclCommands instproc testJoin { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { join {a b c d e g} , } ] a,b,c,d,e,g
    }

    TestTclCommands instproc testLappend { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { lappend a b
        lappend a c 
        lappend a d 
        } ] {b c d}
    }

    TestTclCommands instproc testLindex { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { 
            set list {a b c d}
            lindex $list 3
        } ] d
    }

    TestTclCommands instproc testLindex { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { 
            set list {a b c d}
            linsert $list 2 z
        } ] {a b z c d}
    }

    TestTclCommands instproc testList { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { 
            list a b c d
        } ] {a b c d}
    }

    TestTclCommands instproc testLlength { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { 
            llength [ list a b c d ]
        } ] 4
    }

    TestTclCommands instproc testLrange { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { 
            lrange [ list a b c d ] 2 3
        } ] {c d}
    }

    TestTclCommands instproc testLreplace { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { 
            set list {a b c d}
            lreplace $list 2 3 1 2 3
        } ] {a b 1 2 3}
    }

    TestTclCommands instproc testLsearch { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { 
            set list {a b c d}
            lsearch $list c
        } ] 2
    }

    TestTclCommands instproc testLset { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { 
            set list {a b c d}
            lset list 2 2
        } ] {a b 2 d}

        my assertEquals [ $env set list ] {a b 2 d}
    }

    TestTclCommands instproc testPackage { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { 
            package require xox
        } ] [ package require xox ]
    }

    TestTclCommands instproc testPid { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { 
            pid
        } ] [ pid ]
    }

    TestTclCommands instproc testProc { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { 
            proc a { } {
                return 5
            }
            a
        } ] 5
    }

    TestTclCommands instproc testPuts { } {

        my instvar env oi

        $oi tclEval { 
            puts hi
            puts stdout hi
        } 
    }

    TestTclCommands instproc testPwd { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { 
            pwd
        } ] [ pwd ]
    }

    TestTclCommands instproc testRegex { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { 
            regexp a a all
        } ] 1

        my assertEquals [ $env set all ] a
    }

    TestTclCommands instproc testRegsub { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { 
            regsub a a b new
        } ] 1

        my assertEquals [ $env set new ] b
    }


    TestTclCommands instproc testReturn { } {

        my instvar env oi

        my assert [ catch {  $oi tclEval { return x } } return ]
        my assertEquals $return x
    }

    TestTclCommands instproc testSet { } {

        my instvar env oi

        my assertEquals [ $oi tclEval { set a 5 } ] 5
        my assertEquals [ $env set a ] 5
    }

    TestTclCommands instproc testSplit { } {

        my instvar env oi

        my assertListEquals [ $oi tclEval { split 12131415 1 } ] {{} 2 3 4 5}
    }

    TestTclCommands instproc testString { } {

        my instvar env oi

        my assertListEquals [ $oi tclEval { string length 12345 } ] 5
    }

    TestTclCommands instproc testSubst { } {

        my instvar env oi

        my assertEqualsTrim [ $oi tclEval { 
            set a 5
            subst {
                $a $a $a
            }
        } ] "5 5 5"
    }

    TestTclCommands instproc testSwitch { } {

        my instvar env oi

        my assertEqualsTrim [ $oi tclEval { 

            set case 1

            switch $case {
                1 { set a 5 }
                2 { set b 6 }
            }

        } ] 5

        my assertEquals [ $env set a ] 5
    }

    TestTclCommands instproc testUnset { } {

        my instvar env oi

        my assertEqualsTrim [ $oi tclEval { 

            set a 5
            unset a
        } ] ""

        my assertFalse [ $env exists a ] 
    }

    TestTclCommands instproc testUplevel { } {

        my instvar env oi

        my assertError { $oi tclEval { 
            uplevel { set a 5 }
        } }

        return "Uplevel should throw an error in most languages."
    }

    TestTclCommands instproc testUpvar { } {

        my instvar env oi

        my assertError { 
            $oi tclEval { 
                upvar a a
                set a 5
            } 
        }

        return "Upvar should throw an error in most languages."
    }

    TestTclCommands instproc testWhile { } {

        my instvar env oi

        $oi tclEval {

            while 0 {
                set a 1
            }

            while 1 {

                set b 1
                break
            }
        }

        my assertFalse [ $env exists a ]
        my assertTrue [ $env exists b ]
    }

    TestTclCommands instproc tearDown { } {

        #add tear down code here
    }
}


