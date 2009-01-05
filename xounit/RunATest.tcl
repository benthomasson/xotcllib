

namespace eval ::xounit {

    Class RunATest -superclass ::xounit::Application

    RunATest @doc RunATest {

        RunATest is an Application that will a single test method
        on one test class in a package.
    }

    RunATest @doc package { package to load }
    RunATest @doc test { test to run }
    RunATest @doc method { method to run }

    RunATest parameter { 
        package
        test
        method
        { formatterClass ::xounit::TestResultsColorTextFormatter }
        pwd
    }

    RunATest @doc init { 

        Runs a single test method on a single test class in a package.

        A test method is a method that has the prefix "test".

        A test class is a subclass of ::xounit::Test and is located in packageName::test namespace.
    }

    RunATest @command init runATest

    RunATest @arg init package { The package where the test class is located.}
    RunATest @arg init test { The name of the test class without the package prefix eg. TestABC }
    RunATest @arg init method { The name of the test method to run }

    RunATest @example init {

      > runATest xounit TestAssert testAssertExistsValue

      This example runs testAssertExistsValue method on TestAssert class in xounit package.
    }

    RunATest instproc init { package test method } {

        my pwd [ pwd ]

        my loadConfig
        my set test $test
        my set method $method
        my set package $package
        my runApplication runTestApplication 
        my printResults
        my setExitStatus 
    }

    RunATest @doc runTestApplication { 

        Main method for the RunATest Application.
        Runs the selected tests from the selected package
        and records the results in a list.
    }

    RunATest instproc runTestApplication { } {

        my instvar package test method

        puts "Loaded $package [ package require $package ]"
        puts "Loaded ${package}::test [ package require ${package}::test ] "

        my results [ concat [ my results ] [ my readXmlResults ] ]

        set instance [ ${package}::test::${test} new ]

        set result [ $instance newResult ]

        cd [ $package packagePath ]

        $instance runTest $result $method

        my lappend results $result

        cd [ pwd ]

        my writeXmlResults [ my results ]
    }
}

