
namespace eval ::server { 

Class create Authentication -superclass { ::xotcl::Object }
  
Authentication @doc Authentication {
Please describe Authentication here.
}
       
Authentication parameter {

} 
        

Authentication @doc authenticated { 
authenticated does ...
            response -
}

Authentication instproc authenticated { response } {
        set request [ $response request ]

        if [ $request exists Authorization ] {

            set code [ lindex [ $request set Authorization ] 1 ]
            set decode [ ::server::base64::decode "$code" ]

            #my debug $code
            #my debug $decode

            return [ expr { "ben:pass" == "$decode" } ]
        }

        return 0
    
}


Authentication @doc execute { 
execute does ...
            method - 
            dashedArgs - 
            response - 
            otherArgs -
}

Authentication instproc execute { method dashedArgs response otherArgs } {
        if [ my authenticated $response ] {

            return [ next ]
        }

        $response send401 [ my web ] 
    
}
}


