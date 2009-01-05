
namespace eval xounit {

    ::xotcl::Class create TestResultsEmailFormatter -superclass ::xounit::TestResultsTextFormatter

    TestResultsEmailFormatter # TestResultsEmailFormatter {

        Format test results for display in an email message.
    }

    TestResultsEmailFormatter instproc formatResults { results } {

        set buffer ""

        append buffer [ my testSummary $results ]
        append buffer \
"================================================================================\n"

        foreach result $results {

            if [ $result passed ] { continue }

            append buffer [ ::xotcl::my printResult $result ]

            append buffer \
"================================================================================\n"
        }

        return $buffer
    }

    TestResultsEmailFormatter instproc printResult { aResult } {

        set buffer ""

        append buffer [ my printSubResult $aResult ]

        return $buffer
    }

    TestResultsEmailFormatter instproc printSubResult { aResult } {

        set buffer ""
        

        foreach result [ $aResult results ] {

            if [ $result hasclass ::xounit::TestError ] {

                append buffer "--------------------------------------------------------------------------------\n"
                append buffer "[ $aResult name ]\n"
                append buffer [ my printError $result  ]
                continue
            }

            if [ $result hasclass ::xounit::TestFailure ] {

                append buffer "--------------------------------------------------------------------------------\n"
                append buffer "[ $aResult name ]\n"
                append buffer [ my printFailure $result ]
                continue
            }

            append buffer [ my printSubResult $result ]
        }

        return $buffer
    }
}

