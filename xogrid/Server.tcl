
namespace eval ::xogrid { 

Class create Server -superclass { ::xogrid::Peer }
  
Server @doc Server {
Please describe Server here.
}
       
Server parameter {

} 
        

Server @doc enterEventLoop { 
enterEventLoop does ...
}

Server instproc enterEventLoop {  } {
        ::xotcl::my instvar shutdown

        while { !$shutdown } {

            ::xotcl::my processConnections
        }
    
}


Server @doc init { 
init does ...
}

Server instproc init {  } {
        ::xotcl::my instvar id ipAddress ipMask port shutdown

        ::xotcl::next

        set id 0
        set ipAddress 0.0.0.0
        set ipMask 0.0.0.0
        set port 0

        set shutdown 0
    
}


Server @doc shutdown { 
shutdown does ...
}

Server instproc shutdown {  } {
        ::xotcl::my instvar shutdown id

        set shutdown 1

        if { $id != 0 } {

            close $id
            set id 0
        }
    
}


Server @doc start { 
start does ...
            port -
}

Server instproc start { port } {
        ::xotcl::my startOnly $port

        ::xotcl::my enterEventLoop
    
}


Server @doc startOnly { 
startOnly does ...
            newPort -
}

Server instproc startOnly { newPort } {
        ::xotcl::my instvar id ipAddress ipMask port shutdown

        set id [ socket -server {[::xotcl::self] connected} $newPort ]

        set address [ fconfigure $id -sockname ]

        set ipAddress [ lindex $address 0 ]
        set ipMask [ lindex $address 1 ]
        set port [ lindex $address 2 ]

        set shutdown 0

        puts "Started"
    
}
}


