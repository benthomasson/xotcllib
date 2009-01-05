::xohtml::widgets {

    @@doc TestsSummary {

        Purpose: Builds a summary for a set of test results.

        Parameter: {
            results A list of ::xounit::TestResult objects.
        }
    }

    defineWidget TestsSummary { results } { } {

        set numberOfTests 0
        foreach result $results {
            incr numberOfTests [ $result numberOfTests ]
        }

        set numberOfFailures 0
        foreach result $results {
            incr numberOfFailures [ $result numberOfFailures ]
        }

        set numberOfErrors 0
        foreach result $results {
            incr numberOfErrors [ $result numberOfErrors ]
        }

        set numberOfPasses 0
        foreach result $results {
            incr numberOfPasses [ $result numberOfPasses ]
        }
        set passed 1
        foreach result $results {
            if { ! [ $result passed ] } { set passed 0 }
        }
        set summaryClass failure
        if $passed {
            set summaryClass pass
        }
        
        h1 ' "Test Results"
        div -class $summaryClass {
            h2 ' "Test Summary"
            table {
                thead { th ' Tests 
                        th ' Errors 
                        th ' Failures 
                        th ' Passes 
                }
                tbody { 
                    tr {
                        td ' $numberOfTests 
                        td ' $numberOfErrors 
                        td ' $numberOfFailures 
                        td ' $numberOfPasses 
                    } 
                } 
            }
        }
    }

    @@doc TestsPass {

        Purpose: Formats all ::xounit::TestPass results in a list of ::xounit::TestResults trees.

        Parameter: {
            results A list of ::xounit::TestResults.
        }
    }

    defineWidget TestsPass { results } { } {
        set numberOfPasses 0
        foreach result $results {
            incr numberOfPasses [ $result numberOfPasses ]
        }
        if { $numberOfPasses == 0 } { return }
        div -class pass {
            h2 ' "Test Passes"
            table {
                thead { 
                    th ' TestCase
                    th ' "Test Method"
                    th ' Return
                }
                tbody {
                    set x 0
                    foreach result $results {
                        foreach subresult [ $result deepPasses ] {
                            if { [ $subresult passed ] } {
                                incr x
                                set class odd
                                if { $x % 2 == 0 } {
                                    set class even
                                }
                                tr -class $class { 
                                    td , $result name
                                    td , $subresult test
                                    td , $subresult return
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    @@doc TestsError {

        Purpose: Formats all ::xounit::TestError subresults in a list of ::xounit::TestResults.

        Parameter: {
            results A list of ::xounit::TestResults.
        }
    }

    defineWidget TestsError { results } { } {
        set numberOfErrors 0
        foreach result $results {
            incr numberOfErrors [ $result numberOfErrors ]
        }
        if { $numberOfErrors == 0 } { return }
        div -class failure {
            h2 ' "Test Errors"
            table {
                thead { 
                    th ' TestCase 
                        th ' "Test Method" 
                        th ' Error 
                } 
                tbody {
                    set x 0
                    foreach result $results {
                        foreach subresult [ $result deepErrors ] {
                            if { ! [ $subresult passed ] } {
                                incr x
                                set class odd
                                if { $x % 2 == 0 } {
                                    set class even
                                }
                                tr -class $class { 
                                    td , $result name
                                    td , $subresult test
                                    td pre ,, $subresult error
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    @@doc TestsFail {

        Purpose: Formats all ::xounit::TestFailure subresults in a list of ::xounit::TestResults.

        Parameter: {
            results A list of ::xounit::TestResults.
        }
    }

    defineWidget TestsFail { results } { } {
        set numberOfFailures 0
        foreach result $results {
            incr numberOfFailures [ $result numberOfFailures ]
        }
        if { $numberOfFailures == 0 } { return }
        div -class failure {
            h2 ' "Test Failures"
            table {
                thead { 
                    th ' TestCase 
                        th ' "Test Method" 
                        th ' Failure 
                } 
                tbody {
                    set x 0
                    foreach result $results {
                        foreach subresult [ $result deepFailures ] {
                            if { ! [ $subresult passed ] } {
                                incr x
                                set class odd
                                if { $x % 2 == 0 } {
                                    set class even
                                }
                                tr -class $class { 
                                    td , $result name
                                    td , $subresult test
                                    td pre ,, $subresult error
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    @@doc TestResults {

        Purpose: Formats a list of ::xounit::TestResults

        Parameter: {
            results A list of ::xounit::TestResults
        }
    }

    defineWidget TestResults { results }  { } {
        html { 
            head { 
              title ' "Test Results"
              style -type "text/css" ' {

                body {
                    font-family: Helvetica,Arial,Sans-Serif;
                }

                table {
                    margin: 0 0 1em;
                    background: #FFF;
                    border-collapse: collapse;
                }

                th, td {
                        font-weight: normal;
                        padding: .3em .7em;
                        text-align: left;
                        vertical-align: top;
                }

                .pass thead {
                    background: #9C9;
                    border-top: 2px solid #363;
                    border-bottom: 2px solid #363;
                }

                .failure thead {
                    background: #F88;
                    border-top: 2px solid #922;
                    border-bottom: 2px solid #922;
                }

                .failure .even {
                    background: #FCC;
                }

                .pass .even {
                    background: #DFD;
                }
                
            } } 
            body {

                new TestsSummary -results $results 
                new TestsError -results $results
                new TestsFail -results $results
                new TestsPass -results $results

            }
        }
    }

    @@doc RunTests {

        Purpose: This widget runs the ::xounit::RunTests application and then formats the test results for a package.

        Parameter: {
            package Run and format all the tests found in the unit tests of this package.
        }
    }


    defineWidget RunTests { package } { } {
        set results [ [ ::xounit::RunTests new $package ] results ]
        new TestResults -results $results 
    }

    @@doc RunTest {

        Purpose: This widget runs the ::xounit::RunTest application and then formats the test results for a class in a package.

        Parameter: {
            package Run and format all the tests found in the unit tests of this package.
            testclass The class to test
        }
    }

    defineWidget RunTest { package testClass } { } {
        set results [ [ ::xounit::RunTest new $package $testClass ] results ]
        new TestResults -results $results 
    }

    @@doc RunATest {

        Purpose: This widget runs the ::xounit::RunATest application and then formats the test results for a test method in a class in a package.

        Parameter: {
            package Run and format all the tests found in the unit tests of this package.
            testClass The class to test
            testMethod The test method to run
        }
    }

    defineWidget RunATest { package testClass testMethod } { } {
        set results [ [ ::xounit::RunATest new $package $testClass $testMethod ] results ]
        new TestResults -results $results 
    }

    @@doc RunSuite {

        Purpose: This widget runs the ::xounit::RunSuite application and then formats all the test results for the tests\
        in a given suite file.

        Parameter: {
            suiteFile An xounit suite file to load tests from.
        }
    }

    defineWidget RunSuite { suiteFile } { } { 
        set results [ [ ::xounit::RunSuite new $suiteFile ] results ]
        new TestResults -results $results 
    }

}
