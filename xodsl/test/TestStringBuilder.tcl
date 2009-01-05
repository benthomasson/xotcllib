# Created at Sat Oct 18 14:53:32 EDT 2008 by ben

namespace eval ::xodsl::test {

    Class TestStringBuilder -superclass ::xounit::TestCase

    TestStringBuilder parameter {

    }

    TestStringBuilder instproc setUp { } {

        my instvar builder language environment

        set language [ ::xodsl::StringBuildingLanguage newLanguage ]
        set environment [ $language set environment ]
        set builder [ ::xodsl::StringBuilder new -language $language -environment $environment ]
    }

    TestStringBuilder instproc test { } {

        my instvar builder language environment

        my assertEquals [ $builder buildString { } ] ""

        my assertEquals [ $builder buildString {
            write hi
        } ]  hi

        my assertEquals [ $builder buildString {
            write hi
            ' hi
        } ]  hihi
    }

    TestStringBuilder instproc tearDown { } {

        #add tear down code here
    }
}


