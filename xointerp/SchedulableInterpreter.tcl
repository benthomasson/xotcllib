# Created at Sun Jan 06 16:24:11 EST 2008 by bthomass

namespace eval ::xointerp {

    Class SchedulableInterpreter -superclass ::xointerp::TclInterpreter

    SchedulableInterpreter # SchedulableInterpreter {

        Please describe the class SchedulableInterpreter here.
    }

    SchedulableInterpreter parameter {
        { childClass ::xointerp::SchedulableInterpreter }
        environment
        library
        { commands "" }
        { scheduler ::xointerp::nullScheduler }
        { blocked 0 }
        { return "" }
        { useGlobalProc {set lappend} }
    }

    SchedulableInterpreter instproc evalCommand { level command inString  } {

        my instvar environment scheduler childClass library

        if { ! [ my exists library ] } {
            #set library $environment
        }

        set newCommand [ string trim [ my evalSubCommands $level $command $inString ]  ]

        if { "$newCommand" == "" } { return }

        set commandName [ lindex $newCommand 0 ]

        set child [ my makeChild ]

        if { [ lsearch -exact [ $library interpretableProcs ] $commandName ] != -1 } {
            set length [ string length $commandName ]
            set newCommand "$commandName $child [ string range $newCommand $length end]"
        } else {
            $child destroy
        }

        if { [ lsearch -exact [ my useGlobalProc ] $commandName ] != -1 } {
            #do nothing
        } elseif { "[ $library info methods $commandName ]" == "$commandName" } {
            set newCommand "$library $newCommand"
        }

        set return [ $environment eval $newCommand ]

        if [ my isobject $child ] {

            $child destroy
        }

        #puts "return from $newCommand: $return"

        return $return
    }

    SchedulableInterpreter instproc makeChild { } {

        my instvar environment scheduler childClass library

        return [ $childClass new -childof [ self ] -environment $environment -scheduler $scheduler -library $library ]
    }

    SchedulableInterpreter instproc evalSubCommand { level command { inString 0 } } {

        my instvar environment childClass scheduler blocked

        return [ my evalCommand $level $command $inString ]

        #set blocked 1

        #set child [ $childClass new -childof [ self ] -environment $environment -scheduler $scheduler ]
        #set return [ $child tclEval $command ]
        #$child destroy

        #set blocked 0

        #return $return
    }

    SchedulableInterpreter instproc schedule { script } {

        my instvar commands
        set commands [ split $script "\n" ]
    }

    SchedulableInterpreter instproc tclEvalLevel { level script } {

        return [ my tclEval $script ]
    }

    SchedulableInterpreter instproc tclEval { script } {

        my instvar commands scheduler return

        set return ""
        set commands [ split $script "\n" ]

        while { [ my hasNextCommand ] } {

            my evalOneCommand
            $scheduler callBack [ self ]
        }

        return $return
    }

    SchedulableInterpreter instproc hasNextCommand { } {
        
        my instvar commands
        
        if { "" != "[ my info children ]" } { return 1 }

        if { "" == "[ string trim [ my nextCommand ] ]" } { return 0 }

        return 1
    }

    SchedulableInterpreter instproc nextCommand { } {
        
        my instvar commands

        set commandCommands [ my getCompleteCommand $commands ]
        set command [ string trim [ lindex $commandCommands 0 ] ]
        set newCommands [ lindex $commandCommands 1 ] 

        if { "$command" != "" } { return $command }

        while { "$command" == "" } {

            if { "$newCommands" == "" } { return "" }

            set commandCommands [ my getCompleteCommand $newCommands ]
            set command [ string trim [ lindex $commandCommands 0 ] ]
            set newCommands [ lindex $commandCommands 1 ]
        }
        return $command
    }

    SchedulableInterpreter instproc evalOneCommand { } {

        my instvar commands blocked return

        if { "[ my info children ]" != "" } { 

            #puts "evalOneCommand executing children"

            foreach child [ my info children ] {

                $child evalOneCommand
            }

            #puts "evalOneCommand executed children"
            
            return 
        }

        set command ""

        while { "$command" == "" } {

            if { ! [ my hasNextCommand ] } { return }

            set commandCommands [ my getCompleteCommand $commands ]
            set command [ string trim [ lindex $commandCommands 0 ] ]
            set commands [ lindex $commandCommands 1 ]
        }

        #puts "evalOneCommand command: $command"

        set return [ my evalCommand XXX $command 0 ]

        return ""
    }
}


