

namespace eval ::xounit {

    namespace import -force ::xotcl::*

    Class RunCoverage -superclass ::xounit::Application

    RunCoverage # RunCoverage {

        RunCoverage is an application that reports
        the unit testing coverage for all methods
        in all classes in a set of packages.
    }

    RunCoverage # packages { the packages to report }

    RunCoverage parameter { 
        packages
    }

    RunCoverage # init  { 

        Initialize and run the application using packages
        supplied by the command line.
    }

    RunCoverage instproc init { args } {

        my loadConfig

        my set packages $args
        my runApplication runTestApplication 
    }

    RunCoverage # runTestApplication  { 

        The main method of the application.
        Loads packages.  Adds classes to watch list and
        enables coverageFilter.  Runs unit tests. Creates
        CoverageReport and reports the coverage by the
        unit tests.
    }

    RunCoverage instproc runTestApplication { } {

        my instvar packages

        set aRunner [ ::xounit::TestRunner new ]

        set reporter [ ::xounit::CoverageReport new ]
        $reporter clear
        $reporter start

        foreach package $packages {

            package require "${package}"
            package require "${package}::test"
            puts "Loaded ${package}::test"
            $reporter addPackage ${package}
        }

        foreach package $packages {

            puts "Running ::${package}"
            $aRunner runAllTests ::${package}::test
        }

        my results [ concat [ $aRunner results ] [ my results ] ]
        my printResults
        $reporter reportPackages $packages
        $reporter reportSummary 
    }
}

