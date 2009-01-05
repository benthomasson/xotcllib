
namespace eval xounit {

    Class create TestFailuresWebFormatter \
        -superclass ::xounit::TestResultsWebFormatter

    TestFailuresWebFormatter # TestFailuresWebFormatter {

        Format test failures and errors for display on a web page.
    }

    TestFailuresWebFormatter # formatWebResults {

        Format a list of results for viewing on the web.
    }

    TestFailuresWebFormatter instproc formatWebResults { results } {

        set results [ lsort -command "[ self ] organizeResults" $results ]

        foreach result $results {

            puts "[ $result name ]"
        }

        set buffer ""

        append buffer [ my testSummary $results ]

        foreach result $results {

            if [ $result passed ] { continue }
            append buffer [ my printResult $result ]
        }

        return $buffer
    }
}

