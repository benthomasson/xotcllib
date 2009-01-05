# Created at Fri Oct 17 03:28:28 PM EDT 2008 by bthomass

namespace eval ::xodsl::test {

    Class TestLanguageClass -superclass ::xounit::TestCase

    TestLanguageClass parameter {

    }

    TestLanguageClass instproc setUp { } {

        #add set up code here
    }

    TestLanguageClass instproc test { } {

        set language [ ::xodsl::Language newLanguage ]

        my assertObject $language

        set environment [ $language set environment ]

        my assertObject $environment
    }

    TestLanguageClass instproc tearDown { } {

        #add tear down code here
    }
}


