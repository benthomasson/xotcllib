
namespace eval ::server { 

Class create Tick -superclass { ::xotcl::Object }
  
Tick @doc Tick {
Please describe Tick here.
}
    
Tick @doc current { }

Tick @doc subTime { }
   
Tick parameter {
   {current}
   {subTime}

} 
        

Tick @doc init { 
init does ...
}

Tick instproc init {  } {
        my current 0
    
}


Tick @doc scheduleCommand { 
scheduleCommand does ...
            time - 
            command -
}

Tick instproc scheduleCommand { time command } {
        set slot [ expr $time/[ my subTime ] ]
        if { $slot > 9 } { error "Unsupported time range" }

        set time [ expr $time % ( [ my subTime ] / 10 ) ]

        set slot [ expr ( $slot + [ my current ] ) % 10 ]

        my lappend slot($slot) "$time {$command}"
    
}


Tick @doc updateTimesAndGetReadyCommands { 
updateTimesAndGetReadyCommands does ...
}

Tick instproc updateTimesAndGetReadyCommands {  } {
        set current [ my current ] 

        set timeCommands ""

        if [ my exists slot($current) ] {

            set timeCommands [ my set slot($current)  ]
        }

        my set slot($current) ""

        my current [ expr ( $current + 1 ) % 10 ]

        return $timeCommands
    
}
}


