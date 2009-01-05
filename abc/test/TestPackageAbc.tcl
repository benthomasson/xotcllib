
namespace eval ::abc::test { 

Class create TestPackageAbc -superclass { ::xounit::TestCase }

TestPackageAbc id {$Id: TestPackageAbc.tcl,v 1.3 2008/08/18 18:47:44 bthomass Exp $}
  
TestPackageAbc @doc TestPackageAbc {
::abc::test::TestPackageAbc tests the package ::abc
}
       
TestPackageAbc parameter {

} 
        

TestPackageAbc @doc testNsProc { 
testNsProc does ...
}

TestPackageAbc instproc testNsProc {  } {
                    my fail "Please implement me"
                
}
}


