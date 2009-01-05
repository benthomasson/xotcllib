
namespace eval ::xounit::test {

    namespace import -force ::xotcl::*

    Class TestTestResultsTextFormatter -superclass ::xounit::TestCase

    TestTestResultsTextFormatter instproc setUp { } {

        my instvar testResults a b c d \
            p1 p2 p3 f1 f2 f3 e1 e2 e3

        set a [ ::xounit::TestResult new -name A ]
        set b [ ::xounit::TestResult new -name B ]
        set c [ ::xounit::TestResult new -name C ]
        set d [ ::xounit::TestResult new -name D ]
        
        set p1 [ ::xounit::TestPass new -name P1 -test 1 -return 1]
        set p2 [ ::xounit::TestPass new -name P2 -test 2 -return 2]
        set p3 [ ::xounit::TestPass new -name P3 -test 3 -return 3]

        set f1 [ ::xounit::TestFailure new -name F1 -test 1 -error 1]
        set f2 [ ::xounit::TestFailure new -name F2 -test 2 -error 2]
        set f3 [ ::xounit::TestFailure new -name F3 -test 3 -error 3 ]

        set e1 [ ::xounit::TestError new -name E1 -test 1 -error 1]
        set e2 [ ::xounit::TestError new -name E2 -test 2 -error 2]
        set e3 [ ::xounit::TestError new -name E3 -test 3 -error 3]

        set b [ $a addResult $b ]
        set c [ $a addResult $c ]
        set d [ $c addResult $d ]

        set p1 [ $a addResult $p1 ]
        set p2 [ $b addResult $p2 ]
        set p3 [ $c addResult $p3 ]

        set f1 [ $b addResult $f1 ]
        set f2 [ $c addResult $f2 ]
        set f3 [ $d addResult $f3 ]

        set e1 [ $a addResult $e1 ]
        set e2 [ $b addResult $e2 ]
        set e3 [ $d addResult $e3 ]

        my lappend testResults $a
        my lappend testResults [ ::xounit::TestPass new -name Pass -test pass -return pass ]
        my lappend testResults [ ::xounit::TestFailure new -name Failure -test failure -error failure ]
        my lappend testResults [ ::xounit::TestError new -name Error -test error -error error ]
    }

    TestTestResultsTextFormatter instproc test {} {

        my instvar testResults

        my assert [ info exists testResults ] 1
        set formatter [ ::xounit::TestResultsTextFormatter new ]
        $formatter printResults $testResults
    }

    Class TestTestFailuresTextFormatter -superclass ::xounit::test::TestTestResultsTextFormatter

    TestTestFailuresTextFormatter instproc test {} {

        my instvar testResults

        my assert [ info exists testResults ] 1
        set formatter [ ::xounit::TestFailuresTextFormatter new ]
        $formatter printResults $testResults
    }

}
