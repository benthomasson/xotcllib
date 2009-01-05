
namespace eval ::xogrid { 

Class create ReturnReceiver -superclass { ::xotcl::Object }
  
ReturnReceiver @doc ReturnReceiver {
Please describe ReturnReceiver here.
}
       
ReturnReceiver parameter {

} 
        

ReturnReceiver @doc receiveError { 
receiveError does ...
            error -
}

ReturnReceiver instproc receiveError { error } {
if {![::xotcl::self isnextcall]} {
error "Abstract method receiveError  error  called"} else {::xotcl::next}
}


ReturnReceiver @doc receiveReturn { 
receiveReturn does ...
            returnData -
}

ReturnReceiver instproc receiveReturn { returnData } {
if {![::xotcl::self isnextcall]} {
error "Abstract method receiveReturn  returnData  called"} else {::xotcl::next}
}
}


