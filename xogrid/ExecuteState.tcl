
namespace eval ::xogrid { 

Class create ExecuteState -superclass { ::xogrid::ProtocolState }
  
ExecuteState @doc ExecuteState {
Please describe ExecuteState here.
}
       
ExecuteState parameter {

} 
      

ExecuteState @doc instance { 
instance does ...
}

ExecuteState proc instance {  } {
        ::xotcl::my singleton

        if { ! [ info exists singleton ] } {

            set singleton [ ExecuteState new ]
        }

        return $singleton
    
}
  

ExecuteState @doc advanceState { 
advanceState does ...
            clientConnection -
}

ExecuteState instproc advanceState { clientConnection } {
        return [ MultiplexState instance]
    
}


ExecuteState @doc doAction { 
doAction does ...
            clientConnection - 
            protocol -
}

ExecuteState instproc doAction { clientConnection protocol } {
        $protocol processExecute [$clientConnection id ] [ $clientConnection command ]
    
}
}


