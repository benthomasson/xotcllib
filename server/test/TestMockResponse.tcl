
namespace eval ::server::test { 

Class create TestMockResponse -superclass { ::xounit::TestCase }
  
TestMockResponse @doc TestMockResponse {
Please describe TestMockResponse here.
}
       
TestMockResponse parameter {

} 
        

TestMockResponse instproc setUp {  } {
        #add set up code here
    
}


TestMockResponse instproc tearDown {  } {
        #add tear down code here
    
}


TestMockResponse @doc test { 
test does ...
}

TestMockResponse instproc test {  } {
        #implement test here
    
}
}


