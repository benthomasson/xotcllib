
namespace eval ::abc { 

Class create ABCD -superclass { ::xox::Node }

ABCD id {$Id: $}
  
ABCD @doc ABCD {
Please describe ABCD here.
}
  
ABCD instmixin add ::xox::Logging 
  
ABCD @doc a { }

ABCD @doc b { }

ABCD @doc c { }
   
ABCD parameter {
   {a 5}
   {b}
   {c "d"}

} 
  
ABCD parametercmd yada
    

ABCD @doc classProc { 
classProc does ...
            something -
}

ABCD proc classProc { { something "default" } } {
set a 5
        
}
  

ABCD @doc nonPosMethod { 
nonPosMethod does ...
}

ABCD instproc nonPosMethod { -abc {-def xyz} } {  } {
#yada
        
}


ABCD @doc otherMethod { 
otherMethod does ...
            arg - 
            other -
}

ABCD instproc otherMethod { { arg "default" } { other "" } } {
#body
        
}


ABCD @doc someMethod { 
someMethod does ...
            someArg -
}

ABCD instproc someMethod { someArg } {
            variable nsA 

            return $nsA
        
}
}


