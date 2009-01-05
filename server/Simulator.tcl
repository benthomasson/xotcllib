
namespace eval ::server { 

::server::SingletonClass create Simulator -superclass { ::xotcl::Object }
  
Simulator @doc Simulator {
Please describe Simulator here.
}
    
Simulator @doc commands { }

Simulator @doc maxRunTime { }
   
Simulator parameter {
   {commands}
   { maxRunTime 1000 }

} 
        

Simulator @doc init { 
init does ...
}

Simulator instproc init {  } {
        my commands ""
    
}


Simulator @doc queueCommand { 
queueCommand does ...
            command -
}

Simulator instproc queueCommand { command } {
        my lappend commands $command
    
}


Simulator @doc queueCommands { 
queueCommands does ...
            commands -
}

Simulator instproc queueCommands { commands } {
        eval "my lappend commands $commands"
    
}


Simulator @doc runACommand { 
runACommand does ...
            command -
}

Simulator instproc runACommand { command } {
        if [ catch {

            set result [ eval "$command" ]

        } result ] {
            
            puts "Error [ self ] $result " 

        } else {

            return $result
        }

        return -1
    
}


Simulator @doc runCommands { 
runCommands does ...
}

Simulator instproc runCommands {  } {
        my instvar commands

        set start [ clock clicks -milliseconds ] 

        while { ( [ clock clicks -milliseconds ] - $start ) < [ my maxRunTime ] } {

            if { [ llength $commands ] == 0 } { break }
            set command [ lindex $commands 0 ]
            set commands [ lrange $commands 1 end ]

            my runACommand $command
        }
    
}


Simulator @doc tick { 
tick does ...
}

Simulator instproc tick {  } {
        foreach command [ my commands ] {

            my runACommand $command
        }

        my commands ""
    
}
}


