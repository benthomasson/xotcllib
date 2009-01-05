
namespace eval ::xogrid { 

Class create WorkerPool -superclass { ::xotcl::Object }
  
WorkerPool @doc WorkerPool {
Please describe WorkerPool here.
}
    
WorkerPool @doc startingPort { }

WorkerPool @doc nextPort { }

WorkerPool @doc workerExecutable { }

WorkerPool @doc maxWorkers { }

WorkerPool @doc workers { }

WorkerPool @doc availableWorkers { }
   
WorkerPool parameter {
   {startingPort}
   {nextPort}
   {workerExecutable}
   {maxWorkers}
   {workers}
   {availableWorkers}

} 
        

WorkerPool @doc borrowWorker { 
borrowWorker does ...
}

WorkerPool instproc borrowWorker {  } {
        set availableWorkers [ my availableWorkers ]
        if { [ llength $availableWorkers ] == 0 } {

            my startNewWorker
            set availableWorkers [ my availableWorkers ]
        }

        set port [ lindex $availableWorkers 0 ]
        set availableWorkers [ lrange $availableWorkers 1 end ]
        my availableWorkers $availableWorkers

        return $port
    
}


WorkerPool instproc destroy {  } {
        foreach port [ my array names pids ] {

            set pid [ my set pids($port) ]
            exec kill $pid
        }

        next
    
}


WorkerPool @doc init { 
init does ...
}

WorkerPool instproc init {  } {
        my startingPort 8000
        my nextPort [ my startingPort ]
        my workerExecutable "./worker"
        my maxWorkers 1

        my set availableWorkers {}
    
}


WorkerPool @doc returnWorker { 
returnWorker does ...
            port -
}

WorkerPool instproc returnWorker { port } {
        if { [ lsearch [ my array names pids ] $port ] == -1 } {

            error "Invalid port $port"
        }
    
        my lappend availableWorkers $port
    
}


WorkerPool @doc startNewWorker { 
startNewWorker does ...
}

WorkerPool instproc startNewWorker {  } {
        if { [ llength [ my array names pids ] ] >= [ my maxWorkers ] } {
            error "Already started max number of workers [ my maxWorkers ] "
        }

        set port [ my nextPort ]
        set pid [ exec [ my workerExecutable ] $port & ]
        my incr nextPort

        my set pids($port) $pid
        my lappend availableWorkers $port

        return $port
    
}
}


