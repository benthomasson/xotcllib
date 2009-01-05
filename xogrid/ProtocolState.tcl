
namespace eval ::xogrid { 

Class create ProtocolState -superclass { ::xotcl::Object }
  
ProtocolState @doc ProtocolState {
Please describe ProtocolState here.
}
       
ProtocolState parameter {

} 
        

ProtocolState @doc advanceState { 
advanceState does ...
            clientConnection -
}

ProtocolState instproc advanceState { clientConnection } {
if {![::xotcl::self isnextcall]} {
error "Abstract method advanceState  clientConnection  called"} else {::xotcl::next}
}


ProtocolState @doc doAction { 
doAction does ...
            clientConnection - 
            protocol -
}

ProtocolState instproc doAction { clientConnection protocol } {
if {![::xotcl::self isnextcall]} {
error "Abstract method doAction  clientConnection protocol  called"} else {::xotcl::next}
}
}


