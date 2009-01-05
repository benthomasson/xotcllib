
namespace eval ::server { 

Class create UserInterface -superclass { ::server::CommandInterface }
  
UserInterface @doc UserInterface {
Please describe UserInterface here.
}
  
UserInterface instmixin add ::server::DisplayMessage 
  
UserInterface @doc messages { }
   
UserInterface parameter {
   {messages}

} 
        

UserInterface @doc close { 
close does ...
}

UserInterface instproc close {  } {
if {![::xotcl::self isnextcall]} {
error "Abstract method close   called"} else {::xotcl::next}
}


UserInterface @doc init { 
init does ...
}

UserInterface instproc init {  } {
        my messages ""
    
}
}


