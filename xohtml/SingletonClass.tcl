
namespace eval ::xohtml { 

Class create SingletonClass -superclass { ::xotcl::Class }
  
SingletonClass @doc SingletonClass {
Please describe SingletonClass here.
}
    
SingletonClass @doc instance { }
   
SingletonClass parameter {
   {instance}
} 
        

SingletonClass @doc getInstance { 
getInstance does ...
            args -
}

SingletonClass instproc getInstance { args } {
        if {![ my exists instance ]} { 

            my instance [ eval my new $args ]
        }

        return [ my instance ]
}
}


