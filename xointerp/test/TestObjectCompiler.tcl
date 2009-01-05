# Created at Sun Sep 07 08:58:06 EDT 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestObjectCompiler -superclass ::xounit::TestCase

    TestObjectCompiler parameter {

    }

    TestObjectCompiler instproc setUp { } {

        my instvar compiler interpreter environment library

        set environment [ ::xointerp::test::TestObject new ]
        set library $environment
        set interpreter [ ::xointerp::ObjectInterpreter new -environment $environment -library $library ]
        set compiler [ ::xointerp::ObjectCompiler new -interpreter $interpreter -environment $environment -library $library ]
    }

    TestObjectCompiler instproc testEmpty { } {

        my instvar compiler interpreter environment library

        my assertEqualsByLine [ $compiler compileScript {
        } ] [ subst {
        } ]
    }

    TestObjectCompiler instproc testSet { } {

        my instvar compiler interpreter environment library

        my assertEqualsByLine [ $compiler compileScript {
            set a 5
        } ] [ subst {
           $environment eval { set a 5 } 
        } ]

        my assertFalse [ $environment exists a ] a-exists

        eval [ $compiler compileScript {
            set a 5
        } ] 

        my assertObjectValues $environment {
            a 5
        }
    }

    TestObjectCompiler instproc testVariables { } {

        my instvar compiler interpreter environment library

        my assertEqualsByLine [ $compiler compileScript {
            set a 5
            set b $a
        } ] [ subst {
           $environment eval { set a 5 } 
           $environment eval { set b \$a } 
        } ]

        my assertFalse [ $environment exists a ] a-exists

        eval [ $compiler compileScript {
            set a 5
            set b $a
        } ] 

        my assertObjectValues $environment {
            a 5
            b 5
        }
    }

    TestObjectCompiler instproc testIncr { } {

        my instvar compiler interpreter environment library

        $environment set a 5

        my assertEqualsByLine [ $compiler compileScript {
            incr a
        } ] [ subst {
           $environment eval { incr a } 
        } ]

        my assertObjectValues $environment {
            a 5
        }

        eval [ $compiler compileScript {
            incr a
        } ] 

        my assertObjectValues $environment {
            a 6
        }
    }

    TestObjectCompiler instproc testPuts { } {

        my instvar compiler interpreter environment library

        my assertEqualsByLine [ $compiler compileScript {
            puts hi
        } ] [ subst {
           $environment eval { puts hi }
        } ]

        eval [ $compiler compileScript {
            puts hi
        } ]
    }

    TestObjectCompiler instproc testLanguageCommand { } {

        my instvar compiler interpreter environment library

        my assertEqualsByLine [ $compiler compileScript {
            <do>
        } ] [ subst {
           $environment eval { $library <do> } 
        } ]

        eval [ $compiler compileScript {
            <do>
        } ] 

        my assertObjectValues $environment {
            a 5
        }
    }

    TestObjectCompiler instproc testSetSquareBracketCommand { } {

        my instvar compiler interpreter environment library

        my assertEqualsByLine [ $compiler compileScript {
            set a [ set b 5 ]
        } ] [ subst {
           $environment eval { set a \[ $environment eval { set b 5 } \] }
        } ]

        my assertFalse [ $environment exists a ] a-exists

        eval [ $compiler compileScript {
            set a [ set b 5 ]
        } ] 

        my assertObjectValues $environment {
            a 5
            b 5
        }
    }

    TestObjectCompiler instproc getGensymMinus { x } {

        return "::xointerp::gensym::v[ expr { [ ::xointerp::ObjectCompiler set commandNumber ] - $x } ]"
    }

    TestObjectCompiler instproc testListSquareBracketCommand { } {

        my instvar compiler interpreter environment library

        my assertEqualsByLine [ $compiler compileScript {
            set a [ list [ set b 5 ] [ set c 6 ] ]
        } ] [ subst {
           $environment eval { set a \[ $environment eval { list \[ $environment eval { set b 5 } \] \[ $environment eval { set c 6 } \] } ] }
        } ]

        my assertFalse [ $environment exists a ] a-exists

        eval [ $compiler compileScript {
            set a [ list [ set b 5 ] [ set c 6 ] ]
        } ] 

        my assertObjectValues $environment {
            a {5 6}
            b 5
            c 6
        }
    }

    TestObjectCompiler instproc testForSpeedBodyOnly { } {

        my instvar compiler interpreter environment library

        $environment set value 0

        set slow [ lindex [ time { 
            $interpreter tclEval {
                for { set loop 0 } { $loop < 100 } { incr loop } {
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                }
            }
        } 1 ] 0 ]

        set fast [ lindex [ time { 
            set script [ $compiler compileScript {
                incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
            } ]

            for { set loop 0 } { $loop < 100 } { incr loop } {
                eval $script
            }
        } 1 ] 0 ]

        return "[ expr { $slow / $fast } ] times faster!!!"
    }

    TestObjectCompiler instproc testIfDev1 { } {

        my instvar compiler interpreter environment library

        $environment set sum 0

        set script [ $compiler compileScript {
            incr sum
        } ]

        eval [ subst {
            if 1 {
                $script
            }
        } ]

        my assertEquals [ $environment set sum ] 1

        set script [ $compiler compileScript {
            if 1 {
                incr sum
            }
        } ]

        #puts "2:$script"
        eval $script

        my assertEquals [ $environment set sum ] 2

        set script [ $compiler compileScript {
            if 0 {
                incr sum -1
            } else {
                incr sum
            }
        } ]

        #puts "3:$script"
        eval $script

        my assertEquals [ $environment set sum ] 3

        set script [ $compiler compileScript {
            if 0 {
                incr sum -1
            } elseif 1 {
                incr sum
            } else {
                incr sum 2
            }
        } ]

        #puts "4:$script"
        eval $script

        my assertEquals [ $environment set sum ] 4

        set script [ $compiler compileScript {
            if 0 {
                incr sum -1
            } elseif 0 {
                incr sum 2
            } else {
                incr sum 1
            }
        } ]

        #puts "5:$script"
        eval $script

        my assertEquals [ $environment set sum ] 5
    }

    TestObjectCompiler instproc testForeach1 { } {

        my instvar compiler interpreter environment library

        $environment set sum 0

        set script [ $compiler compileScript {
            foreach item { 1 2 3 4 5} {
                incr sum $item
            }
        } ]

        puts $script
        eval $script

        my assertEquals [ $environment set sum ] 15 
    }

    TestObjectCompiler instproc testWhile1 { } {
        
        my instvar compiler interpreter environment library

        $environment set sum 0

        set script [ $compiler compileScript {
            while { $sum < 10 } {
                incr sum 
            }
        } ]

        puts $script
        eval $script

        my assertEquals [ $environment set sum ] 10 
    }

    TestObjectCompiler instproc testFor1 { } {
        
        my instvar compiler interpreter environment library

        $environment set sum 0

        set script [ $compiler compileScript {
            for { set sum 0 }  { $sum < 10 } {  incr sum } {
                puts $sum 
            }
        } ]

        puts $script
        eval $script

        my assertEquals [ $environment set sum ] 10 
    }

    TestObjectCompiler instproc testForeach1 { } {
        
        my instvar compiler interpreter environment library

        $environment set sum 0

        set script [ $compiler compileScript {
            foreach item { 1 2 3 4 5 } {
                incr sum $item
                puts $sum
            }
        } ]

        puts $script
        eval $script

        my assertEquals [ $environment set sum ] 15 
    }

    TestObjectCompiler instproc testForeach2 { } {
        
        my instvar compiler interpreter environment library

        $environment set sum 0

        set script [ $compiler compileScript {
            foreach item  [ list 1 2 3 4 5 ] {
                incr sum $item
                puts $sum
            }
        } ]

        puts $script
        eval $script

        my assertEquals [ $environment set sum ] 15 
    }

    TestObjectCompiler instproc testForeach3 { } {
        
        my instvar compiler interpreter environment library

        $environment set sum 0

        set script [ $compiler compileScript {
            set list [ list 1 2 3 4 5 ]
            foreach item $list {
                incr sum $item
                puts $sum
            }
        } ]

        puts $script
        eval $script

        my assertEquals [ $environment set sum ] 15 
    }

    TestObjectCompiler instproc testForeach4 { } {
        
        my instvar compiler interpreter environment library

        $environment set sum 0

        set script [ $compiler compileScript {
            set list [ list 1 2 3 4 5 6 ]
            foreach {i j} $list {
                incr sum $i
                incr sum $j
                puts $sum
            }
        } ]

        puts $script
        eval $script

        my assertEquals [ $environment set sum ] 21 
    }

    TestObjectCompiler instproc testForeach5 { } {
        
        my instvar compiler interpreter environment library

        $environment set sum 0

        set script [ $compiler compileScript {
            set list [ list 1 2 3 4 5 6 ]
            foreach i $list j $list {
                incr sum $i
                incr sum $j
                puts $sum
            }
        } ]

        puts $script
        eval $script

        my assertEquals [ $environment set sum ] 42 
    }

    TestObjectCompiler instproc tearDown { } {

        #add tear down code here
    }

    TestObjectCompiler instproc testForSpeed { } {

        my instvar compiler interpreter environment library

        $environment set value 0

        set slow [ lindex [ time { 
            $interpreter tclEval {
                for { set loop 0 } { $loop < 100 } { incr loop } {
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                    incr value
                }
            }
        } 1 ] 0 ]

        set fast [ lindex [ time { 
            set script [ $compiler compileScript {
                for { set loop 0 } { $loop < 100 } { incr loop } {
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
                        incr value
            }
            } ]

            puts $script

            eval $script

        } 1 ] 0 ]

        return "[ expr { $slow / $fast } ] times faster!!!"
    }

    TestObjectCompiler instproc testTime { } {
        
        my instvar compiler interpreter environment library

        set script [ $compiler compileScript {
            time { set a 5 } 1
        } ]

        puts $script
        puts [ eval $script ]

        my assertEquals [ $environment set a ] 5
    }
}


