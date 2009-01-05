
namespace eval ::xogrid { 

Class create LocalProxy -superclass { ::xotcl::Object }
  
LocalProxy @doc LocalProxy {
Please describe LocalProxy here.
}
    
LocalProxy @doc object { }
   
LocalProxy parameter {
   {object}

} 
        

LocalProxy @doc init { 
init does ...
            object -
}

LocalProxy instproc init { object } {
        my object $object
    
}


LocalProxy @doc proxyFilter { 
proxyFilter does ...
            args -
}

LocalProxy instproc proxyFilter { args } {
        if { "[ self calledproc]" == "configure" } {

            return [ next ]
        }

        if { "[ self calledproc]" == "init" } {

            return [ next ]
        }
        
        if { "[ self callingobject]" == "[ self ]" } {

            return [ next ]
        }

        return [ eval "[ my object ] [ self calledproc ] $args" ]
    
}

LocalProxy instfilter add proxyFilter
}


