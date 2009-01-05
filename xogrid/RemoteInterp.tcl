
namespace eval ::xogrid { 

Class create RemoteInterp -superclass { ::xogrid::Protocol ::xogrid::Client }
  
RemoteInterp @doc RemoteInterp {
Please describe RemoteInterp here.
}
    
RemoteInterp @doc anError { }
   
RemoteInterp parameter {
   {anError}

} 
        

RemoteInterp @doc closedConnection { 
closedConnection does ...
            id -
}

RemoteInterp instproc closedConnection { id } {
        ::xotcl::next

        ::xotcl::my isConnected 0
    
}


RemoteInterp @doc init { 
init does ...
            host - 
            port -
}

RemoteInterp instproc init { host port } {
        ::xotcl::next --noArgs
        ::xotcl::my addReceiver [::xotcl::self]

        ::xotcl::my connect $host $port
        ::xotcl::my isConnected 1
    
}


RemoteInterp @doc processError { 
processError does ...
            id - 
            anError -
}

RemoteInterp instproc processError { id anError } {
        ::xotcl::my anError $anError
    
}


RemoteInterp @doc processExecute { 
processExecute does ...
            id - 
            script -
}

RemoteInterp instproc processExecute { id script } {
        ::xotcl::my sendError "Client does not implement {execute}"
    
}


RemoteInterp @doc processReturn { 
processReturn does ...
            id - 
            returnData -
}

RemoteInterp instproc processReturn { id returnData } {
        ::xotcl::my returnData $returnData
    
}


RemoteInterp @doc remoteEval { 
remoteEval does ...
            script -
}

RemoteInterp instproc remoteEval { script } {
        ::xotcl::my instvar id

        set script [ string trim $script ]

        ::xotcl::my sendExecute $id $script
        return [ ::xotcl::my waitForReturn ]
    
}


RemoteInterp @doc waitForReturn { 
waitForReturn does ...
}

RemoteInterp instproc waitForReturn {  } {
        while { 1 } {

            ::xotcl::my processConnections

            if [ ::xotcl::my exists returnData ] {

                set localReturnData [ ::xotcl::my returnData ]
                ::xotcl::my unset returnData
                return $localReturnData
            }

            if [ ::xotcl::my exists anError ] {

                set localAnError [ ::xotcl::my anError ]
                ::xotcl::my unset anError
                error $localAnError
            }
        }
    
}
}


