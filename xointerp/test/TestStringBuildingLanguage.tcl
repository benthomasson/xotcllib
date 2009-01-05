# Created at Sun Aug 24 15:49:44 EDT 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestStringBuildingLanguage -superclass ::xounit::TestCase

    TestStringBuildingLanguage parameter {

    }

    TestStringBuildingLanguage instproc setUp { } {

        my instvar interpreter language

        set language [ ::xointerp::StringBuildingLanguage new ]
        set interpreter [ ::xointerp::LinearStringBuildingInterpreter new -environment $language -library $language ]
        $language interpreter $interpreter
        $language collector $interpreter
    }

    TestStringBuildingLanguage instproc testWrite { } {

        my instvar interpreter language

        $interpreter set string ""
        $language write a b c
        my assertEquals [ $interpreter set string ] "a b c"

        $interpreter set string ""
        $language ' a b c
        my assertEquals [ $interpreter set string ] "a b c"

        $interpreter set string ""
        $language ' "a b c"
        my assertEquals [ $interpreter set string ] "a b c"

        $interpreter set string ""
        $language write "a b c"
        my assertEquals [ $interpreter set string ] "a b c"
    }

    TestStringBuildingLanguage instproc testWriteEval { } {

        my instvar interpreter language

        my assertEquals [ $interpreter buildString { write a b c } ] "a b c"
        my assertEquals [ $interpreter buildString { ' a b c } ] "a b c"
        my assertEquals [ $interpreter buildString { write a b c } ] "a b c"
        my assertEquals [ $interpreter buildString { ' a b c } ] "a b c"
    }

    TestStringBuildingLanguage instproc testEvalWrite { } {

        my instvar interpreter language

        my assertEquals [ $interpreter buildString { evalWrite expr 1 + 1 } ] 2
        my assertEquals [ $interpreter buildString { expr 1 + 1 } ] ""
    }

    TestStringBuildingLanguage instproc tearDown { } {
        #add tear down code here
    }
}


