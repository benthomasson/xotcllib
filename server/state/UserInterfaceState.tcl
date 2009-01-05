
namespace eval ::server::state { 

Class create UserInterfaceState -superclass { ::server::State }
  
UserInterfaceState @doc UserInterfaceState {
Please describe UserInterfaceState here.
}
  
UserInterfaceState instmixin add ::server::mixin::MessagePublisher 
     
UserInterfaceState parameter {

} 
        

UserInterfaceState @doc processCommand { 
processCommand does ...
            ui - 
            command -
}

UserInterfaceState instproc processCommand { ui command } {
        my processInput $ui state $command
        $ui publishMessage ""
    
}


UserInterfaceState @doc prompt { 
prompt does ...
            ui -
}

UserInterfaceState instproc prompt { ui } {
if {![::xotcl::self isnextcall]} {
error "Abstract method prompt  ui  called"} else {::xotcl::next}
}
}


