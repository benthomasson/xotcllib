# Created at Thu May 31 20:37:34 EDT 2007 by bthomass


namespace eval ::xounit {

    namespace import -force ::xotcl::*

    Class RunSuiteContinuous -superclass ::xounit::Application 
    
    RunSuiteContinuous instmixin add ::xox::NotGarbageCollectable                       

    RunSuiteContinuous # RunSuiteContinuous {

    }

    RunSuiteContinuous # suite { suite file to load tests from }

    RunSuiteContinuous parameter { 
        suite
        times
        delay
    }
    
    RunSuiteContinuous # init { 

    }

    RunSuiteContinuous instproc init { suiteFile args } {

        my loadConfig

        my suite $suiteFile
        my runTestApplication 
        #my printResults
    }

    RunSuiteContinuous # done {

        Is this test suite completed?
    }

    RunSuiteContinuous instproc done { } {

        if { [ my times ] == 0 } {
            return 1
        }

        return 0
    }

    RunSuiteContinuous # sleep {

        Wait for delay minutes.
    }

    RunSuiteContinuous instproc sleep { } {

        after [ expr {  [ my delay ] * 1000 * 60 } ]
    }

    RunSuiteContinuous # runTestApplication { 

        Main method for the RunSuiteContinuous Application.
    }

    RunSuiteContinuous instproc runTestApplication { } {

        my instvar suite otherArgs

        set testSuite [ ::xounit::TestSuiteContinuous new ]
        set reader [ ::xox::XmlNodeReader new -callInit 1 ]
        $reader buildTree $testSuite $suite

        my times [ $testSuite times ]
        my delay [ $testSuite delay ]
        set pwd [ pwd ]

        while { ![ my done ] } {

            my incr times -1

            cd $pwd

            set testSuite [ ::xounit::TestSuiteContinuous new ]
            set reader [ ::xox::XmlNodeReader new ]
            $reader buildTree $testSuite $suite

            my debug [[ ::xox::XmlNodeWriter new ] generateXml $testSuite ]

            $testSuite runSuite

            $testSuite writeWebResults [ $testSuite results ]

            if { ! [ my done ] } {
                $testSuite reloadPackages
                $testSuite closeFileChannels
                ::xox::GarbageCollector destroyAllObjects
                my sleep
            }
        }
    }
}


