
namespace eval ::server::test { 

Class create TestTestableServer -superclass { ::xounit::TestCase }
  
TestTestableServer @doc TestTestableServer {
Please describe TestTestableServer here.
}
       
TestTestableServer parameter {

} 
        

TestTestableServer @doc test { 
test does ...
}

TestTestableServer instproc notest {  } {
        set testable [ ::server::TestableServer new ]

        $testable processOneRound
}
}


