
namespace eval ::server { 

::server::SingletonClass create ServerException -superclass { ::xotcl::Object }
  
ServerException @doc ServerException {
Please describe ServerException here.
}
    
ServerException @doc message { }
   
ServerException parameter {
   {message}

} 
      

ServerException @doc new { 
new does ...
            message -
}

ServerException proc new { message } {
        set instance [ my getInstance ]

        $instance message $message

        return $instance
    
}
}


