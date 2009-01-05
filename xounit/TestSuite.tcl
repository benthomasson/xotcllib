

namespace eval xounit {

    ::xotcl::Class create TestSuite -superclass { ::xox::Node ::xounit::Test ::xounit::TestResultsWebFormatter}

    TestSuite # TestSuite {

        TestSuite is a test runner that will run all tests
        that are children of this node.
    }

    TestSuite # results { The results from running this TestSuite }
    TestSuite # packages { The packages to reload before a test }

    TestSuite parameter {  
        { results {} }
        { packages {} } }

    TestSuite # tests {

        Returns the tests that are children of this TestSuite.
        This is usually built with suite.xml files.
    }

    TestSuite instproc tests { } {

        return [ ::xox::removeIfNot \
            { $node hasclass ::xounit::Test } node [ my nodes ] ]
    }

    TestSuite # run {

        Runs this TestSuite as a single test.
    }

    TestSuite instproc run { testResult } {

        my results {}

        my runSuite

        $testResult lappend results [ my results ]
    }

    TestSuite # runSuite {

        Runs all the child tests of this test suite and
        records the test results on this TestSuite in 
        the results parameter.
    }

    TestSuite instproc runSuite { } {

        my results {}

        foreach testCase [ my tests ] {

            set testClass [ $testCase info class ]

            puts "\x1B\[35;1m"
            puts "TestRunner running test $testClass"
            puts "\x1B\[0m"

            cd [ [ $testClass getPackage ] packagePath ]

            set result [ $testCase newResult ]
            $testCase run $result
            my lappend results $result
        }
    }
}


