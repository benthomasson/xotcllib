#Created at Thu Jul 05 11:50:50 -0400 2007 by ben using ::xox::Template

namespace eval ::xounit { 

    Class create Test -superclass { ::xotcl::Object }
          
    Test # Test {
        Test is the simplest possible test and base class for all 
        tests in xounit.  The simplest possible test does nothing.
        That is what Test does.  However it does provide a interface
        for Test subclasses to implement.  This allows the test
        runner to be ignorant of how the test runs, and can run
        multiple types of tests together in one batch.
    }
               
    Test parameter {
        
    } 
            
    
    Test # ?test { 
        Finds all test methods that are available on this Test.
    }
        
    Test instproc ?test { { prefix "" } } {
        return [ my ?methods "test$prefix" ]
    }
        
    
    Test # name { 
        Sets the name for the test.  If 
        no name is provided this method returns
        the name of the class.
    }
        
    Test instproc name { args } {
        if { [ llength $args ] == 0 } {

            if [ my exists name ] {

                return [ my set name ]
            }

            return [ my info class ]
        }

        return [ my set name [ lindex $args 0 ] ]
    }
        
    
    Test # newResult { 
        returns a new instances of TestResult.
        Override this method if you need to create
        a special TestResult subclass for your Test subclass.
    }
        
    Test instproc newResult { { parent "" } } {
        if { "" == "$parent" } {
            return [ TestResult new -name [ my name ] ]
        } else {
            return [ $parent createNewChild ::xounit::TestResult -name [ my name ] ]
        }
    }
        
    
    Test # run { 
        run is the method that will be called by test runners
        when they run this test.  This method is meant
        to be overridden by subclasses and provides no
        functionality by default.
    }
        
    Test instproc run { testResult } {
        
    }
        
    
    Test # runAlone { 
        runAlone creates a new TestResult from newResult,
        runs this test, and returns the result.  This
        is useful if you have created a Test instance
        and want to run the test without a test runner.
    }
        
    Test instproc runAlone {  } {
        set result [ my newResult ]
        my run $result
        return $result
    }
}


        
