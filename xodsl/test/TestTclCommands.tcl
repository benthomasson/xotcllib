# Created at Fri Aug 22 18:30:39 EDT 2008 by bthomass

namespace eval ::xodsl::test {

    Class TestTclCommands -superclass ::xounit::TestCase

    TestTclCommands parameter {

    }

    TestTclCommands instproc setUp { } {

        my instvar env language

        catch { unset ::a }
        catch { unset ::x }

        set language [ ::xodsl::SampleLanguage newLanguage ]
        set env [ $language set environment ]
    }

    TestTclCommands instproc testAfter { } {

        my instvar env 

        $env eval { after 100 }
    }

    TestTclCommands instproc testAppend { } {

        my instvar env 

        my assertEquals [ $env eval { append a b } ] b 
        my assertEquals [ $env set a ] b
    }

    TestTclCommands instproc testBreak { } {

        my instvar env 

        my assertError { $env eval { break } }
    }

    TestTclCommands instproc testCatch { } {

        my instvar env 

        my assertFalse [ $env eval { catch {} } ] 
        my assertTrue [ $env eval { catch { error e } } ] 
        my assertTrue [ $env eval { catch { error e } x } ] 
        
        my assertEquals [ $env set x ] e
    }

    TestTclCommands instproc testContinue { } {

        my instvar env 

        my assertError { $env eval { continue } }
    }

    TestTclCommands instproc testCd { } {

        my instvar env 

        $env eval { cd / } 
        my assertEquals [ pwd ] /

        cd [ ::xodsl packagePath ]
    }

    TestTclCommands instproc testClock { } {

        my instvar env 

        my assertEquals [ $env eval { clock seconds } ] [ clock seconds ]
    }

    TestTclCommands instproc testClose { } {

        my instvar env 

        $env eval {

            set file [ open /tmp/boo w ]
            close $file 
        }
    }

    TestTclCommands instproc testConcat { } {

        my instvar env 

        my assertEquals [ $env eval { concat {a b} {1 2} } ] [ list a b 1 2 ]
    }

    TestTclCommands instproc testEof { } {

        my instvar env 

        my assertEquals [ $env eval { eof stdin } ] 0
    }

    TestTclCommands instproc testError { } {

        my instvar env 

        set e [ my assertError { $env eval { error x123 } } ] 
        my assertEquals $e x123
    }

    TestTclCommands instproc testEval { } {

        my instvar env 

        my assertEquals [ $env eval { eval { set a 5 } } ] 5
        my assertEquals [ $env set a ] 5
    }

    TestTclCommands instproc testEval2 { } {

        my instvar env 

        my assertNoError {
            $env eval { eval { <do> } } 
        }

        my assertEquals [ $env set a ] 5
    }

    TestTclCommands instproc testUpLevel { } {

        my instvar env 

        my assertError {
            $env eval { uplevel { <do> } }
        }
    }

    TestTclCommands instproc testUpVar { } {

        my instvar env 

        set x 5

        my assertError {
             $env eval { upvar x x }
        }
    }

    TestTclCommands instproc testExec { } {

        my instvar env 

        my assertEquals [ $env eval { exec pwd } ] [ pwd ]
    }

    TestTclCommands instproc testExpr { } {

        my instvar env 

        my assertEquals [ $env eval { expr 1 > 0 } ] 1
        my assertEquals [ $env eval { expr 1 < 0 } ] 0
        my assertEquals [ $env eval { expr { 1 == 0 } } ] 0
        
        $env set a 5
        my assertEquals [ $env eval { expr { $a == 5 } } ] 1

        $env set a 5
        my assertEquals [ $env eval { expr $a == 5 } ] 1

        $env set a 5
        my assertEquals [ $env eval { expr "$a" == "5" } ] 1
        my assertEquals [ $env eval { expr { "$a" == "5" } } ] 1
        my assertEquals [ $env eval { expr { $a == 4 + 1 } } ] 1
    }

    TestTclCommands instproc testFile { } {

        my instvar env 

        my assertEquals [ $env eval { file join a b } ] a/b
        my assertEquals [ $env eval { set x [ file join a b ] } ] a/b
        my assertEquals [ $env set x ] a/b
    }

    TestTclCommands instproc testFlush { } {

        my instvar env 

        $env eval { flush stdout }
    }

    TestTclCommands instproc testFor { } {

        my instvar env 

        $env eval { 

            set a 0
            for { set i 0 } { $i <= 10 } { incr i } { incr a $i }
        }

        my assertEquals [ $env set i ] 11
        my assertEquals [ $env set a ] 55
    }

    TestTclCommands instproc testForEach { } {

        my instvar env 

        $env eval { 

            set a 0
            foreach i {0 1 2 3 4 5 6 7 8 9 10} {

                incr a $i
            }
        }

        my assertEquals [ $env set i ] 10
        my assertEquals [ $env set a ] 55
    }

    TestTclCommands instproc testGlob { } {

        my instvar env 

        $env eval { glob -nocomplain * }
        return
    }

    TestTclCommands instproc testGlobal { } {

        my instvar env 

        my assertError {

            $env eval { 
                global a 
            }
        }
    }

    TestTclCommands instproc notestGlobal { } {

        my instvar env 

        catch { unset ::x }

        set ::x 99

        $env eval { 
            global x 
            set x 5 
        }

        my assertEquals [ set ::x ] 5
        my assertTrue [ info exists ::x ]

        catch { unset ::x }

        my assertFalse [ info exists ::x ]

        $env eval { 
            set ::x 5 
        }

        my assertTrue [ info exists ::x ]
        my assertEquals $::x 5

        catch { unset ::x }

        my assertFalse [ info exists ::x ]
    }

    TestTclCommands instproc testGlobalConfusion { } {

        my instvar env 

        my assertFalse [ info exists ::x ]

        $env eval {
            set x 99
        }

        my assertFalse [ info exists ::x ]
        my assertEquals [ $env set x ] 99

    }

    TestTclCommands instproc testIf { } {

        my instvar env 

        $env eval {

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

        my instvar env 

        catch { unset ::x }

        $env set a 5

        my assertTrue [ $env eval { info exists a } ]
    }

    TestTclCommands instproc testIncr { } {

        my instvar env 

        my assertEquals [ $env eval {

            set a 5
            incr a

        } ] 6

        my assertEquals [ $env set a ] 6
    }

    TestTclCommands instproc testJoin { } {

        my instvar env 

        my assertEquals [ $env eval { join {a b c d e g} , } ] a,b,c,d,e,g
    }

    TestTclCommands instproc testLappend { } {

        my instvar env 

        my assertEquals [ $env eval { lappend a b
        lappend a c 
        lappend a d 
        } ] {b c d}
    }

    TestTclCommands instproc testLindex { } {

        my instvar env 

        my assertEquals [ $env eval { 
            set list {a b c d}
            lindex $list 3
        } ] d
    }

    TestTclCommands instproc testLindex { } {

        my instvar env 

        my assertEquals [ $env eval { 
            set list {a b c d}
            linsert $list 2 z
        } ] {a b z c d}
    }

    TestTclCommands instproc testList { } {

        my instvar env 

        my assertEquals [ $env eval { 
            list a b c d
        } ] {a b c d}
    }

    TestTclCommands instproc testLlength { } {

        my instvar env 

        my assertEquals [ $env eval { 
            llength [ list a b c d ]
        } ] 4
    }

    TestTclCommands instproc testLrange { } {

        my instvar env 

        my assertEquals [ $env eval { 
            lrange [ list a b c d ] 2 3
        } ] {c d}
    }

    TestTclCommands instproc testLreplace { } {

        my instvar env 

        my assertEquals [ $env eval { 
            set list {a b c d}
            lreplace $list 2 3 1 2 3
        } ] {a b 1 2 3}
    }

    TestTclCommands instproc testLsearch { } {

        my instvar env 

        my assertEquals [ $env eval { 
            set list {a b c d}
            lsearch $list c
        } ] 2
    }

    TestTclCommands instproc testLset { } {

        my instvar env 

        my assertEquals [ $env eval { 
            set list {a b c d}
            lset list 2 2
        } ] {a b 2 d}

        my assertEquals [ $env set list ] {a b 2 d}
    }

    TestTclCommands instproc testPackage { } {

        my instvar env 

        my assertEquals [ $env eval { 
            package require xox
        } ] [ package require xox ]
    }

    TestTclCommands instproc testPid { } {

        my instvar env 

        my assertEquals [ $env eval { 
            pid
        } ] [ pid ]
    }

    TestTclCommands instproc testProc { } {

        my instvar env 

        my assertEquals [ $env eval { 
            proc a { } {
                return 5
            }
            a
        } ] 5
    }

    TestTclCommands instproc testPuts { } {

        my instvar env 

        $env eval { 
            puts hi
            puts stdout hi
        } 
    }

    TestTclCommands instproc testPwd { } {

        my instvar env 

        my assertEquals [ $env eval { 
            pwd
        } ] [ pwd ]
    }

    TestTclCommands instproc testRegex { } {

        my instvar env 

        my assertEquals [ $env eval { 
            regexp a a all
        } ] 1

        my assertEquals [ $env set all ] a
    }

    TestTclCommands instproc testRegsub { } {

        my instvar env 

        my assertEquals [ $env eval { 
            regsub a a b new
        } ] 1

        my assertEquals [ $env set new ] b
    }


    TestTclCommands instproc testReturn { } {

        my instvar env 

        my assert [ catch {  $env eval { return x } } return ]
        my assertEquals $return x
    }

    TestTclCommands instproc testSet { } {

        my instvar env 

        my assertEquals [ $env eval { set a 5 } ] 5
        my assertEquals [ $env set a ] 5
    }

    TestTclCommands instproc testSplit { } {

        my instvar env 

        my assertListEquals [ $env eval { split 12131415 1 } ] {{} 2 3 4 5}
    }

    TestTclCommands instproc testString { } {

        my instvar env 

        my assertListEquals [ $env eval { string length 12345 } ] 5
    }

    TestTclCommands instproc testSubst { } {

        my instvar env 

        my assertEqualsTrim [ $env eval { 
            set a 5
            subst {
                $a $a $a
            }
        } ] "5 5 5"
    }

    TestTclCommands instproc testSwitch { } {

        my instvar env 

        my assertEqualsTrim [ $env eval { 

            set case 1

            switch $case {
                1 { set a 5 }
                2 { set b 6 }
            }

        } ] 5

        my assertEquals [ $env set a ] 5
    }

    TestTclCommands instproc testUnset { } {

        my instvar env 

        my assertEqualsTrim [ $env eval { 

            set a 5
            unset a
        } ] ""

        my assertFalse [ $env exists a ] 
    }

    TestTclCommands instproc testUplevel { } {

        my instvar env 

        my assertNoError { $env eval { 
            uplevel { set a 5 }
        } }
    }

    TestTclCommands instproc testUpvar { } {

        my instvar env 

        my assertError { 
            $env eval { 
                upvar a a
                set a 5
            } 
        }

        return "Upvar should throw an error in most languages."
    }

    TestTclCommands instproc testWhile { } {

        my instvar env 

        $env eval {

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


