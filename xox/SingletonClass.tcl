
namespace eval ::xox { 

    Class create SingletonClass -superclass { ::xotcl::Class }
      
    SingletonClass @doc SingletonClass {
        SingletonClass is a meta-class that implements the Singleton Pattern.
    }
        
    SingletonClass @doc instance { }
       
    SingletonClass parameter {
       {instance}
    } 
            

    SingletonClass @doc getInstance { 
        Gets the singleton instance.  
    }

    SingletonClass @arg getInstance args { Initialization arguments for the singleton }

    SingletonClass instproc getInstance { args } {

            if {![ my exists instance ]} { 
                my instance [ eval my new $args ]
            }

            return [ my instance ]
    }
}


