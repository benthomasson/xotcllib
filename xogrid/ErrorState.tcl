
namespace eval ::xogrid { 

Class create ErrorState -superclass { ::xogrid::ProtocolState }
  
ErrorState @doc ErrorState {
Please describe ErrorState here.
}
       
ErrorState parameter {

} 
      

ErrorState @doc instance { 
instance does ...
}

ErrorState proc instance {  } {
        ::xotcl::my singleton

        if { ! [ info exists singleton ] } {

            set singleton [ ErrorState new ]
        }

        return $singleton
    
}
  

ErrorState @doc advanceState { 
advanceState does ...
            clientConnection -
}

ErrorState instproc advanceState { clientConnection } {
        return [ MultiplexState instance]
    
}


ErrorState @doc doAction { 
doAction does ...
            clientConnection - 
            protocol -
}

ErrorState instproc doAction { clientConnection protocol } {
        $protocol processError [$clientConnection id ] [ $clientConnection command ]
    
}
}


