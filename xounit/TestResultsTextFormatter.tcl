

namespace eval xounit {

    namespace import -force ::xotcl::*

    Class create TestResultsTextFormatter 

    TestResultsTextFormatter # TestResultsTextFormatter {

        TestResultsTextFormatter is a utility class to generate
        human readable results in plan ASCII text. The input
        to the formatting methods should be a list of TestResult
        objects. 
    }

    TestResultsTextFormatter # printResults {

        Format and print a list of results to stdout.
    }

    TestResultsTextFormatter instproc printResults { results } {
        set text [my formatResults $results]
        puts $text
        flush stdout
        return $text
    }

    TestResultsTextFormatter # formatResults {

        Format a list of results and return the formatted string.
    }

    TestResultsTextFormatter instproc formatResults { results } {

        set buffer ""

        foreach result $results {

            append buffer [ my printResult $result ]
        }

        append buffer "=================\n"
        append buffer [ my testSummary $results ]

        return $buffer
    }

    TestResultsTextFormatter # testSummary {

        Format a summary of a list of TestResults.
    }

    TestResultsTextFormatter instproc testSummary { results } {

        set buffer ""

        append buffer "Tests: [ my numberOfTests $results ]\n"
        append buffer "Errors: [ my numberOfErrors $results ]\n"
        append buffer "Failures: [ my numberOfFailures $results ]\n"
        append buffer "Passes: [ my numberOfPasses $results ]\n"

        return $buffer
    }

    TestResultsTextFormatter # printResult {

        Format one TestResult and return the string.
    }

    TestResultsTextFormatter instproc printResult { aResult } {

        set buffer ""

        append buffer [ my printSubResult $aResult ]
        append buffer [ my printResultSummary $aResult ]

        return $buffer 
    }

    TestResultsTextFormatter instproc printResultSummary { aResult } {

        set buffer ""

        if [ $aResult passed ] {

            append buffer "All Passed: [ $aResult numberOfPasses ]\n"

        } else {

            append buffer "Errors: [ $aResult numberOfErrors ]  "
            append buffer "Failures: [ $aResult numberOfFailures ]  "
            append buffer "Passes: [ $aResult numberOfPasses ]\n"
        }

        return $buffer
    }

    TestResultsTextFormatter # printSubResult {

        Format a subtest result.
    }

    TestResultsTextFormatter instproc printSubResult { aResult } {

        set buffer ""
        
        append buffer "[ $aResult name ]\n"

        foreach result [ $aResult results ] {

            if [ $result hasclass ::xounit::TestPass ] {

                append buffer [ my printPass $result ]
                continue
            }

            if [ $result hasclass ::xounit::TestFailure ] {

                append buffer [ my printFailure $result ]
                continue
            }

            if [ $result hasclass ::xounit::TestError ] {

                append buffer [ my printError $result ]
                continue
            }

            append buffer [ my printSubResult $result  ]
        }

        return $buffer
    }

    TestResultsTextFormatter # printPass {

        Format a TestPass
    }

    TestResultsTextFormatter instproc printPass { aPass } {

        append buffer "Pass: [ $aPass name ] [$aPass test] [$aPass return]\n\n"
        return $buffer
    }

    TestResultsTextFormatter # printFailure {

        Format a TestFailure
    }

    TestResultsTextFormatter instproc printFailure { aFailure } {

        append buffer "Failure: [ $aFailure name ] [$aFailure test]\n[$aFailure error]\n\n"

        return $buffer
    }

    TestResultsTextFormatter # printError {

        Format a TestError
    }

    TestResultsTextFormatter instproc printError { anError } {

        append buffer "Error: [ $anError name ] [$anError test]\n[$anError error]\n\n"

        return $buffer
    }

    TestResultsTextFormatter # numberOfTests {

        Count the total number of tests run.
    }

    TestResultsTextFormatter instproc numberOfTests { results } {

        set number 0

        foreach result $results {

            incr number [ $result numberOfTests ]
        }

        return $number

    }

    TestResultsTextFormatter # numberOfErrors {

        Count the total number of test errors.
    }

    TestResultsTextFormatter instproc numberOfErrors { results } {

        set number 0

        foreach result $results {

            incr number [ $result numberOfErrors ]
        }

        return $number
    }

    TestResultsTextFormatter # numberOfFailures {

        Count the total number of test failures.
    }

    TestResultsTextFormatter instproc numberOfFailures { results } {

        set number 0

        foreach result $results {

            incr number [ $result numberOfFailures ]
        }

        return $number
    }

    TestResultsTextFormatter # resultsPass {

        Count the number of results that passed.
    }

    TestResultsTextFormatter instproc resultsPass { results } {

        set number 0

        foreach result $results {

            if [ $result passed ] { incr number }
        }

        return $number

    }

    TestResultsTextFormatter # numberOfPasses {

        Count the total number of tests that passed.
    }
    
    TestResultsTextFormatter instproc numberOfPasses { results } {

        set number 0

        foreach result $results {

            incr number [ $result numberOfPasses ]

        }

        return $number

    }
    
}
