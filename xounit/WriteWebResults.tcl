# Created at Thu May 31 20:37:34 EDT 2007 by bthomass


namespace eval ::xounit {

    namespace import -force ::xotcl::*

    Class WriteWebResults -superclass ::xounit::Application 

    WriteWebResults @doc WriteWebResults {

    }

    WriteWebResults @doc suite { suite file to load tests from }

    WriteWebResults parameter { 
        suite
        resultsFile
        { formatterClass ::xounit::TestResultsColorTextFormatter }
        { updateResults 1 }
    }
    
    WriteWebResults instproc init { suite resultsFile } {

        my loadConfig

        my set suite $suite
        my set resultsFile $resultsFile 
        my runApplication writeWebResults 
        my printResults
    }

    WriteWebResults instproc writeWebResults { } {

        my instvar suite 

        set pwd [ pwd ]

        set testSuite [ ::xounit::TestSuite new ]
        set reader [ ::xox::XmlNodeReader new ]
        $reader buildTree $testSuite $suite

        set results [ my readXmlResults ]

        set formatter [ [ my formatterClass ] new ]
        $formatter printResults $results

        $testSuite writeWebResults $results

        #my results [ concat $results [ my results ] ]
    }
}


