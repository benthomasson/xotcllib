
namespace eval ::xogrid { 

Class create Peer -superclass { ::xotcl::Object }
  
Peer @doc Peer {
Please describe Peer here.
}
       
Peer parameter {

} 
        

Peer @doc addReceiver { 
addReceiver does ...
            receiver -
}

Peer instproc addReceiver { receiver } {
        ::xotcl::my instvar receivers

        lappend receivers $receiver
    
}


Peer @doc connected { 
connected does ...
            id - 
            args -
}

Peer instproc connected { id args } {
        ::xotcl::my instvar awake receivers

        fconfigure $id -blocking 0

        fileevent $id readable [ list [::xotcl::self] notifyReceivers $id ]

        foreach receiver $receivers {

            $receiver newConnection $id 
        }
        
        set awake 1
        return
    
}


Peer @doc init { 
init does ...
}

Peer instproc init {  } {
        ::xotcl::my instvar receivers

        ::xotcl::next

        set receivers {}
    
}


Peer @doc notifyReceivers { 
notifyReceivers does ...
            id -
}

Peer instproc notifyReceivers { id } {
        ::xotcl::my instvar receivers awake

        set value [ gets $id ]

        foreach receiver $receivers {

            $receiver receiveLine $id $value
        }

        if { [eof $id ] } {

            close $id
            foreach receiver $receivers {

                $receiver closedConnection $id 
            }
        } 

        set awake 1
        return

    
}


Peer @doc processConnections { 
processConnections does ...
}

Peer instproc processConnections {  } {
        ::xotcl::my vwait awake
    
}


Peer @doc updateConnections { 
updateConnections does ...
}

Peer instproc updateConnections {  } {
        update
    
}
}


