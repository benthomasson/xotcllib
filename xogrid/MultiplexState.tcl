
namespace eval ::xogrid { 

Class create MultiplexState -superclass { ::xogrid::ProtocolState }
  
MultiplexState @doc MultiplexState {
Please describe MultiplexState here.
}
       
MultiplexState parameter {

} 
      

MultiplexState @doc instance { 
instance does ...
}

MultiplexState proc instance {  } {
        ::xotcl::my singleton

        if { ! [ info exists singleton ] } {

            set singleton [ ::xogrid::MultiplexState new ]
        }

        return $singleton

    
}
  

MultiplexState @doc advanceState { 
advanceState does ...
            clientConnection -
}

MultiplexState instproc advanceState { clientConnection } {
        set command [ $clientConnection command ]

        if { "$command" == "execute" } {

            return [ ::xogrid::ExecuteState instance]

        } elseif { "$command" == "return" } {

            return [ ::xogrid::ReturnState instance]

        } elseif { "$command" == "error" } {

            return [ ::xogrid::ErrorState instance]

        } else {

            return [ ::xogrid::IgnoreState instance]
        }
    
}


MultiplexState @doc doAction { 
doAction does ...
            clientConnection - 
            protocol -
}

MultiplexState instproc doAction { clientConnection protocol } {
        return
    
}
}


