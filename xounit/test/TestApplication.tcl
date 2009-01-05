
namespace eval ::xounit::test {

    namespace import -force ::xotcl::*

    Class TestApplication -superclass ::xounit::TestCase

    TestApplication instproc test {} {

        set test [ ::xounit::Application new ]

        $test proc someApplication { } {

        }

        $test runApplication someApplication

        my assertEquals [ llength [ $test results ] ] 0 
    }

    TestApplication instproc testFailingApplication {} {

        set test [ ::xounit::Application new ]

        $test proc someApplication { } {

            my fail fail
        }

        $test runApplication someApplication

        my assertEquals [ llength [ $test results ] ] 1 
        set result [ $test results ]
        my assertFalse [ $result passed ]
        my assertEquals [ llength [ $result results ] ] 1 
        set sub [ $result results ]
        my assertEquals [ $sub info class ] ::xounit::TestFailure
        my assertEquals [ $sub error ] fail
    }

    TestApplication instproc testErrorApplication {} {

        set test [ ::xounit::Application new ]

        $test proc someApplication { } {

           error error
        }

        $test runApplication someApplication

        my assertEquals [ llength [ $test results ] ] 1 
        set result [ $test results ]
        my assertFalse [ $result passed ]
        my assertEquals [ llength [ $result results ] ] 1 
        set sub [ $result results ]
        my assertEquals [ $sub info class ] ::xounit::TestError
        my assertEquals [ lindex [ split [ $sub error ] "\n" ] 0 ] error
    }

    TestApplication instproc testApplicationEnvironment {} {

        set test [ ::xounit::Application new ]

        set environment [  $test createNewChild ::xox::Environment ]

        $environment tclLibPath XYZ983

        my assertEquals [ $test getChild Environment ] $environment
        my assertEquals [ $test childName Environment ] $environment

        $environment loadPaths
        $environment loadPackages

        #my assertFindIn XYZ983 $::env(TCLLIBPATH)
        my assertFindIn XYZ983 $::auto_path

        catch { package require notapackage }

        return
    }

    TestApplication instproc testReadConfig {} {

        #my assertError { package present abc }

        set test [ ::xounit::Application new ]

        $test readConfig test/applicationconfig.xml

        my assertNotEquals [ $test getChild Environment ] ""

        #my assertFindIn XYZ145 $::env(TCLLIBPATH)
        my assertFindIn XYZ145 $::auto_path

        package present abc
    }

    TestApplication instproc testSaveApplication {} {

        set test [ ::xounit::Application new ]
        set environment [  $test createNewChild ::xox::Environment ]
        $environment tclLibPath XYZ999
        $test saveApplication test/savedapplication.xml

        set newTest [ ::xounit::Application new ]
        $newTest readConfig test/savedapplication.xml
        set newEnv [  $newTest getChild Environment ]

        my assertEquals [ $newEnv tclLibPath ] XYZ999
    }

    TestApplication instproc testCaptureTclLibPath {} {

        set test [ ::xounit::Application new ]
        set environment [  $test createNewChild ::xox::Environment ]
        $environment captureTclLibPath
        $test saveApplication test/savedapplication2.xml

        set ::env(TCLLIBPATH) ""

        set newTest [ ::xounit::Application new ]
        $newTest readConfig test/savedapplication2.xml
        set newEnv [  $newTest getChild Environment ]

        #my debug [ $newTest dumpTreeData ]

        my assertNotEquals $newEnv ""

        my assertListEquals $::env(TCLLIBPATH) [ $newEnv tclLibPath ]
    }

    TestApplication instproc testExitStatus { } {

        my assertNoError {

            exec tclsh test/testExitStatus
        }

        my assertError {

            exec tclsh test/testExitStatus2
        }
    }
}
