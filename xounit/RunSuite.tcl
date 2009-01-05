# Created at Thu May 31 20:37:34 EDT 2007 by bthomass


namespace eval ::xounit {

    namespace import -force ::xotcl::*

    Class RunSuite -superclass ::xounit::Application 

    RunSuite @doc RunSuite {

    }

    RunSuite @doc suite { suite file to load tests from }

    RunSuite parameter { 
        suite
        { formatterClass ::xounit::TestResultsColorTextFormatter }
    }
    
    RunSuite @doc init { 

        Runs all test methods on all test classes in suite XML file.

        Suite files are built with the makeSuite or makeMultiSuite commands.
    }

    RunSuite @command init runSuite

    RunSuite @arg init suite { The suite XML file to load and run tests from. }

    RunSuite @example init {

       > runSuite XOTCLLIB.xml

       This runs all test methods on all test classes declared in the XOTCLLIB.xml suite file
    }

    RunSuite instproc init { suite } {

        my loadConfig

        my set suite $suite
        my runApplication runTestApplication 
        my printResults
        my setExitStatus 
    }

    RunSuite @doc runTestApplication { 

        Main method for the RunSuite Application.
    }

    RunSuite instproc runTestApplication { } {

        my instvar suite testSuite

        set pwd [ pwd ]

        set testSuite [ ::xounit::TestSuite new ]
        set reader [ ::xox::XmlNodeReader new -callInit 1 ]
        $reader buildTree $testSuite $suite

        #my debug [[ ::xox::XmlNodeWriter new ] generateXml $testSuite ]

        $testSuite runSuite

        set root [ ::xounit::TestResult new -name [ $testSuite name ] ]

        foreach result [ $testSuite results ] {

            $root copyNewNode $result
        }

        set writer [ ::xox::SimpleXmlNodeWriter new ]

        cd $pwd

        set e ""
        catch { $writer writeXmlFile $root testResults.xml }
        puts $e

        set e ""
        catch { $testSuite writeWebResults [ $testSuite results ] } e
        puts $e

        my results [ concat [ $testSuite results ] [ my results ] ]
    }
}


