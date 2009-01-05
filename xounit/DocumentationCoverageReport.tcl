

namespace eval xounit {

    namespace import -force ::xotcl::*

    Class create DocumentationCoverageReport -superclass ::xounit::CoverageReport

    DocumentationCoverageReport # prefixes { Prefixes of methods used to limit the documentation coverage report }

    DocumentationCoverageReport parameter {
        prefixes
    }

    DocumentationCoverageReport # DocumentationCoverageReport {

        Reports the documentation coverage for all methods,
        parameters and classes in a package.

    }

    DocumentationCoverageReport instproc clear { } {

        my passes 0
        my failures 0
    }

    DocumentationCoverageReport instproc start { } {

    }

    DocumentationCoverageReport instproc stop { } {

    }
    
    DocumentationCoverageReport instproc add { class } {

    }

    DocumentationCoverageReport instproc addPackage { package } {

    }

    DocumentationCoverageReport instproc reportClass { class } {

        if { [ string first  "::test::" $class ] != -1 } { return }

        if { [ my checkClassPrefix $class ] } { 
        if {![ $class exists #([ namespace tail $class ]) ]} {

                puts "Not Covered: $class"
                my incr failures
        } else {
            puts "Covered: $class"
            my incr passes
        }
        }
         

        foreach method [ concat [ $class info instprocs ] [ $class info procs ] [ $class info parameter ] ] {

            set method [ lindex $method 0 ]
            if { ! [ my checkMethodPrefix $method ] } { continue }
            set currentClass $class
            set found 0

            while { "$currentClass" != "" } {
                
                if {[ $currentClass exists #($method) ]} {
                    set found 1
                    puts "Covered: $class $method"
                    my incr passes
                    break
                }

                set currentClass [ lindex [ $currentClass info superclass ] 0 ]
            }

            if { ! $found } {

                puts "Not Covered: $class $method"
                my incr failures
                continue
            }
        }
    }

    DocumentationCoverageReport # checkClassPrefix {

        Checks that a Class matches a prefix listed in prefixes if
        prefixes were specified.
    }

    DocumentationCoverageReport instproc checkClassPrefix { class } {

        my instvar prefixes

        if { ! [ my exists prefixes ] } { return 1 }

        foreach prefix $prefixes {

            if { [ string first $prefix [ namespace tail $class ] ] == 0 } { return 1 }
        }

        return 0
    }

    DocumentationCoverageReport # checkMethodPrefix {

        Checks that the method matches a prefix listed in prefixes if 
        prefixes were specified.
    }

    DocumentationCoverageReport instproc checkMethodPrefix { method } {

        my instvar prefixes

        if { ! [ my exists prefixes ] } { return 1 }

        foreach prefix $prefixes {

            if { [ string first $prefix $method ] == 0 } { return 1 }
        }

        return 0
    }

    DocumentationCoverageReport instproc reportSummary { } {

        my instvar passes failures

        set total [ expr { $passes + $failures } ]

        puts "\n\nDocumentation Coverage Report Summary by Method"
        puts "=========================================="
        puts "Total:        $total"
        if { $total == 0 } { return }
        puts "Covered:      $passes - [ expr { floor ( 100.0 * $passes / $total ) } ]%"
        puts "Not Covered:  $failures - [ expr { ceil ( 100.0 * $failures / $total ) } ]%"
        flush stdout
    }
}

