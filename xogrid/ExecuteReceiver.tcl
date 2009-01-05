
namespace eval ::xogrid { 

Class create ExecuteReceiver -superclass { ::xogrid::Protocol }
  
ExecuteReceiver @doc ExecuteReceiver {
Please describe ExecuteReceiver here.
}
       
ExecuteReceiver parameter {

} 
        

ExecuteReceiver @doc init { 
init does ...
}

ExecuteReceiver instproc init {  } {
        ::xotcl::next
    
}


ExecuteReceiver @doc processExecute { 
processExecute does ...
            id - 
            script -
}

ExecuteReceiver instproc processExecute { id script } {
        ::xotcl::my instvar clients

        set client $clients($id)

        if [ catch { [$client interp] eval "$script" } result ] {

            ::xotcl::my sendError $id $result

        } else {

            ::xotcl::my sendReturn $id $result
        }
    
}
}


