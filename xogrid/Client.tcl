
namespace eval ::xogrid { 

Class create Client -superclass { ::xogrid::Peer }
  
Client @doc Client {
Please describe Client here.
}
       
Client parameter {

} 
        

Client @doc connect { 
connect does ...
            newHost - 
            newPort -
}

Client instproc connect { newHost newPort } {
        ::xotcl::my instvar host port id

        set host $newHost
        set port $newPort

        set id [ socket $host $port ]

        ::xotcl::my connected $id

        puts "Connected"
    
}


Client @doc disconnect { 
disconnect does ...
}

Client instproc disconnect {  } {
        ::xotcl::my instvar id

        flush $id
        close $id
    
}


Client @doc init { 
init does ...
}

Client instproc init {  } {
        ::xotcl::next
    
}


Client @doc sendLine { 
sendLine does ...
            line -
}

Client instproc sendLine { line } {
        ::xotcl::my instvar id

        puts $id "$line"
        flush $id
    
}
}


