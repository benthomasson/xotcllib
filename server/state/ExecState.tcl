
namespace eval ::server::state { 

::server::SingletonClass create ExecState -superclass { ::server::state::UserInterfaceState }
  
ExecState @doc ExecState {
Please describe ExecState here.
}
       
ExecState parameter {

} 
        

ExecState @doc acceptInput { 
acceptInput does ...
            ui - 
            command -
}

ExecState instproc acceptInput { ui command } {
        $ui processCommand $command

        return 
    
}


ExecState @doc prompt { 
prompt does ...
            ui -
}

ExecState instproc prompt { ui } {
        return "[ $ui name ]>" 
    
}


ExecState @doc start { 
start does ...
            ui -
}

ExecState instproc start { ui } {
        puts start

        $ui publishMessage "Server v0.0"
    
}
}


