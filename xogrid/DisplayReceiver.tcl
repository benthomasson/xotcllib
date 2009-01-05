
namespace eval ::xogrid { 

Class create DisplayReceiver -superclass { ::xogrid::Receiver }
  
DisplayReceiver @doc DisplayReceiver {
Please describe DisplayReceiver here.
}
       
DisplayReceiver parameter {

} 
        

DisplayReceiver @doc closedConnection { 
closedConnection does ...
            id -
}

DisplayReceiver instproc closedConnection { id } {
        return
    
}


DisplayReceiver @doc newConnection { 
newConnection does ...
            id -
}

DisplayReceiver instproc newConnection { id } {
        return
    
}


DisplayReceiver @doc receiveLine { 
receiveLine does ...
            id - 
            line -
}

DisplayReceiver instproc receiveLine { id line } {
        puts $line
    
}
}


