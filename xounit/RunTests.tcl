

namespace eval ::xounit {

    namespace import -force ::xotcl::*

    Class RunTests -superclass ::xounit::Application

    RunTests @doc RunTests {

        Application that finds and runs all unit tests
        in a package's test sub-package.

        If package is xounit then RunTests will find
        all TestCases in xounit::test and run them.
    }

    RunTests @doc packages { packages to find and run tests in }

    RunTests parameter { 
        packages
        { formatterClass ::xounit::TestResultsColorTextFormatter }
        pwd
    }
    
    RunTests @doc init { 

        Runs all tests methods in all test classes in a package or packages.

        Test classes are those classes that are subclasses of ::xounit::Test and
        located in packageName::test namespace.
    }

    RunTests @arg init args { The package (or packages) to run all test methods on all test classes.}

    RunTests @command init runTests

    RunTests @example init {

        >runTests xox xounit xoexception

        This example runs all test methods on all test classes in xox, xounit, and xoexception packages.
    }

    RunTests instproc init { args } {

        my pwd [ pwd ]

        my loadConfig

        my set packages $args
        my runApplication runTestApplication 
        my printResults
        flush stdout
        my setExitStatus 
    }

    RunTests @doc runTestApplication { 

        Main method for the RunTests Application.

        Selects tests by searching for subclasses
        of ::xounit::TestCase in package::test where
        package is specified on the command line.
    }

    RunTests instproc runTestApplication { } {

        my instvar packages 

        my results [ concat [ my results ] [ my readXmlResults ] ]

        ::xox::logger addLogClass ::xotcl::Object
        ::xox::logger setLogLevel debug

        set aRunner [ ::xounit::TestRunner new ]

        foreach package $packages {

            puts "Loaded $package [ package require $package ]"
            puts "Loaded ${package}::test [ package require ${package}::test ] "
            puts "Running ::${package}"
            $aRunner runAllTests ::${package}::test
        }

        my results [ concat [ $aRunner results ] [ my results ] ]

        cd [ my pwd ]

        my writeXmlResults [ $aRunner results ]
        flush stdout
    }
}

