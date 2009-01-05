
namespace eval ::xounit::test {

    namespace import -force ::xotcl::*

    Class TestCatchException -superclass ::xounit::TestCase

    TestCatchException instproc testPass {} {

        my assert 1 { Should Pass }

        return
    }


    TestCatchException instproc testFail {} {


        #my assert 0 { SHOULD FAIL ITS OK }

    }


    Class NamespaceTest -superclass ::xounit::TestCase

    NamespaceTest instproc testATest {} {

        xotcl::my instvar something

        set something toSomething
    }


    namespace eval namespace {

        namespace import -force ::xotcl::*

        Class NamespaceTest2 -superclass ::xounit::TestCase 

        NamespaceTest2 instproc testATest {} {

            xotcl::my instvar something

            set something toSomething
        }
    }

    Class ErrorTest -superclass ::xounit::TestCase 

    ErrorTest instproc testErrorInAssert {} {

        catch {

            xotcl::my assert{ [ error "ERROR" ] } { This failure is expected }

            puts "ErrorTest::testErrorInAssert FAILED!"

            exit 1

        } result

        xotcl::my assertEquals "$result"  "ERROR"  { Did not catch the right error }
    }

    Class FailureTest -superclass ::xounit::TestCase 

    FailureTest instproc testFailure {} {

        my assertFailure {

        my assert 0 "REALLY PASSED"

        }
    }

    FailureTest instproc testFailure2 {} {

        catch {

            my assert 0 "REALLY PASSED"

        } result

        my assertEquals "REALLY PASSED" [ $result message ] "Did not fail!!!!"
    }

    Class TestAssertFindIn -superclass ::xounit::TestCase 

    TestAssertFindIn instproc notest {} {

        set a [ ::xounit::Assert new ]

        $a assertFindIn a a "Should find a"
        $a assertFindIn a abcdefgh "Should find a"
        $a assertFindIn a "
        
        
        abcdefgh" "Should find a"

        $a assertFindIn TestCasesAreCool "I dont know about you but I think TestCasesAreCool" 

        catch {

            $a assertFindIn b a 

        } result

        my assertEquals "\nDid not find b in:\na - 0" [ ::xoexception::Throwable::extractMessage $result ]


        catch {

            $a assertFindIn "" a 

        } result

        my assertEquals "\nDid not find  in:\na - 0" [ ::xoexception::Throwable::extractMessage $result ]
    }

    Class TestAssertRegex -superclass ::xounit::TestCase 

    TestAssertRegex instproc testPositive {} {

        set a [ ::xounit::Assert new ]

        $a assertRegex a a

        $a assertRegex . a

        set all [ $a assertRegex (!+) !!!!. ]

        my assertEquals !!!! $all 
    }

    TestAssertRegex instproc testFail {} {

        set a [ ::xounit::Assert new ]

        catch {

            $a assertRegex a b

            my catchAndReport {

                my fail "\$a assertRegex a b should have failed"
            }
        }
    }

    Class TestCatchAndReport -superclass ::xounit::TestCase 

    TestCatchAndReport instproc testSimple {} {

        my assert [  my catchAndReport { 

        } ]
    }

    TestCatchAndReport instproc testScope {} {

        set a 0

        my assert [ my catchAndReport { 

            set a 5
        } ]
        my assertEquals 5 $a 
    }

    TestCatchAndReport instproc testFail {} {

        set test [ ::xounit::TestCase new ]

        set result [ $test newResult ]
        puts [ $result info class ]

        $test result $result
        $test currentTestMethod testFail

        set ::xounit::currentResult $result
        set ::xounit::currentTestMethod testFail

        my assertFalse [ $test catchAndReport { 

            my fail "Passed"
        } ]

        puts [ $result info class ]
        
        my assertFalse [ $result passed ]
        my assertEquals 0 [ llength [ $result errors ] ] 
        my assertEquals 1 [ llength [ $result failures ] ] 
        my assertEquals 0 [ llength [ $result passes ] ] 
        my assertEquals 1 [ llength [ $result tests ] ] 
        my assertEquals Passed [ $result . failures . error ] 

        unset ::xounit::currentResult
        unset ::xounit::currentTestMethod
    }

    TestCatchAndReport instproc testError {} {

        set test [ ::xounit::TestCase new ]

        set result [ $test newResult ]
        puts [ $result info class ]

        $test result $result
        $test currentTestMethod testFail
        set ::xounit::currentResult $result
        set ::xounit::currentTestMethod testFail

        my assertFalse [ $test catchAndReport { 

            error "Passed"
        } ]

        puts [ $result info class ]
        
        my assertFalse [ $result passed ]
        my assertEquals 1 [ llength [ $result errors ] ] 
        my assertEquals 0 [ llength [ $result failures ] ] 
        my assertEquals 0 [ llength [ $result passes ] ] 
        my assertEquals 1 [ llength [ $result tests ] ] 

        unset ::xounit::currentResult
        unset ::xounit::currentTestMethod
    }

    Class TestWebFormatter -superclass ::xounit::TestCase 

    TestWebFormatter instproc testLsort {} {

        set formatter [ ::xounit::TestResultsWebFormatter new ]

        lappend results [ ::xounit::TestResult new -name c ]
        lappend results [ ::xounit::TestResult new -name b ]
        lappend results [ ::xounit::TestResult new -name a ]
        lappend results [ ::xounit::TestResult new -name c ]
        lappend results [ ::xounit::TestResult new -name c ]
        lappend results [ ::xounit::TestResult new -name d ]
        lappend results [ ::xounit::TestResult new -name A ]

        set results [ lsort -command "$formatter organizeResults" $results ]

        my assertEquals A [ [ lindex $results 0 ] name ] 
        my assertEquals a [ [ lindex $results 1 ] name ] 
        my assertEquals b [ [ lindex $results 2 ] name ] 
        my assertEquals c [ [ lindex $results 3 ] name ] 
    }

    TestWebFormatter instproc testLsort2 {} {

        set formatter [ ::xounit::TestResultsWebFormatter new ]

        set names [ list \
        "L3vpnTestbed / 7600-PE1 / gigabitethernet3/3.2000" \
        "ESR-CE1" \
        "L3vpnTestbed / ESR-CE1 / Serial:0" \
        "L3vpnTestbed / ESR-CE1 / pos3/0/0.20" \
        "ESR-PE1" \
        "L3vpnTestbed / ESR-PE1 / Serial:0" \
        "Bgp" \
        "L3vpnTestbed / GSR-CE1 / pos0/2.20" \
        "Bgp" ]

        foreach name $names {

            lappend results [ ::xounit::TestResult new -name $name ]
        }
        
        set sortedNames [ lsort $names ]

        set results [ lsort -command "$formatter organizeResults" $results ]

        set index 0

        puts "$sortedNames"
        
        foreach name $sortedNames {

            my assertEquals $name [ [ lindex $results $index ] name ] 
            incr index
        }
    }

    Class TestAssertError -superclass ::xounit::TestCase

    TestAssertError instproc test { } {

        my assertNoError { set a 1 } "A"
        my assertError { error a } "B"
    }

    TestAssertError instproc testFailNoError { } {

        my assertFailure {

        my assertNoError { error Passed } "Passed"

        }
    }

    TestAssertError instproc testFailError { } {

        my assertFailure {

        my assertError { set a Passed } "Passed"

        }
    }

    Class TestNewResult -superclass ::xounit::TestCase

    TestNewResult instproc test { } {

        set test [ ::xounit::TestCase new ]

        set result [ $test newResult ]
        my assertEquals ::xounit::TestResult [ $result info class ]
    }
}
