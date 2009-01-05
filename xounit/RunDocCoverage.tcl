

namespace eval ::xounit {

    namespace import -force ::xotcl::*

    Class RunDocCoverage -superclass ::xounit::Application

    RunDocCoverage # RunDocCoverage {

        An application that reports the documentation
        coverage for all methods, parameters, and classes
        in a set of packages.
    }

    RunDocCoverage # packages { packages to report on }
    RunDocCoverage # prefixes { limit the documentation report to methods that start with these prefixes }

    RunDocCoverage parameter { 
        packages
        prefixes
    }

    RunDocCoverage # init { 

        Initializes and runs the application with the
        list of packages provided on the command line.
    }

    RunDocCoverage instproc init { args } {

        my loadConfig

        my set packages $args
        my runApplication runTestApplication 
    }

    RunDocCoverage # runTestApplication { 

        Main method of the RunDocCoverage application.
        Loads packages. Uses introspection to find
        all classes, methods, and parameters that
        do or do not have documentation.
    }

    RunDocCoverage instproc runTestApplication { } {

        my instvar packages prefixes

        set aRunner [ ::xounit::TestRunner new ]

        set reporter [ ::xounit::DocumentationCoverageReport new ]
        $reporter clear
        if [ my exists prefixes ] {
            $reporter prefixes $prefixes
        }
        foreach package $packages {

            package require "${package}"
            puts "Loaded ${package}"
        }
        $reporter reportPackages $packages
        $reporter reportSummary 
    }
}

