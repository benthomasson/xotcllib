# Created at Mon Feb 04 09:46:26 AM EST 2008 by bthomass

package require XOTcl
package require xox
package require xodocument

::xox::Package create ::simpletest
::simpletest executables {
    runSimpleTest
}
::simpletest requires {
    xodocument
    xounit
    xodsl
    xoshell
}

::simpletest @@doc test {

    Purpose: {

        Declares a new SimpleTest with a name and a script body.
    }

    Arguments: {
        name The name of the SimpleTest that will be used in results reporting.
        script The body of the SimpleTest. SimpleTest commands may be used inside this script. 
    }

    Example: {

        ::simpletest::test YourTest {

            assertEquals [ expr 1 + 1 ] 2
        }
    }

    Returns: {
        The handle of the SimpleTest object created.  *Return for advanced use only*
    }
}

proc ::simpletest::test { name script } {

    ::simpletest loadClass ::simpletest::SimpleTestCaseClass

    set package [ uplevel namespace current ]

    if { "::" == "$package" } {

        set package ""
    }

    return [ ::simpletest::SimpleTestCaseClass create ${package}::${name} -name $name -script $script ]
}

::simpletest @@doc runTests {

    Purpose: {

        Runs and reports all SimpleTests defined in a set of specified namespaces or all namespaces if none specified.
    }

    Arguments: {
        namespaces (OPTIONAL) A list of namespaces to search for SimpleTests.  Defaults to all namespaces.
    }

    Example: {

        ::simpletest::runTests ::simpletest
    }
}

proc ::simpletest::runTests { { namespaces "::" } } {

    ::simpletest loadClass ::simpletest::SimpleTestCaseClass

    set tests ""

    set results ""

    puts "Packages: $namespaces"

    foreach package $namespaces {

        set tests [ concat $tests [ ::simpletest::SimpleTestCaseClass info instances "${package}*" ] ]
    }

    set tests [ lsort -unique $tests ]

    puts "Tests: $tests"

    foreach test $tests {

        set instance [ $test new ]

        set results [ concat $results [ $instance runAlone ] ]
    }

    [ ::xounit::TestResultsColorTextFormatter new ] printResults $results

    return $results
}


::simpletest @@doc runTest {

    Purpose: {

        Runs and reports a single simple test given by the className.
    }

    Arguments: {
        className The fully qualified class name
    }

    Example: {

        ::simpletest::runTest ::TestX
    }
}

proc ::simpletest::runTest { className } {

    set tests ""

    set results ""

    set package [ ::xox::Package getPackageFromClass $className ]

    puts "Package: $package"

    if { "::" != "$package" && "" != "$package" } {

        package require $package
    }

    puts "Test: $className"

    set instance [ $className new ]

    set results [ concat $results [ $instance runAlone ] ]

    [ ::xounit::TestResultsColorTextFormatter new ] printResults $results

    return $results
}

::simpletest loadAll

