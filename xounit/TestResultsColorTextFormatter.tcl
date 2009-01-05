
namespace eval ::xounit { 

Class create TestResultsColorTextFormatter -superclass { ::xounit::TestResultsTextFormatter }

TestResultsColorTextFormatter id {$Id: TestResultsColorTextFormatter.tcl,v 1.2 2007/12/03 16:35:42 bthomass Exp $}
  
TestResultsColorTextFormatter @doc TestResultsColorTextFormatter {
Please describe TestResultsColorTextFormatter here.
}
       
TestResultsColorTextFormatter parameter {
    { green "\x1B\[32;1m" }
    { red "\x1B\[31;1m" }
    { clear "\x1B\[0m" }
}

TestResultsColorTextFormatter instproc nocolor { } {

    my green ""
    my red ""
    my clear ""
}

TestResultsColorTextFormatter instproc printPass { aPass } {

        append buffer [ my green ]
        append buffer [ next ]
        append buffer [ my clear ]

        return $buffer
}

TestResultsColorTextFormatter instproc printFailure { aFailure } {

    append buffer [ my red ]
    append buffer [ next ]
    append buffer [ my clear ]

    return $buffer
}

TestResultsColorTextFormatter instproc printError { anError } {

    append buffer [ my red ]
    append buffer [ next ]
    append buffer [ my clear ]

    return $buffer
}

TestResultsColorTextFormatter instproc printResultSummary { aResult } {

    set buffer ""

    if [ $aResult passed ] {

        append buffer [ my green ]
        append buffer "All Passed: [ $aResult numberOfPasses ]\n"
        append buffer [ my clear ]

    } else {

        append buffer [ my red ]
        append buffer "Errors: [ $aResult numberOfErrors ]  "
        append buffer "Failures: [ $aResult numberOfFailures ]  "
        append buffer "Passes: [ $aResult numberOfPasses ]\n"
        append buffer [ my clear ]
    }

    return $buffer
}

TestResultsColorTextFormatter instproc testSummary { results } {

    set buffer ""

    set failures [ my numberOfFailures $results ]
    set errors [ my numberOfErrors $results ]

    if { $failures > 0 || $errors } {
        append buffer [ my red ]
    } else {
        append buffer [ my green ]
    }

    append buffer "Tests: [ my numberOfTests $results ]\n"
    append buffer "Errors: [ my numberOfErrors $results ]\n"
    append buffer "Failures: [ my numberOfFailures $results ]\n"
    append buffer "Passes: [ my numberOfPasses $results ]\n"
    append buffer [ my clear ]

    return $buffer
}

}


