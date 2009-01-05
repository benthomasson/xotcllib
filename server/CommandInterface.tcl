
namespace eval ::server { 

Class create CommandInterface -superclass { ::xotcl::Object }
  
CommandInterface @doc CommandInterface {
Please describe CommandInterface here.
}
       
CommandInterface parameter {

} 
        

CommandInterface @doc runACommand { 
runACommand does ...
            command -
}

CommandInterface instproc runACommand { command } {
        return [ eval "$command" ]
    
}
}


