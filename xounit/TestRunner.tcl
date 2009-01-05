

namespace eval xounit {

    ::xotcl::Class create TestRunner 

    TestRunner # TestRunner {

        TestRunner is a simple implementation of a test execution engine.
        Since most of the test handling code is actually in TestCase
        this class is very simple.  TestRunner just finds test classes,
        creates new instances and calls the run method on the new instance.
        TestRunner then stores the TestResults from the test runs in a
        results variable.
    }

    TestRunner # results \
        { a list of results from tests that have been run from this test runner }

    TestRunner parameter { { results "" } }

    TestRunner # runAllTests {

        runAllTests finds all subclasses of ::xounit::Test, makes new instances of
        those classes, and runs those test instances.  Optionally a
        namespace argument can be supplied that will limit the search
        for the subclasses to only that namespace. 

        Normally this will called this way:

        set runner [ ::xounit::TestRunner new ]
        $runner runAllTests
    }

    TestRunner instproc runAllTests { { aNamespace :: } } {

        foreach testClass [ my findAllTestClasses ] {

            if { [ string first $aNamespace $testClass ] != 0 } { continue }

            ::xoexception::try {
            
                ::xotcl::my lappend results [ ::xotcl::my runATest $testClass ]
            } catch { error e } {

                global errorInfo
                puts "Error running test [ ::xoexception::Throwable::extractMessage $e ]\n $errorInfo"
           }
        }
    }

    TestRunner # findAllTestClasses {

        Finds all the subclasses of ::xounit::Test
    }

    TestRunner instproc findAllTestClasses {} {

        set allTestClasses ""

        #eval "lappend testClasses [ ::xounit::Test info subclass ]"
        set testClasses [ ::xounit::Test info subclass ]

        while { [ llength $testClasses ] != 0 } {

            set currentMultiClass [ lindex $testClasses 0 ]

            set testClasses [ lreplace $testClasses 0 0 ]

            set currentClass [ lindex $currentMultiClass 0 ]

            if { "$currentClass" == "" } continue

            lappend allTestClasses $currentClass

            #eval "lappend testClasses [ $currentClass info subclass ]"
            set testClasses [ concat $testClasses [ $currentClass info subclass ] ]
        }

        return [ lsort $allTestClasses ]
    }

    TestRunner # runATest {

        runATest runs a test for one test class.
        This process is followed:
        1) Create a new test instance from the ::xounit::Test subclass.
        2) Create a new TestResult from the new test instance newResult.
        3) Calls run on the new test instance with the new result instance.
        4) Return the test result.
    }

    TestRunner instproc runATest { aTestClass } {

        puts "\x1B\[35;1m"
        puts "TestRunner running test $aTestClass"
        puts "\x1B\[0m"

        cd [ [ $aTestClass getPackage ] packagePath ]

        if [ catch {

            set aTest [ $aTestClass new ]    
            set aResult [ $aTest newResult ]
            $aTest run $aResult

        } result ] {

            global errorInfo
            
            set message "$result\n"

            append message "Could not create test object from class $aTestClass"
            append message "\n"
            append message "$errorInfo"

            set aResult [ ::xounit::TestResult new -name $aTestClass ]
            $aResult addNewResult ::xounit::TestError \
                    -name $aTestClass \
                    -test init \
                    -error "$message"
        }

        return $aResult
        
    }

    TestRunner # runTests {

        runTests runs the tests for a list of classes and
        appends the result to the end of the results list.
    }

    TestRunner instproc runTests { testClassList } {

        ::xotcl::my instvar results

        foreach testClass $testClassList {

            ::xotcl::my lappend results [ ::xotcl::my runATest $testClass ]
        }
    }

    TestRunner # passed { } {

        Returns true (1) if all tests that this test runner
        has run have passed.  Returns false (0) otherwise.
    }

    TestRunner instproc passed { } {
        
        ::xotcl::my instvar results

        foreach result $results {

            if { ![ $result passed ] } { return 0 }
        }

        return 1
    }
}

