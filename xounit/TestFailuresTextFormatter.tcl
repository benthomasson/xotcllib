

namespace eval xounit {

    namespace import -force ::xotcl::*

    Class create TestFailuresTextFormatter \
        -superclass ::xounit::TestResultsTextFormatter

    TestFailuresTextFormatter # TestFailuresTextFormatter {

        Format test failures and errors for display in text.
    }

    TestFailuresTextFormatter instproc printResult { aResult } {

        set buffer ""

        if { [ $aResult passed ]} { return }

        append buffer "Test Results: [ $aResult name ]\n"

        foreach error [ $aResult errors ] {

            append buffer [ my printError $error ]
        }

        foreach failure [ $aResult failures ] {

            append buffer [ my printFailure $failure ]
        }

        #append buffer "Errors : [ $aResult numberOfErrors ]\n"
        #append buffer "Failures : [ $aResult numberOfFailures ]\n"

        return $buffer

    }

    TestFailuresTextFormatter instproc printFailure { aFailure } {

        return "Failure: [ $aFailure name ] [$aFailure test]
[$aFailure error]\n\n"
    }

    TestFailuresTextFormatter instproc printError { anError } {

        return "Error: [ $anError name ] [$anError test]
[$anError error]\n\n"
    }

    TestFailuresTextFormatter instproc numberOfTests { results } {

        set number 0

        foreach result $results {

            incr number [ $result numberOfTests ]
        }

        return $number

    }

    TestFailuresTextFormatter instproc numberOfErrors { results } {

        set number 0

        foreach result $results {

            incr number [ $result numberOfErrors ]
        }

        return $number
    }

    TestFailuresTextFormatter instproc numberOfFailures { results } {

        set number 0

        foreach result $results {

            incr number [ $result numberOfFailures ]
        }

        return $number
    }

    TestFailuresTextFormatter instproc numberOfPasses { results } {

        set number 0

        foreach result $results {

            incr number [ $result numberOfPasses ]

        }

        return $number

    }
}

