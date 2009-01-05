
namespace eval ::xogrid { 

Class create Receiver -superclass { ::xotcl::Object }
  
Receiver @doc Receiver {
Please describe Receiver here.
}
       
Receiver parameter {

} 
        

Receiver @doc closedConnection { 
closedConnection does ...
            id -
}

Receiver instproc closedConnection { id } {
if {![::xotcl::self isnextcall]} {
error "Abstract method closedConnection  id  called"} else {::xotcl::next}
}


Receiver @doc newConnection { 
newConnection does ...
            id -
}

Receiver instproc newConnection { id } {
if {![::xotcl::self isnextcall]} {
error "Abstract method newConnection  id  called"} else {::xotcl::next}
}


Receiver @doc receiveLine { 
receiveLine does ...
            id - 
            line -
}

Receiver instproc receiveLine { id line } {
if {![::xotcl::self isnextcall]} {
error "Abstract method receiveLine  id line  called"} else {::xotcl::next}
}
}


