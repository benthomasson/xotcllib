# Created at Mon Feb 04 10:50:21 AM EST 2008 by bthomass

namespace eval ::simpletest {

    Class RunSimpleTest -superclass ::xotcl::Object

    RunSimpleTest # RunSimpleTest {

        Please describe the class RunSimpleTest here.
    }

    RunSimpleTest parameter {
        
    }

    RunSimpleTest @@doc init {

        Command: runSimpleTest

        Purpose: {

            To run SimpleTests in packages by loading the packages and searching for SimpleTests in those packages. This
            also runs and prints the results of the SimpleTests to the console.
        }

        Arguments: {
            args The packages to load and search for SimpleTests
        }

        Example: {

           > runSimpleTest simpletest

           TestXYZ
           Pass: TestXYZ test 

           All Passed: 1
           =================
           Tests: 1
           Errors: 0
           Failures: 0
           Passes: 1

        }
    }

    RunSimpleTest instproc init { args } {

        set packages ""

        foreach package $args {

            if { "::" == "$package" } { 
                lappend packages ::
                continue 
            }

            package require $package
            lappend packages ::${package}
        }

        puts $packages

        ::simpletest::runTests $packages
    }
}


