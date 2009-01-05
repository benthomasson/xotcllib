# Created at Sun Feb 10 11:26:02 EST 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestStringBuilding -superclass ::xounit::TestCase

    TestStringBuilding parameter {

    }

    TestStringBuilding instproc setUp { } {

        my instvar builder 

        set builder [ ::xointerp::LibraryInterpreter new -library [ ::xointerp::StringBuilding new ] ]
    }

    TestStringBuilding instproc testBasic { } {

        my instvar builder 

        set string [ $builder evalSubst {
            [ set a 5 ]
            [ set b 6 ]
        } ]

        my assertEqualsByLine $string \
"5
6"

        my assertEquals $a 5
        my assertEquals $b 6
    }

    TestStringBuilding instproc testIf2 { } {

        my instvar builder 

        set currentLevel [ info level ]

        set string [ $builder evalSubst {

            [ set level [ $builder currentLevel ]
            puts hi ]

            [ if 1 {
                set a 5
            } ]

            [ if 1 {
              [ set a 5 ]
            } ]

            [ if 1 {
                [ set b 6 ]
            } ]

            [ if 0 {
                 [ set c 7 ]
            } ]

        } ]

        my assertEquals #${currentLevel} $level

        my assertEqualsByLine $string \
"
set a 5
5
6"
        my assertEquals $a 5
        my assertEquals $b 6
        my assertFalse [ info exists c ]
    }

    TestStringBuilding instproc testForEach2 { } {

        my instvar builder 

        set string [ $builder evalSubst {

            [ foreach i { a b c d e f g } {[ identity $i ]} ]

        } ]

        my assertEqualsByLine $string "abcdefg"
    }

    TestStringBuilding instproc testWhile2 { } {


        set builder [ ::xointerp::LibraryInterpreter new -library [ ::xointerp::StringBuilding new ] ]

        set i 0

        set string [ $builder evalSubst {

            [ while { $i < 10 } {

                [ incr i
                identity $i ]
            } ]

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

    TestStringBuilding instproc testFor2 { } {

        my instvar builder 

        set string [ $builder evalSubst {

            [ for { set i 0 } { $i < 10 } { incr i } {
                [ identity $i ]
            } ]

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

    TestStringBuilding instproc testForEach2-2 { } {

        my instvar builder 

        set string [ $builder evalSubst {

            [ foreach i { a b c d e f g } {$i} ]

        } ]

        my assertEqualsByLine $string "abcdefg"
    }

    TestStringBuilding instproc testForEach2Continue { } {

        my instvar builder 

        my assertError {

        set string [ $builder evalSubst {

            [ foreach i { a b c d e f g } {$i[ continue  ]} ]

        } ]

        }
    }

    TestStringBuilding instproc testForEach2Break { } {

        my instvar builder 

        set string [ $builder evalSubst {

            [ foreach i { a b c d e f g } {[ break
            set i 5
            ]$i} ]

        } ]

        my assertEqualsByLine $string ""
    }

    TestStringBuilding instproc testForEach2Break2 { } {

        my instvar builder 

        set string [ $builder evalSubst {

            [ foreach i { a b c d e f g } {[ if { "$i" == "b" } { [ break ] } ]$i} ]

        } ]

        my assertEqualsByLine $string "a"
    }

    TestStringBuilding instproc testBuildString { } {

        my assertEqualsByLine [ ::xointerp::buildString {

        } ] ""

        my assertEqualsByLine [ ::xointerp::buildString {
            abcdefg
        } ] "abcdefg"

        set a 5

        my assertEqualsByLine [ ::xointerp::buildString {
            ${a}bcdefg
        } ] "5bcdefg"

        my assertEqualsByLine [ ::xointerp::buildString {
            [ foreach i { a b c d e f g } {$i} ]
        } ] "abcdefg"

        set list { a b c d e f g }

        my assertEqualsByLine [ ::xointerp::buildString {
            [ foreach i $list {$i} ]
        } ] "abcdefg"

        my assertEqualsByLine [ ::xointerp::buildString {
            [ if 1 {
                $a
            } else {
                $b
            } ]
        } ] "5"
    }

    TestStringBuilding instproc testProc { } {

        my instvar builder 

        my assertEqualsByLine [ $builder evalSubst {
            [ 
                proc doX { a b c } {
                    return "$a $b $c"
                } 
                doX 1 2 3 
            ]
        } ] "1 2 3"
    }

    TestStringBuilding instproc testQuote { } {

        set sb [ ::xointerp::StringBuilding new ]

        my assertEquals [ $sb quote ] ""
        my assertEqualsTrim [ $sb quote a b c] {a b c}
        my assertEquals [ $sb quote {a b c} ] {a b c}


        my assertEquals [ $sb ' ] ""
        my assertEqualsTrim [ $sb ' a b c ] {a b c}
        my assertEqualsTrim [ $sb ' {a b c} ] {a b c}
    }
}


