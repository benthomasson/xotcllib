
namespace eval ::server { 

::server::SingletonClass create Clock -superclass { ::xotcl::Object }
  
Clock @doc Clock {
Please describe Clock here.
}
    
Clock @doc last { }

Clock @doc listeners { }

Clock @doc tickTime { }
   
Clock parameter {
   {last}
   {listeners}
   {tickTime}

} 
        

Clock @doc addClockListener { 
addClockListener does ...
            listener -
}

Clock instproc addClockListener { listener } {
        my lappend listeners $listener
    
}


Clock @doc checkTick { 
checkTick does ...
}

Clock instproc checkTick {  } {
        if { [ clock clicks -milliseconds ] - [ my last ] > [ my tickTime ] } {

            my tick
            return 1
        }

        return 0
    
}


Clock @doc init { 
init does ...
}

Clock instproc init {  } {
        my last [ clock clicks -milliseconds ]
        my tickTime 1000

        my listeners ""
    
}


Clock @doc removeClockListener { 
removeClockListener does ...
            listener -
}

Clock instproc removeClockListener { listener } {
        my instvar listeners

        set index [ lsearch $listeners $listener ]

        if { $index != -1 } {

            set listeners [ lreplace $listeners $index $index ]
        }
    
}


Clock @doc tick { 
tick does ...
            number -
}

Clock instproc tick { { number "1" } } {
        for { set loop 0 } { $loop < $number } { incr loop } {

        my last [ clock clicks -milliseconds ]

        foreach listener [ my listeners ] {

            if [ catch {

                $listener tick

            } result ] { puts "Error [ self ] $result " }
        }

        }
    
}
}


