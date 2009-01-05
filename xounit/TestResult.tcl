

package require xox

namespace eval ::xounit {

    namespace import -force ::xotcl::*

    Class create TestResult -superclass ::xox::Node

    TestResult # TestResult {

        TestResult is an aggregation of smaller test results.  
        It contains all the TestPass and TestFailure objects that
        are recorded from running a test.  
    }

    TestResult # name { name of the test }
    TestResult # testedClass { the class tested }
    TestResult # testedMethod { the method tested }
    TestResult # testedObject { the object tested }

    TestResult parameter {  
        { name  "unnamed" }
        { testedClass "" }
        { testedMethod "" }
        { testedObject "" }
        { time 0  }
    }

    TestResult instproc results { } {

        return [ ::xox::removeIfNot {

            $result hasclass ::xounit::TestResult
        } result [ my nodes ] ]
    }

    TestResult # passes { 

        Returns all TestPasses that are direct children
        of this TestResult.
    }

    TestResult instproc passes { } {

        set passes ""

        foreach result [ my results ] {

            if [ $result hasclass ::xounit::TestPass ] {

                lappend passes $result
            }
        }
        return $passes
    }

    TestResult # errors { 

        Returns all TestErrors that are direct children
        of this TestResult.
    }

    TestResult instproc errors { } {

        set errors ""

        foreach result [ my results ] {

            if [ $result hasclass ::xounit::TestError ] {

                lappend errors $result

            }
        }
        return $errors
    }

    TestResult # failures { 

        Returns all TestFailures that are direct children
        of this TestResult.
    }

    TestResult instproc failures { } {

        set failures ""

        foreach result [ my results ] {

            if [ $result hasclass ::xounit::TestFailure ] {

                lappend failures $result

            }
        }
        return $failures
    }

    TestResult # deepPasses { 

        Returns all TestPasses that are in the subtree under
        this TestResult.
    }

    TestResult instproc deepPasses { } {

        set passes ""

        foreach result [ my results ] {

            if [ $result hasclass ::xounit::TestFailure ] { continue }
            if [ $result hasclass ::xounit::TestError ] { continue }
            if [ $result hasclass ::xounit::TestPass ] {

                lappend passes $result
                continue
            }
            set passes [ concat $passes [ $result deepPasses ] ]
        }
        return $passes
    }

    TestResult # deepErrors { 

        Returns all TestErrors that are in the subtree under
        this TestResult.
    }

    TestResult instproc deepErrors { } {

        set errors ""

        foreach result [ my results ] {

            if [ $result hasclass ::xounit::TestFailure ] { continue }
            if [ $result hasclass ::xounit::TestPass ] { continue }
            if [ $result hasclass ::xounit::TestError ] {

                lappend errors $result
                continue
            }
            set errors [ concat $errors [ $result deepErrors ] ]
        }
        return $errors
    }
    
    TestResult # deepFailures { 

        Returns all TestFailures that are in the subtree under
        this TestResult.
    }

    TestResult instproc deepFailures { } {

        set failures ""

        foreach result [ my results ] {

            if [ $result hasclass ::xounit::TestError ] { continue }
            if [ $result hasclass ::xounit::TestPass ] { continue }
            if [ $result hasclass ::xounit::TestFailure ] {

                lappend failures $result
                continue
            }
            set failures [ concat $failures [ $result deepFailures ] ]
        }
        return $failures
    }

    TestResult # addResult { 

        Adds a subresult to the current TestResult in the result-tree.
    }

    TestResult instproc addResult { result } {

        return [ my addAutoNameNode $result ]
    }


    TestResult instproc copyResult { result } {

        return [ my copyNewNode $result ]
    }

    TestResult instproc addNewResult { class args } {

        #my debug $args

        return [ my createAutoNamedChildInternal $class $args ]
    }

    TestResult # tests {

        returns all tests in this TestResult.
        returns all errors, failures, and passes
    }

    TestResult instproc tests {} {

        return [ concat [ my errors ] [ my failures ] [ my passes ] ]
    }

    TestResult # numberOfTests {

        returns the number of tests in this TestResult
    }

    TestResult instproc numberOfTests {} {
 
        set tests 0

        foreach result [ my results ] {

            incr tests [ $result numberOfTests ]
        }

        return $tests
    }

    TestResult # numberOfErrors {

        returns the number of errors in this TestResult
    }

    TestResult instproc numberOfErrors {} {

        set errors 0

        foreach result [ my results ] {

            incr errors [ $result numberOfErrors ]
        }

        return $errors
    }

    TestResult # numberOfFailures {

        returns the number of failures in this TestResult
    }

    TestResult instproc numberOfFailures {} {
 
        set failures 0

        foreach result [ my results ] {

            incr failures [ $result numberOfFailures ]
        }

        return $failures
    }

    TestResult # numberOfPasses {

        returns the number of passes in this TestResult
    }

    TestResult instproc numberOfPasses {} {

        set passes 0

        foreach result [ my results ] {

            incr passes [ $result numberOfPasses ]
        }

        return $passes
    }

    TestResult # passed {

        returns 1 only if there are no failures or errors
        in this TestResult. returns 0 otherwise
    }

    TestResult instproc passed {} {

        foreach result [ my results ] {

            if { ! [ $result passed ] } {

                return 0
            }
        }

        return 1
    }

    TestResult # passPercent {

        returns the percentage of tests that passed.
    }

    TestResult instproc passPercent {} {

        set total [ my numberOfTests ]
        set passes [ my numberOfPasses ]
        
        if { $total == 0 } { return 0.0 }

        return [ expr 100.0 * $passes / $total ]
    }

    TestResult instproc allResults { { root "" } } {

        set results ""

        if { "" == "$root" } {

            set root [ my findRoot ]
        }

        if { ![ $root hasclass ::xounit::TestResult ] } {

            error "$root is not a TestResult it is a [ $root info class ]"
        }

        set results $root

        foreach child [ $root results ] {

            set results [ concat $results [ my allResults $child ] ]
        }

        return $results
    }

    
    TestResult instproc getText {} {

        set formatter [ ::xounit::TestResultsTextFormatter new ]
        return [ $formatter formatResults [ self ] ]
    }

    TestResult instproc getStatus {} {

        set status passed 

        foreach result [ my results ] {

            if { "passed" == "[ $result getStatus ]" } {

                set status passed
            }
        }

        foreach result [ my results ] {

            if { "passed" != "[ $result getStatus ]" } {

                set status [ $result getStatus ]
            }
        }

        return $status
    }

    TestResult instproc getTime { } {

        my instvar time

        if { $time == 0 } { 
            my time [ clock seconds ]
        }

        return [ clock format $time ]
    }
}

