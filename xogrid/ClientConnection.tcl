
namespace eval ::xogrid { 

Class create ClientConnection -superclass { ::xotcl::Object }
  
ClientConnection @doc ClientConnection {
Please describe ClientConnection here.
}
    
ClientConnection @doc interp { }
   
ClientConnection parameter {
   {interp}

} 
        

ClientConnection @doc advanceState { 
advanceState does ...
}

ClientConnection instproc advanceState {  } {
        ::xotcl::my instvar state

        set state [ $state advanceState [ ::xotcl::self ] ]
    
}


ClientConnection @doc doStateAction { 
doStateAction does ...
            protocol -
}

ClientConnection instproc doStateAction { protocol } {
        ::xotcl::my instvar state

        $state doAction [ ::xotcl::self ] $protocol
    
}


ClientConnection @doc init { 
init does ...
            newId -
}

ClientConnection instproc init { newId } {
        ::xotcl::my instvar command interp state id

        set id $newId
        set state [ MultiplexState instance ]
        set command ""
        set interp [ interp create ]
    
}
}


