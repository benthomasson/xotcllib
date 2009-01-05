
namespace eval ::xogrid { 

Class create ServerPool -superclass { ::xotcl::Object }
  
ServerPool @doc ServerPool {
Please describe ServerPool here.
}
       
ServerPool parameter {

} 
        

ServerPool @doc init { 
init does ...
            initialPoolSize -
}

ServerPool instproc init { { initialPoolSize "1" } } {
        ::xotcl::my instvar poolSize

        set poolSize $initialPoolSize

        for { set loop 0 } { $loop < $poolSize } { incr loop } {

            ::xotcl::my startServer
        }
    
}


ServerPool @doc startServer { 
startServer does ...
}

ServerPool instproc startServer {  } {
        ::xotcl::my instvar serverConnections 

#spawn a new tclsh running a new server.
#connect to the server to allow for management.
#save the ServerConnection in an array based on connection id
#return the ServerConnection object

    
}


ServerPool @doc stopServer { 
stopServer does ...
            serverConnection -
}

ServerPool instproc stopServer { serverConnection } {
        ::xotcl::my instvar serverConnections 
#send "exit" to the Server, killing it
#

    
}
}


