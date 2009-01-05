#Created at Thu Jul 05 11:50:50 -0400 2007 by ben using ::xox::Template

namespace eval ::xounit::test { 

    Class create TestTest -superclass { ::xounit::TestCase }
          
    TestTest # TestTest {
        Please describe the class TestTest here.
    }
               
    TestTest parameter {
        
    } 
            
    
    TestTest # test { 
        Test does ...
    }
        
    TestTest instproc test {  } {
        set test [ ::xounit::Test new ]

        my assertEquals [ $test name ] ::xounit::Test

        set result [ $test newResult ]
        my assertEquals [ $result info class ] ::xounit::TestResult

        set result2 [ $test runAlone ]
        my assertEquals [ $result2 info class ] ::xounit::TestResult
        my assertNotEquals $result $result2
    }
        
    
    TestTest # test?test { 
        Test?test does ...
    }
        
    TestTest instproc test?test {  } {
        my ?test
    }
        
    
    TestTest # testName { 
        TestName does ...
    }
        
    TestTest instproc testName {  } {
        my assertEquals [ my name ] "::xounit::test::TestTest"
    }
        
    
    TestTest # testNewResult { 
        TestNewResult does ...
    }
        
    TestTest instproc testNewResult {  } {
        my assertEquals [  [ my newResult ] info class ]  ::xounit::TestResult
    }
        
    
    TestTest # testReload { 
        TestReload does ...
    }
        
    TestTest instproc testReload {  } {
        #not sure how to do this automatically
        #so manually channge the code after you've
        #started the continuous test and check for 
        #the test runner picking up the change.

        #my fail ack
    }
        
    
    TestTest # testRun { 
        TestRun does ...
    }
        
    TestTest instproc testRun {  } {
        set test [ ::xounit::Test new ]
        $test run [ ::xounit::TestResult new ]
    }
        
    
    TestTest # testRunAlone { 
        TestRunAlone does ...
    }
        
    TestTest instproc testRunAlone {  } {
        set test [ ::xounit::Test new ]
        $test runAlone
    }
}


        
