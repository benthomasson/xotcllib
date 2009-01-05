

namespace eval ::xounit {

    ::xotcl::Class create TestCase -superclass { 
        ::xounit::Assert ::xounit::Test ::xox::Node }

    TestCase instmixin add ::xox::Logging

    TestCase parameter {
        { runQuiet 0 }
    }

    TestCase # TestCase {  
        TestCase is a simple base class to be subclassed for your
        specific test. TestCase is a easy way to build an automated
        test for your code.  Simply subclass TestCase as in the example
        below.  Define some instprocs that start with test. Then
        override either setUp or tearDown instprocs.  TestCase works by
        finding all the methods that start with "test" in your TestCase
        subclass. It then makes three method calls on your TestCase for
        each test instproc . First setUp, second testX (where X is
        the rest of your test instproc name), and third tearDown.    
        TestCase catches any errors that your code might cause or assert
        failures that occur and builds a test report that can be printed
        as text, xml, or uploaded to a database.
        
        Example: 

        package require XOTcl
        package require xounit
        namespace import -force ::xotcl::*

        Class SimpleTest -superclass ::xounit::TestCase

        SimpleTest instproc test1NotEquals0 {} { 

            my assertNotEquals 1 0
        }

        This can be run with the tcl commands:

        set aRunner [ ::xounit::TestRunnerTextUI new ]
        $aRunner runAllTests
    }

    TestCase # result { the result for the current run. }
    TestCase # currentTestMethod \
        { name of the currently running test method. }

    TestCase parameter {    result
                            currentTestMethod }

    TestCase # newResult {

        Overrides newResult to save the result in the
        result parameter.
    }

    TestCase instproc newResult { { parent "" } } {

        set result [ ::xotcl::next $parent ]
        ::xotcl::my result $result
        return $result
    }

    TestCase # setUp { 
        setUp is called before each test method in
        your specific test case.  This provides a clean
        test fixture for each test method.  Over-ride 
        setUp in your specific TestCase to configure
        your TestCase before each test.  Example:

        SimpleTest instproc setUp {} {

            my set testValue 10
        }

        SimpleTest instproc testValue {} {

            my assertEquals [ my set testValue ] 10
        }
    }
        

    TestCase instproc setUp {} { return }

    TestCase # tearDown {

        tearDown is called after each test method
        in your specific test case.  This allows
        you to clean up any resources that were used
        in your test methods. Override this method
        in your TestCase and it will automatically
        called after each test method.
    }

    TestCase instproc tearDown {} { return }

    TestCase # run {

        run is used by the TestRunner to start the
        test methods in a TestCase.  run collects
        the pass, fail, error states of each test 
        method and adds them to the TestResult object
        passed to run. This method is called automatically
        by the TestRunner so your TestCases should
        not call this method. 
    }

    TestCase instproc print { string } {

        if {![ my runQuiet ]} {

            puts $string
        }
    }

    TestCase instproc run { testResult } {

        set runTheseTests [ lsort [ ::xotcl::my info methods {test*} ] ]

        foreach test $runTheseTests  {

            my print "Running [ my info class ] $test"
            ::xotcl::my runTest $testResult $test
        }
    }


    TestCase # runIndependentTest {

        Runs another test method on another object as
        as subtest of the current test.  The current test
        is run independently of pass or failure of
        the subtest.  
        
        The result of the subtest is recorded seperately
        in the result tree.
    }

    TestCase instproc runIndependentTest { object test } {

        set result $::xounit::currentResult 

        if { "$object" == "[ self ]" } {

            my runTest $result $test

        } else {

            set newResult [ $object newResult ]
            set newResult [ $result addResult $newResult ]
            $object runTest $newResult $test
        }

        return 
    }

    TestCase # runDependentTest {

        Runs another test method on another object as a
        subtest to the currently running test. If the
        subtest fails this test is stopped.

        The result of the subtest is recorded seperately
        in the result tree.
    }

    TestCase instproc runDependentTest { object test } {

        set result $::xounit::currentResult 

        set passed 1

        if { "$object" == "[ self ]" } {
            set passed [ my runTest $result $test ]
        } else {

            set newResult [ $object newResult ]
            set newResult [ $result addResult $newResult ]
            set passed [ $object runTest $newResult $test ]
        }

        my assert $passed "Dependent test [ $object name ] $test failed"

    }

    TestCase # runExternalTest {

        Runs another test method on another object along 
        with this test.
    }

    TestCase instproc runExternalTest { object test } {

        set result $::xounit::currentResult 
        $object currentTestMethod $test
        $object result $result
        $object $test
    }

    TestCase # runTest {

        runTest is used by run to start a single test.
        Again this should not be called by your TestCase.
    }

    TestCase instproc runTest { testResult test } {
        
        set return 1

        ::xoexception::try {

            ::xox::let [ list [ list ::xounit::currentTestMethod $test   ] [ list ::xounit::currentResult $testResult ] ] {

            ::xotcl::my currentTestMethod $test
            ::xotcl::my result $testResult
            ::xotcl::my setUp
            $testResult addNewResult ::xounit::TestFinished \
                    -name [ $testResult name ] \
                    -test $test \
                    -time [ clock seconds ] \
                    -return [ ::xotcl::my $test ] \
                    -testedMethod $test \
                    -testedClass [ ::xox::ObjectGraph findFirstImplementationClass [ self ] $test ] \
                    -testedObject [ self ] 

            set return 1

            }

        } catch { ::xounit::AssertionError result } {

            my reportFailure $testResult $result $test
            set return 0

        } catch { error result } {

            my reportError $testResult $result $test
            set return 0
        }

        my runTearDown $testResult $test
        return $return
    }

    TestCase # reportFailure {

        Adds a failure to the test result with the 
        AssertionError message.
    }

    TestCase instproc reportFailure { testResult errorResult test } {

        set message [ $errorResult message ]
        $testResult addNewResult ::xounit::TestFailure \
                -name [ $testResult name ] \
                -test $test \
                -error $message \
                -time [ clock seconds ] \
                -testedMethod $test \
                -testedClass [ ::xox::ObjectGraph findFirstImplementationClass [ self ] $test ] \
                -testedObject [ self ] 
    }

    TestCase # reportError {

        Gathers the error information and adds information
        to a test result.
    }

    TestCase instproc reportError { testResult errorResult test } {

        global errorInfo
        set message [ ::xoexception::Throwable::extractMessage $errorResult ]

        append message "\n"
        append message $errorInfo

        $testResult addNewResult ::xounit::TestError \
                -name [ $testResult name ] \
                -test $test \
                -error "$message" \
                -time [ clock seconds ] \
                -testedMethod $test \
                -testedClass [ ::xox::ObjectGraph findFirstImplementationClass [ self ] $test ] \
                -testedObject [ self ] 

    }

    TestCase # runTearDown {

        runs the tearDown method in a catch block
        and reports an error if one is caught.
    }

    TestCase instproc runTearDown { testResult test } {

        if [ catch {

            ::xotcl::my tearDown

        } result ] {
            
            my reportError $testResult $result $test
        }
    }

    TestCase # catchAndReport {

        catchAndReport is used to stop a failed assert
        from stopping the test altogether.  catchAndReport
        forms blocks of the test that insulate the rest
        of the test from these blocks.

        Example:

        Class ATest -superclass ::xounit::TestCase

        ATest instproc testCatchAndReport { } {

            my assert 1 "I will pass"

            my catchAndReport { 

                my assert 0 "I will fail, but not stop the test"
            }

            my assertEquals 2 2 "I will be run and pass"
            my fail "I stop the test not the my assert 0 ... "
        }

        #When this example is run it will report two failures,
        #not one.
    }

    TestCase instproc catchAndReport { script } {

        set retValue [ catch "uplevel [ self callinglevel ] {$script}" result ]

        switch $retValue {

            3 { error "break not supported in catchAndReport" }
            4 { error "continue not supported in catchAndReport" }
            2 { error "return not supported in catchAndReport" }
            0 { return 1 }
            1 { 
                if [ ::xoexception::Throwable isThrowable $result ::xounit::AssertionError ] {
                    my reportFailure $::xounit::currentResult $result $::xounit::currentTestMethod
                } else {
                    my reportError $::xounit::currentResult $result $::xounit::currentTestMethod 
                }
             }
            default { error "$retValue not supported in catchAndReport" }
        }

        return 0
    }

    TestCase # onFailure {

        Runs a debug script after a test script fails.

        Experimental
    }

    TestCase instproc onFailure { testScript debugScript } {

        set retCode [ catch {

            uplevel $testScript
            
        } result ] 

        switch $retCode {

            3 { error "break not supported in onFailure" }
            4 { error "continue not supported in onFailure" }
            2 { error "return not supported in onFailure" }
            0 -
            1 { 

                uplevel $debugScript
            }
        }

        error $result
    }

    TestCase instproc assertTestRan { name { test "" } } {

        set result $::xounit::currentResult 

        foreach aResult [ $result allResults ] {

        if { "[ $aResult name ]" == "$name" } {

            if { "" == "$test" } { return $aResult }

            foreach sub [ $aResult results ] {

                if { "[ $sub test ]" == "$test" } {

                    return $sub
                }
            }
        }

        }

        my fail "Test $name method $test has not run"
    }

    TestCase instproc assertTestPassed { name { test "" } } {

        set result [ my assertTestRan $name $test ]
        my assert [ $result passed ] "[ $result name ] $test did not pass"
    }

    TestCase instproc assertTestFailed { name { test "" } } {

        set result [ my assertTestRan $name $test ]
        my assertFalse [ $result passed ] "[ $result name ] $test did not fail"
    }

    TestCase instproc assertRunTest { test } {

        my runDependentTest [ self ] $test 
    }

    TestCase instproc checkRunTest { test } {

        set result $::xounit::currentResult 
        return [ my runTest $result $test ]
    }

    TestCase instproc TODO { { message "" } } {

        my fail $message
    }

    TestCase proc findAllTestClasses { namespace } {

        set classes ""
        foreach class [ ::xox::ObjectGraph findAllSubClasses ::xounit::TestCase ]  {
            if [ string match ::${namespace}* $class ] { lappend classes $class }
        }
        return $classes
    }

    TestCase proc findAllTestNames { namespace } {

        set classes ""
        foreach class [ ::xox::ObjectGraph findAllSubClasses ::xounit::TestCase ]  {
            if [ string match ::${namespace}* $class ] { lappend classes [ namespace tail $class ] }
        }
        return $classes
    }
}

