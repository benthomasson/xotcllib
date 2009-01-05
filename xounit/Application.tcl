

namespace eval ::xounit {

    namespace import -force ::xotcl::*

    Class Application -superclass ::xounit::TestCase

    Application # Application {

        Application is a base class for all executable
        applications.  It provides robust application
        execution by running inside a TestCase. Thus
        all asserts and subtests can be called as if
        in a unit test from within this application.

        That is - if you unit tests work then this
        application will work too.
    }

    Application # name { the name of the Application }
    Application # results { failures, errors, and passes from Application execution }
    Application # formatterClass { test results formatter used to display results of application }

    Application parameter {

        { name Application }
        { results "" }
        { formatterClass ::xounit::TestResultsTextFormatter }
        config
        { exitStatus 0 }
        { writeResults 0 }
        { updateResults 0 }
        { resultsFile testResults.xml  }
    }

    Application # printResults { 

        Print results collected from executing this Application.
    }
    
    Application instproc printResults { } {

        my instvar results

        set formatter [ [ my formatterClass ] new ]

        $formatter printResults $results
    }
   

    Application instproc printFailures { } {

        my instvar results

        set failed 0

        foreach result $results {

            if [ $result passed ] { continue }

            set failed 1
        }

        if { !$failed } return 

        set formatter [ [ my formatterClass ] new ]

        $formatter printResults $results
    }
    
    Application # runApplication { 

        Run the main method of the application from
        within the robust test runner of TestCase.
    }

    Application instproc runApplication { method } {

        set result [ ::xounit::TestResult new -name [ my name ] ]
        my runTest $result $method 
        if [ $result passed ] { return }
        my lappend results $result
    }

    Application instproc runApplicationAndReport { method } {

        my runApplication $method
        my printResults [ my results ]
    }

    Application instproc loadConfig { } {

        if [ my exists config ] {

            my readConfig [ my config ]
        }
    }

    Application instproc readConfig { file } {

        set reader [ ::xox::XmlNodeReader new ]

        $reader buildTree [ self ] $file
    }

    Application instproc saveApplication { file } {

        set writer [ ::xox::SimpleXmlNodeWriter new ]
        
        $writer writeXmlFile [ self ] $file
    }

    Application instproc setExitStatus { } {

        foreach result [ my results ] {
            if { ! [ $result passed ] } { 
                my exitStatus 1
            }
        }
    }

    Application instproc readXmlResults { } {

        my instvar resultsFile

        if { [ my updateResults ] && [ file exists $resultsFile ] } { 

            set root [ ::xounit::TestResult new -name root ]

            set reader [ ::xox::XmlNodeReader new ]

            $reader buildTree $root $resultsFile

            return [ $root results ]

        } else {

            return ""
        }
    }

    Application instproc writeXmlResults { results } {

        my instvar resultsFile

        if { [ my writeResults ] || [ my updateResults ] } { 

            set root [ ::xounit::TestResult new -name root ]

            foreach result $results {

                $root copyNewNode $result
            }

            set writer [ ::xox::SimpleXmlNodeWriter new ]

            set e ""
            catch { $writer writeXmlFile $root $resultsFile }
            puts $e
        }
    }
}

