# Created at Thu Feb 07 06:28:13 PM EST 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestStringBuildingInterpreter -superclass ::xounit::TestCase

    TestStringBuildingInterpreter parameter {

    }

    TestStringBuildingInterpreter instproc setUp { } {

        my instvar builder environment

        set environment [ ::xointerp::test::TestObject new ]
        set builder [ ::xointerp::StringBuildingInterpreter new -environment $environment ]
    }

    TestStringBuildingInterpreter instproc testEvalSubst { } {

        my instvar builder environment

        set string [ $builder evalSubst {

            [ set a 5 ]
            [ set b 6 ]
        } ]

        my assertEqualsByLine $string \
"5
6"

        my assertEquals [ $environment set a ] 5
        my assertEquals [ $environment set b ] 6
    }

    TestStringBuildingInterpreter instproc testTclEval { } {

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

    TestStringBuildingInterpreter instproc testTclEval2 { } {

        my instvar builder environment

        set string [ $builder tclEval {

             set a {1 2 3}
             set b {4 5 6}
        } ]

        my assertEqualsByLine $string \
"1 2 3 
4 5 6"

        my assertEquals [ $environment set a ] {1 2 3}
        my assertEquals [ $environment set b ] {4 5 6} 
     }
}


