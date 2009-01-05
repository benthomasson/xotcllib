# Created at Thu Jul 31 10:22:09 AM EDT 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestListBuildingInterpreter -superclass ::xounit::TestCase

    TestListBuildingInterpreter parameter {

    }

    TestListBuildingInterpreter instproc setUp { } {

        my instvar builder environment

        set environment [ ::xointerp::test::TestObject new ]
        set builder [ ::xointerp::ListBuildingInterpreter new -environment $environment ]
    }

    TestListBuildingInterpreter instproc testEvalSubst { } {
        
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

    TestListBuildingInterpreter instproc testTclEval { } {

        my instvar builder environment

        set string [ $builder tclEval {

             set a 5 
             set b 6 
        } ]

        my assertEqualsByLine $string \
"5 6"

        my assertEquals [ $environment set a ] 5
        my assertEquals [ $environment set b ] 6
    }

    TestListBuildingInterpreter instproc testTclEval2 { } {

        my instvar builder environment

        set string [ $builder tclEval {

             set a {1 2 3}
             set b {4 5 6}
        } ]

        my assertEqualsByLine $string \
"{1 2 3} {4 5 6}"

        my assertEquals [ $environment set a ] {1 2 3}
        my assertEquals [ $environment set b ] {4 5 6} 
    }

    TestListBuildingInterpreter instproc tearDown { } {

        #add tear down code here
    }
}


