
namespace eval ::xogrid { 

Class create ScriptReceiver -superclass { ::xogrid::Protocol ::xogrid::Peer }
  
ScriptReceiver @doc ScriptReceiver {
Please describe ScriptReceiver here.
}
    
ScriptReceiver @doc script { }
   
ScriptReceiver parameter {
   {script}

} 
        

ScriptReceiver @doc init { 
init does ...
}

ScriptReceiver instproc init {  } {
        ::xotcl::next --noArgs

        ::xotcl::my addReceiver [::xotcl::self]
    
}


ScriptReceiver @doc receiveScript { 
receiveScript does ...
}

ScriptReceiver instproc receiveScript {  } {
        ::xotcl::my script ""

        ::xotcl::my processConnections

        while { ![ info complete [::xotcl::my script ] ] } {

            ::xotcl::my processConnections
        }

        set fullScript [ join [::xotcl::my script ] ]

        regsub -all {\\\{} $fullScript "\{" fullScript
        regsub -all {\\\}} $fullScript "\}" fullScript

        return $fullScript

    
}
}


