# Created at Fri Oct 17 15:54:09 EDT 2008 by ben

namespace eval ::xodsl::test {

    Class TestSampleLanguage -superclass ::xounit::TestCase

    TestSampleLanguage parameter {

    }

    TestSampleLanguage instproc setUp { } {

        my instvar language environment

        set language [ ::xodsl::SampleLanguage newLanguage ]
        set environment [ $language set environment ]
    }

    TestSampleLanguage instproc testSetup { } {

        my instvar language environment

        my assertObject $language
        my assertObject $environment
    }

    TestSampleLanguage instproc testForwarding { } {

        my instvar language environment

        $language hello
        $environment hello

        my assertEquals [ $language hi ] "a return value"
        my assertEquals [ $environment hi ] "a return value"
    }

    TestSampleLanguage instproc testEnvironmentEval { } {

        my instvar language environment

        $environment eval {
            hello
        }

        my assertEquals [ $environment eval {
            hi
        } ] "a return value"
    }

    TestSampleLanguage instproc testEnvironmentSubst { } {

        my instvar language environment

        $environment set a 5

        my assertEquals [ $environment eval {
            subst { ![ hi ]! $a }
        } ] " !a return value! 5 "
    }

    TestSampleLanguage instproc testError { } {

        my instvar language environment

        my assertEquals [ my assertError {
            $language throwError
        } ] "error thrown"

        my assertEquals [ my assertError {
            $environment throwError
        } ] "error thrown"

        my assertEquals [ my assertError {
            $environment eval {
                throwError
            }
        } ] "error thrown"
    }

    TestSampleLanguage instproc testLanguageVar { } {

        my instvar language environment

        my assertFalse [ $environment exists local ]
        my assertFalse [ $language exists local ]

        $environment eval {
            useLanguageLocalVar 
        }

        my assertFalse [ $environment exists local ]
        my assertTrue [ $language exists local ]
        my assertEquals [ $language set local ] value
    }

    TestSampleLanguage instproc testEnvironmentVar { } {

        my instvar language environment

        my assertFalse [ $environment exists local ]
        my assertFalse [ $language exists local ]

        $environment eval {
            useEnvironmentVar 
        }

        my assertTrue [ $environment exists local ]
        my assertFalse [ $language exists local ]
        my assertEquals [ $environment set local ] value
    }

    TestSampleLanguage instproc testIf { } {

        my instvar language environment

        $environment eval {

            if { 1 } {
                useEnvironmentVar
            }
        }

        my assertEquals [ $environment set local ] value
    }

    TestSampleLanguage instproc testUnknown { } {

        my instvar language environment

        my assertError {

            $environment eval {
                notaCommandXXCVDFEWR
            }

        }
    }

    TestSampleLanguage instproc testReturn { } {

        my instvar language environment

        catch {
            set return [ $environment eval {
                return 5
            } ]
        }

        my assertFalse [ info exists return ] 
    }

    TestSampleLanguage instproc testPublishCommands { } {

        namespace eval ::xodsl::test::testPublishCommands {

        }

        set language [ ::xodsl::SampleLanguage newLanguage ]
        ::xodsl::SampleLanguage publishCommandsToNamespace $language ::xodsl::test::testPublishCommands 

        ::xodsl::test::testPublishCommands::hello
        my assertEquals [ ::xodsl::test::testPublishCommands::hi ] "a return value"
        my assertEquals [ ::xodsl::test::testPublishCommands::<do3> 3 ] 4
        my assertEquals [ ::xodsl::test::testPublishCommands::xyz 1 2 3 ] 6
    }

    TestSampleLanguage instproc testPublishLanugage { } {

        namespace eval ::xodsl::test::testPublishLanguage {

        }

        puts [ info level ]

        ::xodsl::SampleLanguage publishLanguage #[ info level ] ::xodsl::test::testPublishLanguage 

        ::xodsl::test::testPublishLanguage::hello
        my assertEquals [ ::xodsl::test::testPublishLanguage::hi ] "a return value"
        my assertEquals [ ::xodsl::test::testPublishLanguage::<do3> 3 ] 4
        my assertEquals [ ::xodsl::test::testPublishLanguage::xyz 1 2 3 ] 6

        my assertEquals [ ::xodsl::test::testPublishLanguage::<do> ] 5
        my assert [ info exists a ]
        my assertEquals $a 5

        my assertEquals [ ::xodsl::test::testPublishLanguage::<do2> ] 2
        my assert [ info exists a ]
        my assertEquals $a 2
    }

    TestSampleLanguage instproc tearDown { } {

        #add tear down code here
    }
}


