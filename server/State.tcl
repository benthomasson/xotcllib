
namespace eval ::server { 

Class create State -superclass { ::xotcl::Object }
  
State @doc State {
Please describe State here.
}
       
State parameter {

} 
        

State @doc acceptInput { 
acceptInput does ...
            stateHolder - 
            command -
}

State instproc acceptInput { stateHolder command } {
if {![::xotcl::self isnextcall]} {
error "Abstract method acceptInput  stateHolder command  called"} else {::xotcl::next}
}


State @doc processInput { 
processInput does ...
            stateHolder - 
            stateVariable - 
            input -
}

State instproc processInput { stateHolder stateVariable input } {
       set state [ my acceptInput $stateHolder $input ]

       if { "" == "$state" } { return }
        
       $stateHolder set $stateVariable $state
       $state start $stateHolder
    
}


State @doc start { 
start does ...
            stateHolder -
}

State instproc start { stateHolder } {
    
}
}


