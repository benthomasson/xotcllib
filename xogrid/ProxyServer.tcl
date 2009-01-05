
namespace eval ::xogrid { 

Class create ProxyServer -superclass { ::xotcl::Object }

ProxyServer @doc ProxyServer {
Please describe ProxyServer here.
}
    
ProxyServer @doc serverSocket { }

ProxyServer @doc object { }

ProxyServer @doc channels { }

ProxyServer @doc logFileName { }
   
ProxyServer parameter {
   {serverSocket}
   {object}
   {channels}
   { logFileName ProxyServer.log }
} 
        

ProxyServer @doc close { 
close does ...
}

ProxyServer instproc close {  } {
        my log "close"
        
        if [ my exists channels ] {
        foreach channel [ my channels ] {

            close $channel
        }
        }

        close [ my serverSocket ]
    
}


ProxyServer @doc connect { 
connect does ...
            channel - 
            address - 
            port -
}

ProxyServer instproc connect { channel address port } {
        my instvar logFile

        my log "connect $address $port"

        fconfigure $channel -blocking 0 
        my lappend channels $channel
    
}


ProxyServer @doc execute { 
execute does ...
            args -
}

ProxyServer instproc execute { args } {
        my log "execute $args"
        return [ eval "[ my object ] $args" ]
    
}


ProxyServer @doc init { 
init does ...
            serverPort -
}

ProxyServer instproc init { serverPort } {
        my log "ProxyServer init $serverPort"

        set done 0

        for { set loop 0 } { $loop < 10 } { incr loop } {

        catch {

            my serverSocket  [ socket -server "[ self ] connect" $serverPort ]
            set done 1
        }

        if { $done } { return }

        my log "Opening server socket on $serverPort failed. Retry #$loop in 1 second."
        
        after 1000

        }

        error "ProxyServer could not open server socket on $serverPort"
    
}

ProxyServer instproc getPort { } {

    my instvar serverSocket

    return [ lindex [ fconfigure $serverSocket -sockname ] 2 ]
}


ProxyServer @doc log { 
log does ...
            message -
}

ProxyServer instproc log { message } {
        my instvar logFileName
        set logFile [ open $logFileName a ]
        puts $logFile "[ clock format [ clock seconds ] ] $message"
        flush $logFile
        close $logFile
    
}


ProxyServer @doc updateClients { 
updateClients does ...
}

ProxyServer instproc updateClients {  } {

        update

        if { ! [ my exists channels ] } { return }

        my log "updateClients"

        foreach channel [ my channels ] {

            my log "channel: $channel"

            set command [ gets $channel ]

            my log "command: $command"
        
            if [ fblocked $channel ] { continue }
            if [ eof $channel ] { continue }

            while { ![ info complete $command ] } {

                append command "\n"
                append command [ gets $channel ]
            }

            my log "complete command: $command"

            if [ catch { 

                set return [ eval "my $command" ]
                set return "return {$return}"

            } return ] {

                global errorInfo
                set return "error {$return\n$errorInfo}"
            }

            my log "$channel [ list $return ]"
            puts $channel [ list $return ]
            flush $channel
        }
    
}
}


