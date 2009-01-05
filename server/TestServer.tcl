
namespace eval ::server { 

Class create TestServer -superclass { ::server::Application ::xounit::TestRunner }
  
TestServer @doc TestServer {
Please describe TestServer here.
}
  
TestServer instmixin add ::xounit::TestResultsTextFormatter 
  
TestServer @doc scheduler { }
   
TestServer parameter {
   {scheduler}

} 
        

TestServer @doc after { 
after does ...
            time - 
            class -
}

TestServer instproc after { time class } {
         set waitTime [ clock scan $time -base 0 ] 
         my . scheduler . scheduleCommand $waitTime "[ self ] run $class"
    
}


TestServer @doc at { 
at does ...
            time - 
            class -
}

TestServer instproc at { time class } {
         set waitTime [ expr [ clock scan $time ] - [ clock seconds ] ]
         my . scheduler . scheduleCommand $waitTime "[ self ] run $class"
    
}


TestServer @doc getTextResults { 
getTextResults does ...
}

TestServer instproc getTextResults {  } {
        return [ my formatResults [ my results ] ]
    
}


TestServer @doc init { 
init does ...
}

TestServer instproc init {  } {
        my scheduler [ Scheduler getInstance ]
    
}


TestServer @doc name { 
name does ...
}

TestServer instproc name {  } {
        return [ my info class ]
    
}


TestServer @doc run { 
run does ...
            class -
}

TestServer instproc run { class } {
         my runTests $class
    
}
}


