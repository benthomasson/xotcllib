
namespace eval ::server { 

Class create Update -superclass { ::xotcl::Object }
  
Update @doc Update {
Please describe Update here.
}
    
Update @doc updateCommands { }

Update @doc updateIndex { }
   
Update parameter {
   {updateCommands}
   {updateIndex}

} 
        

Update @doc cancelAllCommands { 
cancelAllCommands does ...
}

Update instproc cancelAllCommands {  } {
        if { ! [ my exists updateCommands ] } { return }

        my unset updateCommands
    
}


Update @doc cancelCommand { 
cancelCommand does ...
            command - 
            index -
}

Update instproc cancelCommand { command index } {
        if { ! [ my exists updateCommands ] } { return }

        set index [ lsearch [ my updateCommands ] "$command $index" ]

        if { "$index" == "-1" } { return }

        my updateCommands [ lreplace [ my updateCommands ] $index $index ] 
    
}


Update @doc cancelFirstCommand { 
cancelFirstCommand does ...
            command -
}

Update instproc cancelFirstCommand { command } {
        if { ! [ my exists updateCommands ] } { return }

        set index [ lsearch -glob [ my updateCommands ] "$command*" ]

        if { "$index" == "-1" } { return }

        my updateCommands [ lreplace [ my updateCommands ] $index $index "" ] 
    
}


Update @doc runUpdate { 
runUpdate does ...
            args -
}

Update instproc runUpdate { args } {
        set commandIndex "$args"
        set command [ lrange $commandIndex 0 end-1 ]

        set index [ lsearch [ my updateCommands ] $commandIndex ]

        if { $index == -1 } { return }

        my updateCommands [ lreplace [ my updateCommands ] $index $index ]

        if { "" == "[ my updateCommands ]" } {

            my unset updateCommands
        }

        if { "" == "$command" } { return }

        if [ catch {

            eval "my $command"
        } ] {

            global errorInfo
            puts $errorInfo
        }

    
}


Update @doc runUpdateWithIndex { 
runUpdateWithIndex does ...
            args -
}

Update instproc runUpdateWithIndex { args } {
        set commandIndex "$args"

        set index [ lsearch [ my updateCommands ] $commandIndex ]

        if { $index == -1 } { return }

        my updateCommands [ lreplace [ my updateCommands ] $index $index ]

        if { "" == "[ my updateCommands ]" } {

            my unset updateCommands
        }

        if { "" == "$commandIndex" } { return }

        if [ catch {

            eval "my $commandIndex"
        } ] {

            global errorInfo
            puts $errorInfo
        }
    
}


Update @doc scheduleCommand { 
scheduleCommand does ...
            time - 
            command -
}

Update instproc scheduleCommand { time command } {
        if { ! [ my exists updateIndex ] } { my set updateIndex 0 }

        set index [ my incr updateIndex ]
        if { $index > 1000000 } { my set updateIndex 0 }

        my lappend updateCommands "$command $index"
        set scheduler [ ::server::Scheduler getInstance ]
        $scheduler scheduleCommand $time "[ self ] runUpdate $command $index"
        return $index
    
}


Update @doc scheduleCommandWithIndex { 
scheduleCommandWithIndex does ...
            time - 
            command -
}

Update instproc scheduleCommandWithIndex { time command } {
        if { ! [ my exists updateIndex ] } { my set updateIndex 0 }

        set index [ my incr updateIndex ]
        if { $index > 1000000 } { my set updateIndex 0 }

        my lappend updateCommands "$command $index"
        set scheduler [ ::server::Scheduler getInstance ]
        $scheduler scheduleCommand $time "[ self ] runUpdateWithIndex $command $index"
        return $index
    
}
}


