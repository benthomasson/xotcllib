
namespace eval ::xogrid { 

Class create IgnoreState -superclass { ::xogrid::ProtocolState }
  
IgnoreState @doc IgnoreState {
Please describe IgnoreState here.
}
       
IgnoreState parameter {

} 
      

IgnoreState @doc instance { 
instance does ...
}

IgnoreState proc instance {  } {
        ::xotcl::my singleton

        if { ! [ info exists singleton ] } {

            set singleton [ IgnoreState new ]
        }

        return $singleton
    
}
  

IgnoreState @doc advanceState { 
advanceState does ...
            clientConnection -
}

IgnoreState instproc advanceState { clientConnection } {
        return [ MultiplexState instance]
    
}


IgnoreState @doc doAction { 
doAction does ...
            clientConnection - 
            protocol -
}

IgnoreState instproc doAction { clientConnection protocol } {
    
        return
    
}
}


