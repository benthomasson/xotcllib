
namespace eval ::xogrid { 

Class create Proxy -superclass { ::xotcl::Object }
  
Proxy @doc Proxy {
Please describe Proxy here.
}
    
Proxy @doc socket { }

Proxy @doc waitCallBack { }

Proxy @doc timeout { }
   
Proxy parameter {
   {socket}
   {waitCallBack}
   { timeout 10000 }

} 
        

Proxy @doc getLine { 
getLine does ...
}

Proxy instproc getLine {  } {
        my instvar timeout

        puts "start"

        set start [ clock clicks -milliseconds ]

        my instvar socket
        fconfigure $socket -blocking 0
        set return "" 

        while { "$return" == "" } {

            if [ my exists waitCallBack ] {
                puts "Calling [ my waitCallBack ]"

                eval "[ my waitCallBack ]"
            }
            set return [ gets $socket ]
            after 1

            set now [ clock clicks -milliseconds ]

            if { [ expr { $now - $start } ] > $timeout } {

                error "Proxy getLine timeout! ($timeout)"
            }
        }

        puts "return $return"

        return $return
    
}


Proxy @doc init { 
init does ...
            serverAddress - 
            serverPort - 
            waitCallBack -
}

Proxy instproc init { serverAddress serverPort { waitCallBack "" } } {
        puts "Proxy init $serverAddress $serverPort $waitCallBack"
        set done 0

        if { "" != "$waitCallBack" } {
            my waitCallBack $waitCallBack
        }

        for { set loop 0 } { $loop < 10 } { incr loop } {

        catch {

            puts "Proxy connecting $serverAddress $serverPort"
            my socket [ socket $serverAddress $serverPort ]
            set done 1
            puts "Proxy connected!"
        }

        if { $done } { return }

        puts "Opening socket to $serverAddress $serverPort failed. Retry #$loop in 1 second."
        
        after 1000

        }

        error "Proxy could not open server socket to $serverAddress $serverPort"


}


Proxy @doc proxyFilter { 
proxyFilter does ...
            args -
}

Proxy instproc proxyFilter { args } {
        puts "proxyFilter $args"

        if { "[ self calledproc ]" == "configure" } {

            return [ next ]
        }

        if { "[ self calledproc ]" == "init" } {

            return [ next ]
        }

        if { "[ self calledproc ]" == "destroy" } {

            return [ next ]
        }

        if { "[ self calledproc ]" == "waitCallBack" } {

            return [ next ]
        }

        if { "[ self calledproc ]" == "socket" } {

            return [ next ]
        }

        if { "[ self calledproc ]" == "timeout" } {

            return [ next ]
        }
        
        if { "[ self callingobject ]" == "[ self ]" } {

            return [ next ]
        }

        if { ![ my exists socket ] } { 

            return [ next ]
        }

        return [ my sendReceive "execute [ self calledproc ] $args" ]
    
}


Proxy @doc sendReceive { 
sendReceive does ...
            command -
}

Proxy instproc sendReceive { command } {
        my instvar socket
        fconfigure $socket -blocking 1 
        
        puts "sending $command"
        puts $socket $command
        flush $socket

        set message [ my getLine ]

        while { ![ info complete $message ] } {

            append message "\n"
            append message [ my getLine ]
        }
        
        set message [ join $message ]

        set command [ lindex $message 0 ]

        if { "$command" == "error" } {

            error [ lindex $message 1 ]
        }

        if { "$command" == "return" } {

            set message [ lindex $message 1 ]
        }

        return $message
    
}
 Proxy instfilter add proxyFilter
}


