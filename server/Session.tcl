
namespace eval ::server { 

Class create Session -superclass { ::xotcl::Object }
  
Session @doc Session {
Please describe Session here.
}
    
Session @doc id { }

Session @doc count { }
   
Session parameter {
   {id}
   {count}

} 
        

Session @doc getApplicationName { 
getApplicationName does ...
            request -
}

Session instproc getApplicationName { request } {
        set uri [ string trim [ $request uri ] ]
        set parts [ split $uri / ]
        return [ lindex $parts 1 ]
    
}


Session @doc getArgs { 
getArgs does ...
            request -
}

Session instproc getArgs { request } {
        set args [ string trim [ $request args ] ]
        set parts [ split $args & ]
        return $parts
    
}


Session @doc getMethodCall { 
getMethodCall does ...
            request -
}

Session instproc getMethodCall { request } {
        set args [ my getArgs $request ] 

        foreach arg $args {

            set parts [ split $arg = ]

            set name [ lindex $parts 0 ]
            set value [ lindex $parts 1 ]

            set argArray($name) $value
        }

        foreach name [ $request array names params ] {

           set argArray($name) [ $request set params($name) ]
        }

        if { ![ info exists argArray(method) ] } {

            set argArray(method) start
        }

        set methodCall "$argArray(method) "

        foreach name [ array names argArray ] {

            if { "$name" == "method" } {

                continue
            }

            append methodCall "-${name} $argArray(${name}) "
        }

        return $methodCall
    
}
}


