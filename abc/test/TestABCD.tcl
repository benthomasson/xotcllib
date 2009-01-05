
namespace eval ::abc::test { 

Class create TestABCD -superclass { ::xounit::TestCase }

TestABCD id {$Id: TestABCD.tcl,v 1.3 2008/08/18 18:47:44 bthomass Exp $}
  
TestABCD @doc TestABCD {
::abc::test::TestABCD tests ::abc::ABCD
}
       
TestABCD parameter {

} 
        

TestABCD @doc testNonPosMethod { 
testNonPosMethod does ...
}

TestABCD instproc testNonPosMethod {  } {
                    my fail "Please implement me"
                
}


TestABCD @doc testOtherMethod { 
testOtherMethod does ...
}

TestABCD instproc testOtherMethod {  } {
                    my fail "Please implement me"
                
}


TestABCD @doc testSomeMethod { 
testSomeMethod does ...
}

TestABCD instproc testSomeMethod {  } {
                    my fail "Please implement me"
                
}
}


