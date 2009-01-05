

namespace eval ::xounit {

    namespace import -force ::xotcl::*

    Class RunProfile -superclass ::xounit::Application

    RunProfile # RunProfile {

        RunProfile is an Application that will report the
        usage, total time, and average time spent in each
        method for all instances of a profile class.
    }

    RunProfile # packages { packages to load for unit tests }
    RunProfile # profile { class to profile }

    RunProfile parameter { 
        packages
        profile
        { formatterClass ::xounit::TestResultsColorTextFormatter }
    }

    RunProfile # init {

        Initialize the application with profile and packages from
        command line.  Run the unit tests and print results 
        for the unit tests and profile report.
    }

    RunProfile instproc init { profile args } {

        my loadConfig

        my set packages $args
        my set profile $profile
        my runApplication runTestApplication 
        my printResults
        ::xox::Profiler printReport 100
    }

    RunProfile # runTestApplication {

        Main method for RunProfile Application.

        1) Load packages.
        2) Start watching profile class.
        3) Run unit tests in packages.
        4) Save results.
    }

    RunProfile instproc runTestApplication { } {

        my instvar packages profile

        set aRunner [ ::xounit::TestRunner new ]

        foreach package $packages {

            package require "${package}"
            package require "${package}::test"
            puts "Loaded ${package}::test"
        }

        ::xox::Profiler add $profile

        foreach package $packages {

            puts "Running ::${package}"
            $aRunner runAllTests ::${package}::test
        }

        my results [ concat [ $aRunner results ] [ my results ] ]
    }
}

