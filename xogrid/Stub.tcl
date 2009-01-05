
namespace eval ::xogrid { 

Class create Stub -superclass { ::xotcl::Object }
  
Stub @doc Stub {
Please describe Stub here.
}
    
Stub @doc object { }
   
Stub parameter {
   {object}

} 
        

Stub @doc init { 
init does ...
            object -
}

Stub instproc init { object } {
        my object $object
    
}


Stub @doc proxyFilter { 
proxyFilter does ...
            args -
}

Stub instproc proxyFilter { args } {
        if { "[ self calledproc ]" == "configure" } {

            return [ next ]
        }

        if { "[ self calledproc ]" == "init" } {

            return [ next ]
        }
        
        if { "[ self callingobject ]" == "[ self ]" } {

            return [ next ]
        }

        return [ eval "{[ my object ]} [ self calledproc ] $args" ]
    
}

Stub instfilter add proxyFilter
}


