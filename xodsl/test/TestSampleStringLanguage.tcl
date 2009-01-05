# Created at Sat Oct 18 18:19:52 EDT 2008 by ben

namespace eval ::xodsl::test {

    Class TestSampleStringLanguage -superclass ::xounit::TestCase

    TestSampleStringLanguage parameter {

    }

    TestSampleStringLanguage instproc setUp { } {

        my instvar language environment collector

        set collector [ Object new -set string "" ]
        set language [ ::xodsl::SampleStringLanguage newLanguage -collector $collector ]
        set environment [ $language set environment ]
    }

    TestSampleStringLanguage instproc testSetup { } {

        my instvar language environment collector

        my assertEquals [ $language set environment ] $environment
        my assertEquals [ $language set collector ] $collector
        my assertEquals [ $collector set string ] ""
    }

    TestSampleStringLanguage instproc testHello { } {

        my instvar language environment collector

        $language installFilter

        $environment eval {
            hello
            puts hi
        }

        $language removeFilter

        my assertEquals [ $collector set string ] hello
    }

    TestSampleStringLanguage instproc testEvaluateStringScript { } {

        my instvar language environment collector

        $language evaluateStringScript {
            hello
            puts hi
        }

        my assertEquals [ $collector set string ] hello
    }

    TestSampleStringLanguage instproc testEvaluateStringScriptSubst { } {

        my instvar language environment collector

        $language evaluateStringScript {
            hello
            mysubst {howdy}
            mysubst {
                [ howdy ]
            }
        }

        my assertEqualsByLine [ $collector set string ] {hellohowdy
        hi there}
    }

    TestSampleStringLanguage instproc testEvaluateInternalStringScript { } {

        my instvar language environment collector

        $language evaluateStringScript {
            h1 { hello }
        }

        my assertEquals [ $collector set string ] <h1>hello</h1>
    }

    TestSampleStringLanguage instproc testEvaluateInternalStringScriptRecursive { } {

        my instvar language environment collector

        $language evaluateStringScript {
            h1 { h1 { h1 { hello } } }
        }

        my assertEquals [ $collector set string ] <h1><h1><h1>hello</h1></h1></h1>
    }

    TestSampleStringLanguage instproc tearDown { } {
        #add tear down code here
    }
}


