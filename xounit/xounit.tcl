
package require XOTcl
package require xox

::xox::Package create ::xounit
::xounit id {$Id: xounit.tcl,v 1.7 2008/03/18 20:45:32 bthomass Exp $}
::xounit requires {
    xox
    xoexception
}
::xounit loadAll
::xounit executables {
    runATest
    runTest
    runTests
    runProfile
    runCoverage
    runDocCoverage
    runSuite
    runContinuous
    makeSuite
    printResults
    makeMultiSuite
    testEnvironment
    captureEnvironment
}

::xounit @doc xounit {
    xounit is a unit testing framework for XOTcl.
}

::xounit @doc UsersGuide {

    xounit is a framework for unit testing XOTcl.   There are
    three classes that are important to xounit:  Assert, TestCase,
    and TestResult. 
    
    Assert contains a set of assert methods that check a condition
    and throw an AssertionError if the condition is false.   Asserts
    are the basis for all testing.  Checking a condition against an
    expected value is the heart of testing.  Assert methods capture
    the check and report behaviors together in one method call.  

    TestCase provides the basic platform for running tests. TestCase
    builds a test fixture in which tests will be run. This test 
    fixture provides variable isolation and a clean environment in
    which to run.  This is done through the TestCase setUp and 
    TestCase tearDown method.  TestCase setUp builds the test fixture
    for the test methods. TestCase tearDown cleans up resources after
    the test is done.   The TestCase base class is meant to be
    subclassed.  This allows subclasses to override the basic behavior
    of TestCase setUp and TestCase tearDown.   The TestCase run
    method should not be overridden for unit tests.  TestCase run
    contains the machinery to call all methods that start with
    test on TestCase subclasses. However TestCase run can be 
    overridden to support much more than unit testing.  

    TestResult defines a tree data structure of TestResult, TestPass,
    TestFailure, and TestError objects.   This data structure records
    the results of any number of levels of testing. A tree is well
    suited for capture test results since test are often broken
    down in to subtests and sub-subtest and so forth.


    xounit also provides a basis for building applications with
    Application.  Application is a subclass of TestCase and runs
    all application code within a special test method.  The reasoning
    behind this is that during development code should only be
    run in a unit test.  Since the code has been proven to work
    within the unit test framework throughout development, it will
    work in production if it runs in the test framework.   This
    also provides easy error reporting since TestResult can be
    used in the Application to build error reports.
}

namespace eval ::xounit {
    variable currentTestMethod
    variable currentResult
}


