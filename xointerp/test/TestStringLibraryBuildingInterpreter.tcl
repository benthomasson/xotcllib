# Created at Thu Feb 07 06:28:13 PM EST 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestStringLibraryBuildingInterpreter -superclass ::xounit::TestCase

    TestStringLibraryBuildingInterpreter parameter {

    }

    TestStringLibraryBuildingInterpreter instproc setUp { } {

        my instvar builder  library

        set library [ ::xointerp::StringBuilding new ]
        set builder [ ::xointerp::StringLibraryBuildingInterpreter new -library $library ]
    }

    TestStringLibraryBuildingInterpreter instproc testTclEval { } {

        my instvar builder 

        set string [ $builder tclEval {

            set a 5
            set b 6
        } ]

        my assertEqualsByLine $string \
"5
6"

        my assertEquals [ set a ] 5
        my assertEquals [ set b ] 6

        my assertEquals $a 5
        my assertEquals $b 6
    }

    TestStringLibraryBuildingInterpreter instproc testEvalSubst { } {

        my instvar builder 

        set string [ $builder evalSubst {

            [ set a 5 ]
            [ set b 6 ]
        } ]

        my assertEqualsByLine $string \
"5
6"

        my assertEquals [ set a ] 5
        my assertEquals [ set b ] 6

        my assertEquals $a 5
        my assertEquals $b 6
    }

    TestStringLibraryBuildingInterpreter instproc testGenerateSimple { } {

        my instvar builder 

        set string [ $builder generate {

            set a 5
            set b 6
        } ]

        my assertEqualsByLine $string \
"set a 5
set b 6"
    }

    TestStringLibraryBuildingInterpreter instproc testGenerateVariables { } {

        my instvar builder 

        set a 5
        set b 6

        set string [ $builder generate {

            set a $a
            set b $b
        } ]

        my assertEqualsByLine $string \
"set a 5
set b 6"
        my assertEquals $a 5
        my assertEquals $b 6
    }

    TestStringLibraryBuildingInterpreter instproc testGenerateCommands { } {

        my instvar builder 

        set a 5
        set b 6

        set string [ $builder generate {

            [set a]
            [set b]
            [set c 7]
        } ]

        my assertEqualsByLine $string \
"5
6
7"

        my assertEquals $a 5
        my assertEquals $b 6
        my assertEquals $c 7

    }


    TestStringLibraryBuildingInterpreter instproc testGenerateDynamicCommand { } {

        my instvar builder 

        set command set
        set a 5
        set b 6

        set string [ $builder generate {

            [$command a]
            [$command b]
            [$command c 7]
            $command
        } ]

        my assertEqualsByLine $string \
"5
6
7
set"

        my assertEquals $a 5
        my assertEquals $b 6
        my assertEquals $c 7
    }

    TestStringLibraryBuildingInterpreter instproc testFor { } {

        my instvar builder 

        set string [ $builder generate {

            [ for { set i 0 } { $i < 10 } { incr i } {[ identity $i ]} ]

        } ]

        my assertEqualsByLine $string "0123456789"
    }

    TestStringLibraryBuildingInterpreter instproc testForEachHard { } {

        my instvar builder 

        set string [ $builder generate {

            [ foreach i {0 1 2 3 4 5 6 7 8 9} {[identity $i]} ]

        } ]

        my assertEqualsByLine $string "0123456789"
    }

    TestStringLibraryBuildingInterpreter instproc testForEachVariable { } {

        my instvar builder 

        set list {0 1 2 3 4 5 6 7 8 9}

        set string [ $builder generate {
            [ foreach i $list {[identity $i]} ]
        } ]

        my assertEqualsByLine $string "0123456789"
    }

    TestStringLibraryBuildingInterpreter instproc testForEachCommand { } {

        my instvar builder library

        $library proc getList { } {

            return {0 1 2 3 4 5 6 7 8 9}
        }

        set string [ $builder generate {
            [ getList ]
            [ foreach i [ getList ] {[identity $i]} ]
        } ]

        my assertEqualsByLine $string \
"
0 1 2 3 4 5 6 7 8 9
0123456789"
    }

    TestStringLibraryBuildingInterpreter instproc testEvalSubCommandsVariableNames { } {

        my instvar builder

        set a \$a
        set b 2

        set string [ $builder generate {

            [ set a $a ]

        } ]

        my assertEqualsByLine $string \
"
\$a
"
    }
}



