
namespace eval ::server { 

Class create NotFound -superclass { ::server::Application }
  
NotFound @doc NotFound {
Please describe NotFound here.
}
       
NotFound parameter {

} 
        

NotFound @doc initialLoad { 
initialLoad does ...
            response -
}

NotFound instproc initialLoad { response } {
        $response send404
    
}


NotFound @doc sendMessages { 
sendMessages does ...
}

NotFound instproc sendMessages {  } {
    
}
}


