
namespace eval ::xodocument { 

Class create NavLinkState -superclass { ::xotcl::Object }
  
NavLinkState @doc NavLinkState {
Please describe NavLinkState here.
}
       
NavLinkState parameter {

} 
        

NavLinkState @doc getLink { 
getLink does ...
            name - 
            link -
}

NavLinkState instproc getLink { name link } {
if {![::xotcl::self isnextcall]} {
error "Abstract method getLink  name link  called"} else {::xotcl::next}
}
}


