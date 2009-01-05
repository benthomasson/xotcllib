# Created at Mon Jun 04 16:07:43 EDT 2007 by bthomass


namespace eval ::xounit {

    namespace import -force ::xotcl::*

    Class PrintResults -superclass ::xounit::Application

    PrintResults # PrintResults {

        Print results is an application that loads test results
        from testResults.xml and prints them in human readable 
        format.
    }

    PrintResults # suite { The suite file used to create the results }
    PrintResults # results { The test results file to load}

    PrintResults parameter {
        { suite suite.xml }
        { results testResults.xml }
        { formatterClass ::xounit::TestResultsColorTextFormatter }
    }

    PrintResults # init {

        Print the results to the screen from a testResults.xml file.

        This loads the testResults.xml file with XmlNodeReader and
        then prints the results with TestResultsTextFormatter.

        Optionally the suite.xml file is loaded, but it doesnt really
        matter if it loads or not.  
    }

    PrintResults instproc init { { cmdResults "" } } {

        my instvar suite results

        if { "$cmdResults" != "" } {

            my results $cmdResults
        }

        my loadConfig

        set reader [ ::xox::XmlNodeReader new ]
        set formatter [ [ my formatterClass ] new ]

        set testSuite [ ::xounit::TestSuite new ]

        catch { 

            $reader buildTree $testSuite $suite 
            $reader lappend externalRootNodes $testSuite
        }

        if { ! [ file exists $results ] } {

            puts "Cannot find results file: $results"
            return
        }

        set root [ ::xounit::TestResult new -name root ]

        $reader buildTree $root $results

        $formatter printResults [ $root results ]
    }

}


