

namespace eval ::xounit {

    namespace import -force ::xotcl::*

    Class RunTest -superclass ::xounit::Application

    RunTest @doc RunTest {

        RunTest is an Application that will run individual tests
        within a certain package.
    }

    RunTest @doc package { package to load }
    RunTest @doc tests { tests to run }

    RunTest parameter { 
        package
        tests
        { formatterClass ::xounit::TestResultsColorTextFormatter }
        pwd
    }

    RunTest @doc init { 

        Runs all test methods on a single test class or a list of classes in a single package.

        Test methods are those methods that start with the prefix test.

        Test classes are thos classe that are subclasses of ::xounit::Test and are located
        in the packageName::test namespace.
    }

    RunTest @command init runTest

    RunTest @arg init package {The package where the test class resides.}
    RunTest @arg init args {The name of the test class (or classes) without the package prefix ie. TestXYZ not ::abc::test::TestXYZ.}

    RunTest @example init {

        > runTest xounit TestAssert

        This example runs all the test methods on TestAssert class in xounit package.
    }

    RunTest instproc init { package args } {

        my pwd [ pwd ]

        my loadConfig
        my set tests $args
        my set package $package
        my runApplication runTestApplication 
        my printResults
        flush stdout
        my setExitStatus 
    }

    RunTest @doc runTestApplication { 

        Main method for the RunTest Application.
        Runs the selected tests from the selected package
        and records the results in a list.
    }

    RunTest instproc runTestApplication { } {

        my instvar package tests

        my results [ concat [ my results ] [ my readXmlResults ] ]

        set aRunner [ ::xounit::TestRunner new ]

        puts "Loaded $package [ package require $package ]"
        puts "Loaded ${package}::test [ package require ${package}::test ] "

        foreach test $tests {

            my lappend results [ $aRunner runATest ${package}::test::${test} ]
        }

        cd [ my pwd ]

        my writeXmlResults [ my results ]
        flush stdout
    }
}

