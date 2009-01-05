#Created by ben using ::xox::Template
 
package require xox
::xox::Package create ::abc
::abc id {$Id: abc.tcl,v 1.2 2008/02/15 00:22:18 bthomass Exp $}
::abc @doc abc {
Please describe abc here.
}
::abc @doc UsersGuide {

}
::abc requires {
    
}
::abc imports {
    ::xoexception::*
}
::abc loadFirst {
    
}
::abc executables {
    
}
namespace eval ::abc {
    variable nsA 5
    variable nsB {}
    variable nsC 7
    variable nsD {value with spaces}
    variable nsE
    set nsE(a) 1
    set nsE(b) 2
}
::abc @doc nsProc { 
nsProc does ...
                arg -
}

proc ::abc::nsProc { arg } {
                    puts "doing something"
            
}
::abc loadAll


