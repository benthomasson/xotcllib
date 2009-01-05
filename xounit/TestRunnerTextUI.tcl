

namespace eval xounit {

    ::xotcl::Class create TestRunnerTextUI -superclass { 
        ::xounit::TestRunner 
        ::xounit::TestResultsColorTextFormatter 
    }

    TestRunnerTextUI # TestRunnerTextUI {

        TestRunnerTextUI integrates TestRunner and TestResultsTextFormatter
        that allows automatic printing of results to stdout after
        running then tests.

        TestRunnerTextUI overrides runAllTests, runTests
        and calls printResults after these methods complete.
    }

    TestRunnerTextUI instproc runAllTests { args } {

        ::xotcl::next
        ::xotcl::my printResults [ ::xotcl::my results ]
    }

    TestRunnerTextUI instproc runTests { testClassList } {

        ::xotcl::next

        ::xotcl::my printResults [ ::xotcl::my results ]
    }
}

