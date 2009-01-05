
namespace eval ::xogrid { 

Class create Worker -superclass { ::xogrid::Server }
  
Worker @doc Worker {
Please describe Worker here.
}
       
Worker parameter {

} 
        

Worker @doc init { 
init does ...
}

Worker instproc init {  } {
        next

        my addReceiver [ ::xogrid::ExecuteReceiver new ]
    
}
}


