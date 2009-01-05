
namespace eval xounit {

    namespace import -force ::xotcl::*

    Class create CoverageReport 

    CoverageReport instmixin add ::xounit::Assert

    CoverageReport # CoverageReport {

        CoverageReport is a collector of information
        about the coverage analysis and produces the
        formatted summary of that information
    }

    CoverageReport # passes { number of methods that are covered }
    CoverageReport # failures { number of methods that are not covered }
    
    CoverageReport parameter {
        { passes 0 }
        { failures 0 }
    }

    CoverageReport # clear {

        Clears all old information from the CoverageReport
    }

    CoverageReport instproc clear { } {

        ::xounit::Coverage clear
        my passes 0
        my failures 0
    }

    CoverageReport # start {

        Starts the recording of the CoverageReport
    }

    CoverageReport instproc start { } {

        ::xounit::Coverage start
    }

    CoverageReport # stop {

        Stops the recording of the CoverageReport
    }

    CoverageReport instproc stop { } {

        ::xounit::Coverage stop
    }

    CoverageReport # add {

        Adds a class to be watched during coverage analysis.
    }

    CoverageReport instproc add { class } {

        ::xounit::Coverage add $class
        my assertNotEquals [ lsearch [ $class info instfilter ] coverageFilter ] -1
    }

    CoverageReport # addPackage {

        Adds a package to be watched during coverage analysis.
    }

    CoverageReport instproc addPackage { package } {

        set namespace ::${package}

        puts "Searching $namespace"

        foreach class [ ::xox::ObjectGraph findAllInstances ::xotcl::Class $namespace ] {
            puts "Watching $class"
            my add $class
        }
    }

    CoverageReport # reportClass {

        Builds the report of coverage for all methods in class.
    }

    CoverageReport instproc reportClass { class } {

        if { [ string first  "::test::" $class ] != -1 } { return }
        if { "$class" == "::xounit::CoverageReport" } { return }

        foreach method [ $class info instprocs ] {

            if { ![ ::xounit::Coverage hasCoverage $class $method ] } {

                puts "Not Covered: $class $method"
                my incr failures
                continue
            }
            puts "Covered: $class $method [ ::xounit::Coverage getCoverage $class $method ]"
            my incr passes
        }
    }

    CoverageReport # reportPackage {

        Builds the report of coverage for all classes in package.
    }

    CoverageReport instproc reportPackage { package } {

        set namespace ::${package}

        foreach class [ ::xox::ObjectGraph findAllInstances ::xotcl::Class $namespace ] {

            my reportClass $class
        }
    }

    CoverageReport # reportPackages {

        Builds the report of coverage for all classes in packages.
    }

    CoverageReport instproc reportPackages { packages } {

        foreach package $packages {

            my reportPackage $package
        }
    }

    CoverageReport # reportSummary {

        Builds the report summary for all classes included in this
        CoverageReport
    }

    CoverageReport instproc reportSummary { } {

        my instvar passes failures

        set total [ expr { $passes + $failures } ]

        puts "\n\nTest Coverage Report Summary by Method"
        puts "=========================================="
        puts "Total:        $total"
        if { $total == 0 } { return }
        puts "Covered:      $passes - [ expr { floor ( 100.0 * $passes / $total ) } ]%"
        puts "Not Covered:  $failures - [ expr { ceil ( 100.0 * $failures / $total ) } ]%"
    }
}

