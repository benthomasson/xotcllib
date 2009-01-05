
namespace eval ::server { 

Class create MockResponse -superclass { ::server::Response ::xounit::Assert }
  
MockResponse @doc MockResponse {
Please describe the class MockResponse here.
}
    
MockResponse @doc expectedOutput { }
   
MockResponse parameter {
   { expectedOutput "" }

} 
        

MockResponse @doc assertExpectedOutput { 
assertExpectedOutput does ...
}

MockResponse instproc assertExpectedOutput {  } {
        my instvar out expectedOutput

        my assertEqualsByLine [ string trim $out ] $expectedOutput
    
}


MockResponse @doc send200 { 
send200 does ...
}

MockResponse instproc send200 {  } {
        my instvar out
        my debug $out

        my assertExpectedOutput
    
}


MockResponse @doc send404 { 
send404 does ...
}

MockResponse instproc send404 {  } {
        my instvar out
        my debug $out

        my assertExpectedOutput
    
}
}


