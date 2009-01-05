
namespace eval ::xox::test { 

Class create TestTclDoc -superclass { ::xounit::TestCase }

TestTclDoc id {$Id: TestTclDoc.tcl,v 1.1 2007/08/08 16:13:17 bthomass Exp $}
  
TestTclDoc @doc TestTclDoc {
::xox::test::TestTclDoc tests ::xox::TclDoc
}
       
TestTclDoc parameter {

}
}


