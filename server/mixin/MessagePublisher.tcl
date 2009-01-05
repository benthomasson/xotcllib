
namespace eval ::server::mixin { 

Class create MessagePublisher -superclass { ::xotcl::Object }
  
MessagePublisher @doc MessagePublisher {
Please describe MessagePublisher here.
}
    
MessagePublisher @doc messageListeners { }
   
MessagePublisher parameter {
   {messageListeners}

} 
        

MessagePublisher @doc addMessageListener { 
addMessageListener does ...
            listener -
}

MessagePublisher instproc addMessageListener { listener } {
        my instvar messageListeners

        if { ![ my exists messageListeners ] } {
            my messageListeners $listener 
            return
        }

        set index [ lsearch -exact $messageListeners $listener ]

        if { $index == -1 } {

            my lappend messageListeners $listener
        }
    
}


MessagePublisher @doc publishMessage { 
publishMessage does ...
            message -
}

MessagePublisher instproc publishMessage { message } {
        if { ![ my exists messageListeners ] } { return }

        foreach listener [ my messageListeners ] {

            if [ catch {

                $listener message "$message"
                
            } ] {
                
                my removeMessageListener $listener
            }
        }
    
}


MessagePublisher @doc removeMessageListener { 
removeMessageListener does ...
            listener -
}

MessagePublisher instproc removeMessageListener { listener } {
        my instvar messageListeners

        if { ![ my exists messageListeners ] } { return }

        set index [ lsearch -exact $messageListeners $listener ]

        if { $index != -1 } {

            set messageListeners [ lreplace $messageListeners $index $index ]
        }
    
}
}


