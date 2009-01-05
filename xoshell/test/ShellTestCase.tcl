
namespace eval ::xoshell::test { 

Class create ShellTestCase -superclass { ::xounit::TestCase }

ShellTestCase id {$Id: ShellTestCase.tcl,v 1.3 2008/10/20 16:24:00 bthomass Exp $}
  
ShellTestCase @doc ShellTestCase {
Please describe ShellTestCase here.
}
    
ShellTestCase @doc shell { }

ShellTestCase parameter {
   { shell }
} 

ShellTestCase instproc setUp {  } {

    my instvar shell objectInterp environment
}


ShellTestCase instproc tearDown {  } {
        #add tear down code here
    
}
}


