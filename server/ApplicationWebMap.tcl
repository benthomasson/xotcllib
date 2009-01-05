
namespace eval ::server { 

::server::SingletonClass create ApplicationWebMap -superclass { ::xox::Node }
  
ApplicationWebMap @doc ApplicationWebMap {
Please describe ApplicationWebMap here.
}
    
ApplicationWebMap @doc default { }

ApplicationWebMap @doc root { }
   
ApplicationWebMap parameter {
   { default ::server:NotFound }
   { root ::server:IndexApplication }

} 
        

ApplicationWebMap @doc application { 
application does ...
            web -
}

ApplicationWebMap instproc application { web } {
        my debug $web

        if { "/" == "$web" } {

            return [ my root ]
        }

        my debug "[ string range $web 0 0 ]" 
        if { "[ string range $web 0 0 ]" == "/" } {

            set web [ string range $web 1 end ]
        }

        my debug $web

        if [ my exists $web ] {

            return [ my set $web ]
        }

        my debug default

        return [ my default ]
    
}
}


