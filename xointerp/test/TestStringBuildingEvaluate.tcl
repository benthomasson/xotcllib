# Created at Sat Aug 16 13:12:10 EDT 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestStringBuildingEvaluate -superclass ::xounit::TestCase

    TestStringBuildingEvaluate parameter {

    }

    TestStringBuildingEvaluate instproc setUp { } {

        my instvar builder environment

        set environment [ ::xointerp::StringBuildingEvaluate new ] 
        set builder [ ::xointerp::StringBuildingInterpreter new -environment $environment ]
    }

    TestStringBuildingEvaluate instproc testBasic { } {

        my instvar builder environment

        set string [ $builder tclEval {
            set a 5
            set b 6
        } ]

        my assertEqualsByLine $string \
"5
6"

        my assertEquals [ $environment set a ] 5
        my assertEquals [ $environment set b ] 6
    }

    TestStringBuildingEvaluate instproc testIf2 { } {

        my instvar builder environment

        set string [ $builder tclEval {

            puts hi 

            if 1 {
                set a 5
            }

            if 1 {
              set a 5 
            } 

            if 1 {
                set b 6
            } 

            if 0 {
                set c 7
            } 

        } ]

        my assertEqualsByLine $string \
"
5
5
6"
        my assertEquals [ $environment set a ] 5
        my assertEquals [ $environment set b ] 6
        my assertFalse [ $environment exists c ]
    }

    TestStringBuildingEvaluate instproc testForEach2 { } {

        my instvar builder 

        set string [ $builder tclEval {

            foreach i { a b c d e f g } {
                quote $i
            } 
        } ]

        my assertEqualsByLine $string "abcdefg"
    }

    TestStringBuildingEvaluate instproc testForEachEmpty { } {

        my instvar builder 

        set string [ $builder tclEval {

            foreach i {} {
                quote $i
            } 
        } ]

        my assertEqualsByLine $string ""
    }

    TestStringBuildingEvaluate instproc testForEachObjectVars { } {

        my instvar builder 

        set string [ $builder tclEval {

            foreach i [ ::xotcl::Object info vars ] {
                quote $i
            } 
        } ]

        my assertEqualsByLine $string "#"
    }

    TestStringBuildingEvaluate instproc testForEach# { } {

        my instvar builder 

        set string [ $builder tclEval {

            foreach i {#} {
                quote $i
            } 
        } ]

        my assertEqualsByLine $string "#"
    }

    TestStringBuildingEvaluate instproc testWhile2 { } {

        my instvar builder environment

        $environment set i 0

        set string [ $builder tclEval {

            while { $i < 10 } {
                quiet { incr i }
                identity $i
            }
        } ]

        my assertEqualsByLine $string \
"1
2
3
4
5
6
7
8
9
10"
    }

    TestStringBuildingEvaluate instproc testFor2 { } {

        my instvar builder 

        set string [ $builder tclEval {
            for { set i 0 } { $i < 10 } { incr i } {
                identity "$i\n"
            }
        } ]

        my assertEqualsByLine $string \
"0
1
2
3
4
5
6
7
8
9"
    }

    TestStringBuildingEvaluate instproc testForEach2-2 { } {

        my instvar builder 

        set string [ $builder tclEval {

            foreach i { a b c d e f g } {
                quote $i
            }
        } ]

        my assertEqualsByLine $string "abcdefg"
    }

    TestStringBuildingEvaluate instproc testForEach2Continue { } {

        my instvar builder 

        my assertError {

            set string [ $builder tclEval {

                foreach i { a b c d e f g } {
                    quote $i
                    continue 
                }
            } ]
        }
    }

    TestStringBuildingEvaluate instproc testForEach2Break { } {

        my instvar builder 

        set string [ $builder tclEval {

            foreach i { a b c d e f g } {
                break
                set i 5
                quote $i
            } 
        } ]

        my assertEqualsByLine $string ""
    }

    TestStringBuildingEvaluate instproc testForEach2Break2 { } {

        my instvar builder 

        set string [ $builder tclEval {

            foreach i { a b c d e f g } {
                if { "$i" == "b" } {
                    break 
                }
                quote $i
            }
        } ]

        my assertEqualsByLine $string "a"
    }

    TestStringBuildingEvaluate instproc testForeachCall { } {

        my instvar builder

        my assertEqualsByLine [ $builder tclEval {

            quiet {
                Object create ::o
                ::o set a 5
                ::o set b 6
            }
            ::o info vars

            foreach var [ ::o info vars ] {
                ' $var
            }
        } ] {a b
        ab
        }
    }

    TestStringBuildingEvaluate instproc tearDown { } {

        #add tear down code here
    }
}


