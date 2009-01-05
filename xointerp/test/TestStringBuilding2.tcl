# Created at Sun Feb 10 11:26:02 EST 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestStringBuilding2 -superclass ::xointerp::test::TestStringBuilding

    TestStringBuilding2 parameter {

    }

    TestStringBuilding2 instproc setUp { } {

        my instvar builder environment

        set environment [ ::xointerp::StringBuilding new ]
        set builder [ ::xointerp::ObjectInterpreter new -environment $environment ]
    }

    TestStringBuilding2 instproc testBasic { } {

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

    TestStringBuilding2 instproc testIf2 { } {

        my instvar builder environment

        set string [ $builder evalSubst {

            [ puts hi ]

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

        my assertEqualsByLine $string \
"
set a 5
5
6"
        my assertEquals [ $environment set a ] 5
        my assertEquals [ $environment set b ] 6
        my assertFalse [ $environment exists c ]
    }
}
