
namespace eval ::xounit::test {

    namespace import -force ::xotcl::*

    Class TestTestResult -superclass ::xounit::TestCase

    TestTestResult instproc testInit { } {

        set result [ ::xounit::TestResult new -name TestResult ]

        my assertEquals [ $result name ] TestResult
        my assertEquals [ $result results ] ""
    }

    TestTestResult instproc testAddPass { } {

        set result [ ::xounit::TestResult new -name TestResult ]

        $result addResult [ ::xounit::TestPass new -name 1 -test 2 -return 3 ] 
        my assertEquals [ llength [ $result passes ] ] 1 
        my assertEquals [ llength [ $result results ] ] 1 
        my assertEquals [ llength [ $result errors ] ] 0 
        my assertEquals [ llength [ $result failures ] ] 0 
        my assert [ $result passed ]
    }

    TestTestResult instproc testAddFailure { } {

        set result [ ::xounit::TestResult new -name TestResult ]

        $result addResult [ ::xounit::TestFailure new -name 1 -test 2 -error 3 ] 

        my assertEquals [ llength [ $result passes ] ] 0 
        my assertEquals [ llength [ $result results ] ] 1 
        my assertEquals [ llength [ $result errors ] ] 0 
        my assertEquals [ llength [ $result failures ] ] 1 
        my assertFalse [ $result passed ]
    }

    TestTestResult instproc testAddError { } {

        set result [ ::xounit::TestResult new -name TestResult ]

        $result addResult [ ::xounit::TestError new -name 1 -test 2 -error 3 ]

        my assertEquals [ llength [ $result passes ] ] 0 
        my assertEquals [ llength [ $result results ] ] 1 
        my assertEquals [ llength [ $result errors ] ] 1 
        my assertEquals [ llength [ $result failures ] ] 0 
        my assertFalse [ $result passed ]
    }

    TestTestResult instproc testAddResult { } {

        set result [ ::xounit::TestResult new -name TestResult ]

        $result addResult [ ::xounit::TestResult new -name SubResult ]

        my assertEquals [ llength [ $result passes ] ] 0 
        my assertEquals [ llength [ $result results ] ] 1 
        my assertEquals [ llength [ $result errors ] ] 0 
        my assertEquals [ llength [ $result failures ] ] 0 
        my assert [ $result passed ]
    }

    TestTestResult instproc testAddResultAddFailure { } {

        set result [ ::xounit::TestResult new -name TestResult ]
        set subResult [ ::xounit::TestResult new -name SubResult ]
        set subResult [ $result addResult $subResult ]
        $subResult addResult [ ::xounit::TestFailure new -name 1 -test 2 -error 3 ]

        my assertEquals [ llength [ $result passes ] ] 0 
        my assertEquals [ llength [ $result results ] ] 1 
        my assertEquals [ llength [ $result errors ] ] 0 
        my assertEquals [ llength [ $result failures ] ] 0 
        my assertFalse [ $result passed ]

        my assertEquals [ llength [ $subResult passes ] ] 0 
        my assertEquals [ llength [ $subResult results ] ] 1 
        my assertEquals [ llength [ $subResult errors ] ] 0 
        my assertEquals [ llength [ $subResult failures ] ] 1 
        my assertFalse [ $subResult passed ]
    }

    TestTestResult instproc testPrint { } {

        set result [ ::xounit::TestResult new -name TestResult ]
        set subResult [ ::xounit::TestResult new -name SubResult ]
        set subResult [ $result addResult $subResult ]
        $subResult addResult [ ::xounit::TestFailure new -name 1 -test 2 -error 3 ]
        set newResult [ ::xounit::TestResult new -name SubResult ]
        set newResult [ $subResult addResult $newResult ]
        set subResult $newResult
        set newResult [ ::xounit::TestResult new -name SubResult ]
        set newResult [ $subResult addResult $newResult ]
        set subResult $newResult
        set newResult [ ::xounit::TestResult new -name SubResult ]
        set newResult [ $subResult addResult $newResult ]
        set subResult $newResult
        $subResult addResult [ ::xounit::TestFailure new -name 1 -test 2 -error 3 ]

        set formatter [ ::xounit::TestResultsTextFormatter new ]

        puts "\n\n"
        $formatter printResults $result

        return ""
    }

    TestTestResult instproc testPrintEmail { } {

        set result [ ::xounit::TestResult new -name TestResult ]
        set subResult [ ::xounit::TestResult new -name SubResult ]
        set subResult [ $result addResult $subResult ]
        $subResult addResult [ ::xounit::TestFailure new -name 1 -test 2 -error 3 ]
        set newResult [ ::xounit::TestResult new -name SubResult ]
        set newResult [ $subResult addResult $newResult ]
        set subResult $newResult
        set newResult [ ::xounit::TestResult new -name SubResult ]
        set newResult [ $subResult addResult $newResult ]
        set subResult $newResult
        set newResult [ ::xounit::TestResult new -name SubResult ]
        set newResult [ $subResult addResult $newResult ]
        set subResult $newResult
        $subResult addResult [ ::xounit::TestFailure new -name 1 -test 2 -error 3 ]

        set formatter [ ::xounit::TestResultsEmailFormatter new ]

        puts "\n\n"
        $formatter printResults $result

        return ""
    }

    TestTestResult instproc testPrintWeb { } {

        set result [ ::xounit::TestResult new -name TestResult ]
        set subResult [ ::xounit::TestResult new -name SubResult ]
        set subResult [$result addResult $subResult ]
        $subResult addResult [ ::xounit::TestFailure new -name 1 -test 2 -error 3 ]
        set newResult [ ::xounit::TestResult new -name SubResult ]
        set newResult [ $subResult addResult $newResult ]
        set subResult $newResult
        set newResult [ ::xounit::TestResult new -name SubResult ]
        set newResult [ $subResult addResult $newResult ]
        set subResult $newResult
        set newResult [ ::xounit::TestResult new -name SubResult ]
        set newResult [ $subResult addResult $newResult ]
        set subResult $newResult
        $subResult addResult [ ::xounit::TestFailure new -name 1 -test 2 -error 3 ]

        set formatter [ ::xounit::TestResultsWebFormatter new ]

        puts "\n\n"
        $formatter printResults $result

        return ""
    }

    TestTestResult instproc testTestedClassTestedMethod { } {

        Class  ::xounit::TestClassTestedClass -superclass ::xounit::TestCase

        ::xounit::TestClassTestedClass instproc testMethodPass { } {

        }

        ::xounit::TestClassTestedClass instproc testMethodFail { } {

            my fail "fail"
        }

        ::xounit::TestClassTestedClass instproc testMethodError { } {

            error error
        }

        set test [ ::xounit::TestClassTestedClass new ]

        set result [ $test runAlone ]

        my assertEquals [ $result info class ] ::xounit::TestResult
        my assertEquals [ $result name ] ::xounit::TestClassTestedClass 

        set pass [ $result passes ]

        my assertEquals [ $pass info class ] ::xounit::TestFinished
        my assertEquals [ $pass name ] ::xounit::TestClassTestedClass 
        my assertEquals [ $pass test ] testMethodPass
        my assertEquals [ $pass testedClass ] ::xounit::TestClassTestedClass
        my assertEquals [ $pass testedMethod ] testMethodPass

        set failure [ $result failures ]

        my assertEquals [ $failure info class ] ::xounit::TestFailure
        my assertEquals [ $failure name ] ::xounit::TestClassTestedClass 
        my assertEquals [ $failure test ] testMethodFail
        my assertEquals [ $failure testedClass ] ::xounit::TestClassTestedClass
        my assertEquals [ $failure testedMethod ] testMethodFail

        set error [ $result errors ]

        my assertEquals [ $error info class ] ::xounit::TestError
        my assertEquals [ $error name ] ::xounit::TestClassTestedClass 
        my assertEquals [ $error test ] testMethodError
        my assertEquals [ $error testedClass ] ::xounit::TestClassTestedClass
        my assertEquals [ $error testedMethod ] testMethodError
    }

    TestTestResult instproc testMessage { } {

        set pass [ ::xounit::TestPass new -name Pass \
                        -return message ]
        my assertEquals [ $pass message ] message
        set fail [ ::xounit::TestFailure new -name Failure \
                        -error message ]
        my assertEquals [ $fail message ] message
        set error [ ::xounit::TestError new -name Error \
                        -error message ]
        my assertEquals [ $error message ] message
    }

    TestTestResult instproc testTree { } {

        set a [ ::xounit::TestResult new -name A ]
        set b [ ::xounit::TestResult new -name B ]
        set c [ ::xounit::TestResult new -name C ]
        set d [ ::xounit::TestResult new -name D ]
        
        set p1 [ ::xounit::TestPass new -name P1 ]
        set p2 [ ::xounit::TestPass new -name P2 ]
        set p3 [ ::xounit::TestPass new -name P3 ]

        set f1 [ ::xounit::TestFailure new -name F1 ]
        set f2 [ ::xounit::TestFailure new -name F2 ]
        set f3 [ ::xounit::TestFailure new -name F3 ]

        set e1 [ ::xounit::TestError new -name E1 ]
        set e2 [ ::xounit::TestError new -name E2 ]
        set e3 [ ::xounit::TestError new -name E3 ]

        set b [  $a addResult $b ]
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

        set passes [ $a deepPasses ]
        set errors [ $a deepErrors ]
        set failures [ $a deepFailures ]

        my assertObjectInList $passes $p1
        my assertObjectInList $passes $p2
        my assertObjectInList $passes $p3

        my assertObjectInList $errors $e1
        my assertObjectInList $errors $e2
        my assertObjectInList $errors $e3

        my assertObjectInList $failures $f1
        my assertObjectInList $failures $f2
        my assertObjectInList $failures $f3

        set passes [ $b deepPasses ]
        set errors [ $b deepErrors ]
        set failures [ $b deepFailures ]

        my assertObjectInList $passes $p2 
        my assertObjectInList $failures $f1 

        set passes [ $c deepPasses ]
        set errors [ $c deepErrors ]
        set failures [ $c deepFailures ]

        my assertObjectInList $passes $p3
        my assertObjectInList $failures $f2 
        my assertObjectInList $failures $f3
        my assertObjectInList $errors $e3

        set passes [ $d deepPasses ]
        set errors [ $d deepErrors ]
        set failures [ $d deepFailures ]

        my assertObjectInList $failures $f3
        my assertObjectInList $errors $e3

        my assertEquals $a $a
        my assertEquals $b ${a}::TestResult
        my assertEquals $c ${a}::TestResult1
        my assertEquals $d ${a}::TestResult1::TestResult
        my assertEquals $p1 ${a}::TestPass
        my assertEquals $p2 ${a}::TestResult::TestPass
        my assertEquals $p3 ${a}::TestResult1::TestPass
        my assertEquals $f1 ${a}::TestResult::TestFailure
        my assertEquals $f2 ${a}::TestResult1::TestFailure
        my assertEquals $f3 ${a}::TestResult1::TestResult::TestFailure
        my assertEquals $e1 ${a}::TestError
        my assertEquals $e2 ${a}::TestResult::TestError
        my assertEquals $e3 ${a}::TestResult1::TestResult::TestError
    }

    TestTestResult instproc testPercent { } {

        set a [ ::xounit::TestResult new -name A ]

        $a addResult [ ::xounit::TestPass new -name P1 ]

        my assertEquals [ $a passPercent ] 100

        $a addResult [ ::xounit::TestFailure new -name F1 ]

        my assertEquals [ $a passPercent ] 50

        $a addResult [ ::xounit::TestError new -name E1 ]

        my assertEquals [ expr { int( [ $a passPercent ] ) } ] 33
    }

    TestTestResult instproc testGetText { } {

        set result [ ::xounit::TestResult new -name TestResult ]

        my assertEquals [ $result name ] TestResult
        my assertEquals [ $result results ] ""

        my assertEqualsByLine [ $result getText ] \
        "TestResult
        All Passed: 0
        =================
        Tests: 0
        Errors: 0
        Failures: 0
        Passes: 0"



    }

    TestTestResult instproc testStatus { } {

        set result [ ::xounit::TestResult new -name TestResult ]
        set pass [ ::xounit::TestPass new ]
        set fail [ ::xounit::TestFailure new ]
        set error [ ::xounit::TestError new ]
        my assertEquals [ $result getStatus ] passed
        my assertEquals [ $pass getStatus ] passed
        my assertEquals [ $fail getStatus ] failed
        my assertEquals [ $error getStatus ] failed

        set r2 [ ::xounit::TestResult new ]
        $r2 addNewResult ::xounit::TestPass
        my assertEquals [ $r2 getStatus ] passed 1

        set r3 [ ::xounit::TestResult new ]
        $r3 addNewResult ::xounit::TestPass
        $r3 addNewResult ::xounit::TestFailure
        my assertEquals [ $r3 getStatus ] failed 2

        set r4 [ ::xounit::TestResult new ]
        $r4 addNewResult ::xounit::TestPass
        $r4 addNewResult ::xounit::TestError
        my assertEquals [ $r4 getStatus ] failed 3
    }

    TestTestResult instproc testTime { } {

        set result [ ::xounit::TestResult new -name TestResult ]

        $result addResult [ ::xounit::TestFailure new -name 1 -test 2 -error 3 -time [ clock seconds ] ] 

        my assertEquals [ llength [ $result passes ] ] 0 
        my assertEquals [ llength [ $result results ] ] 1 
        my assertEquals [ llength [ $result errors ] ] 0 
        my assertEquals [ llength [ $result failures ] ] 1 
        set sub [ $result info children ]
        my assertObject $sub 
        my assertEquals [ $sub time ] [ clock seconds ]
        my assertEquals [ $sub getTime ] [ clock format [ clock seconds ] ]
        my assertFalse [ $result passed ]
    }

    TestTestResult instproc testCopyResult { } {

        set result [ ::xounit::TestResult new -name TestResult ]

        $result copyResult [ ::xounit::TestResult new ]
        $result copyResult [ ::xounit::TestResult new ]

        my assertObjectTreeValues $result {
            TestResult {
                nodeName TestResult
            }
            TestResult1 {
                nodeName TestResult1
            }
        }

        return [ $result dumpTreeData ]
    }

    TestTestResult instproc testAddResult2 { } {

        set result [ ::xounit::TestResult new -name TestResult ]

        $result addResult [ ::xounit::TestResult new ]
        $result addResult [ ::xounit::TestResult new ]

        my assertObjectTreeValues $result {
            TestResult {
                nodeName TestResult
            }
            TestResult1 {
                nodeName TestResult1
            }

        }

        return [ $result dumpTreeData ]
    }
}

