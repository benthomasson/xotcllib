
namespace eval ::server { 

Class create UserAuthentication -superclass { ::server::Authentication }
  
UserAuthentication @doc UserAuthentication {
Please describe UserAuthentication here.
}
       
UserAuthentication parameter {

} 
        

UserAuthentication @doc authenticated { 
authenticated does ...
            response -
}

UserAuthentication instproc authenticated { response } {
        set request [ $response request ]

        if [ $request exists Authorization ] {

            set code [ lindex [ $request set Authorization ] 1 ]
            set decode [ ::server::base64::decode "$code" ]

            #my debug $code
            #my debug $decode

            set user $::env(USER);
            set pass [ [ ::server::WebServer getInstance ] password ]

            return [ expr { "$user:$pass" == "$decode" } ]
        }

        return 0
    
}
}


