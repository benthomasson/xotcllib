
namespace eval ::xogrid { 

Class create NonBlockingRemoteInterp -superclass { ::xogrid::RemoteInterp }
  
NonBlockingRemoteInterp @doc NonBlockingRemoteInterp {
Please describe NonBlockingRemoteInterp here.
}
    
NonBlockingRemoteInterp @doc returnReceiver { }
   
NonBlockingRemoteInterp parameter {
   {returnReceiver}

} 
        

NonBlockingRemoteInterp @doc init { 
init does ...
            host - 
            port - 
            returnReceiver -
}

NonBlockingRemoteInterp instproc init { host port returnReceiver } {
        ::xotcl::next $host $port

        ::xotcl::my returnReceiver $returnReceiver
    
}


NonBlockingRemoteInterp @doc processError { 
processError does ...
            id - 
            anError -
}

NonBlockingRemoteInterp instproc processError { id anError } {
        [ ::xotcl::my returnReceiver ] receiveError $anError
    
}


NonBlockingRemoteInterp @doc processReturn { 
processReturn does ...
            id - 
            returnData -
}

NonBlockingRemoteInterp instproc processReturn { id returnData } {
        [ ::xotcl::my returnReceiver ] receiveReturn $returnData
    
}


NonBlockingRemoteInterp @doc remoteEval { 
remoteEval does ...
            script -
}

NonBlockingRemoteInterp instproc remoteEval { script } {
        ::xotcl::my instvar id

        set currentCommand ""

        set script [ string trim $script ]

        ::xotcl::my sendExecute $id $script

        return 
    
}
}


