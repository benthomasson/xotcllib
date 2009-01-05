
namespace eval ::xogrid { 

Class create ReturnState -superclass { ::xogrid::ProtocolState }
  
ReturnState @doc ReturnState {
Please describe ReturnState here.
}
       
ReturnState parameter {

} 
      

ReturnState @doc instance { 
instance does ...
}

ReturnState proc instance {  } {
        ::xotcl::my singleton

        if { ! [ info exists singleton ] } {

            set singleton [ ReturnState new ]
        }

        return $singleton
    
}
  

ReturnState @doc advanceState { 
advanceState does ...
            clientConnection -
}

ReturnState instproc advanceState { clientConnection } {
        return [ MultiplexState instance]
    
}


ReturnState @doc doAction { 
doAction does ...
            clientConnection - 
            protocol -
}

ReturnState instproc doAction { clientConnection protocol } {
        $protocol processReturn [$clientConnection id ] [ $clientConnection command ]
    
}
}


