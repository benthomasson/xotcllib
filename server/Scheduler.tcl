
namespace eval ::server { 

::server::SingletonClass create Scheduler -superclass { ::xotcl::Object }
  
Scheduler @doc Scheduler {
Please describe Scheduler here.
}
    
Scheduler @doc current { }

Scheduler @doc simulator { }
   
Scheduler parameter {
   {current}
   {simulator}

} 
      

Scheduler @doc scheduleCommand { 
scheduleCommand does ...
            time - 
            command -
}

Scheduler proc scheduleCommand { time command } {
        [ my getInstance ] scheduleCommand $time $command
    
}
  

Scheduler @doc init { 
init does ...
}

Scheduler instproc init {  } {
        my simulator [ Simulator getInstance ]

        my current 0
        
        for { set loop 0 } { $loop < 10 } { incr loop } {

            my set ones($loop) [ Tick new -subTime 10 ]
        }

        for { set loop 0 } { $loop < 10 } { incr loop } {

            my set hundreds($loop) [ Tick new -subTime 1000 ]
        }

        for { set loop 0 } { $loop < 10 } { incr loop } {

            my set tenthousands($loop) [ Tick new -subTime 100000 ]
        }
    
}


Scheduler @doc runAndRepeat { 
runAndRepeat does ...
            time - 
            command -
}

Scheduler instproc runAndRepeat { time command } {
        catch {

            eval "$command"
            my scheduleCommand $time "[ self ] runAndRepeat $time {$command}"
        }
    
}


Scheduler @doc scheduleCommand { 
scheduleCommand does ...
            time - 
            command -
}

Scheduler instproc scheduleCommand { time command } {
        if { $time < 100 } {

            set index [ expr ( $time + [ my current ] ) % 10 ]

            [ my set ones($index) ] scheduleCommand $time $command

            return
        }

        if { $time < 10000 } {

            set index [ expr (($time + [ my current ])/100) % 10 ]

            [ my set hundreds($index) ] scheduleCommand $time $command

            return
        }

        if { $time < 1000000 } {

            set index [ expr (($time + [ my current ])/10000) % 10 ]

            [ my set tenthousands($index) ] scheduleCommand $time $command

            return
        }

        error "Time not supported: $time"
    
}


Scheduler @doc tick { 
tick does ...
}

Scheduler instproc tick {  } {
        set commands [ my updateTimesAndGetReadyCommands ]

        [ my simulator ] queueCommands $commands
    
}


Scheduler @doc updateTimesAndGetReadyCommands { 
updateTimesAndGetReadyCommands does ...
}

Scheduler instproc updateTimesAndGetReadyCommands {  } {
        set current [ my current ]

        set commands ""

        #if { [ expr $current % 1 ] == 0 }  Always

        foreach timeCmd [ [ my set ones([ expr $current % 10 ]) ] updateTimesAndGetReadyCommands ] {

            lappend commands [ lindex $timeCmd 1 ]
        }

        if { [ expr $current % 100 ] == 0 } {

            set timeCmds [ [ my set hundreds([ expr ($current/100) % 10 ]) ] updateTimesAndGetReadyCommands ] 

            foreach timeCmd $timeCmds {

                my scheduleCommand [ lindex $timeCmd 0 ] [ lindex $timeCmd 1 ]
            }
        }
        
        my set current [ expr $current +1 % 1000000000 ]

        return $commands
    
}
}


