
namespace eval ::server { 

Class create DisplayMessage -superclass { ::xotcl::Object }
  
DisplayMessage @doc DisplayMessage {
Please describe DisplayMessage here.
}
    
DisplayMessage @doc channels { }
   
DisplayMessage parameter {
   { channels "" }

} 
        

DisplayMessage @doc addChannel { 
addChannel does ...
            channel -
}

DisplayMessage instproc addChannel { channel } {
        my lappend channels $channel
    
}


DisplayMessage @doc displayMessages { 
displayMessages does ...
            channel -
}

DisplayMessage instproc displayMessages { channel } {
        set messages [ my messages ]
        my messages ""

        if { "" == "$messages" } { return }

        set prompt [ my prompt ]

        puts -nonewline $channel $messages
        puts $channel ""
        puts -nonewline $channel "${prompt}"
        flush $channel
    
}


DisplayMessage @doc message { 
message does ...
            message -
}

DisplayMessage instproc message { message } {
        if { [ lsearch [ my channels ] [ self callingobject ] ] == -1 } {
            error "[self] is not listening on channel [ self callingobject ]"
        }
       
        my messages [ concat [ my messages ] $message ]
    
}


DisplayMessage @doc removeChannel { 
removeChannel does ...
            channel -
}

DisplayMessage instproc removeChannel { channel } {
        my instvar channels

        set index [ lsearch $channels $channel ]
        if { $index == -1 } { return }
        set channels [ lreplace $channels $index $index ]
    
}
}


