# Created at Fri Jan 04 12:21:13 EST 2008 by bthomass

namespace eval ::xointerp {

    Class ObjectInterpreter -superclass ::xointerp::TclInterpreter

    ObjectInterpreter # ObjectInterpreter {

        ObjectInterpreter is a TclInterpreter that evaluates a script in the scope 
        of an environment object.
    }

    ObjectInterpreter parameter {
        library
        { environment }
        { useGlobalProc {set lappend incr append info} }
    }

    ObjectInterpreter instproc evalCommand { level command { inString 0 } } {

        my instvar environment library

        if { ! [ my exists library ] } {
            set library $environment
        }

        set newCommand [ string trim [ my evalSubCommands $level $command $inString ] ]

        if { "$newCommand" == "" } { return }

        set commandName [ lindex $newCommand 0 ]

        if { [ lsearch -exact [ $library interpretableProcs ] $commandName ] != -1 } {

            set length [ string length $commandName ]
            set newCommand "$commandName [self] [ string range $newCommand $length end]"
        }

        if { "[ $library info methods around:${commandName} ]" == "around:${commandName}" } {

            set length [ string length $commandName ]
            set newCommand "around:${commandName} [self] $commandName [ string range $newCommand $length end]"
        }

        set code [ catch {

          set return [ my evalNewCommand $commandName $command $newCommand ]

        } return ]

        return -code $code -errorinfo $::errorInfo $return
    }

    ObjectInterpreter instproc evalNewCommand { commandName command { newCommand "" } } {

        my instvar environment library useGlobalProc

        if { "" == "$newCommand" } {

            set newCommand $command
        }

        if { [ lsearch -exact $useGlobalProc $commandName ] != -1 } {
            #do nothing
        } elseif { "[ $library info methods $commandName ]" == "$commandName" } {
            set newCommand "$library $newCommand"
        }

        set code [ catch {

            set return [ $environment eval $newCommand ]

        } return ] 

        if { $code == 1 } {

            if { ! [ my isobject $return ] } {

                set return [ ::xointerp::ScriptException new $return -command $command ]
            } 
        }

        return -code $code -errorinfo $::errorInfo $return
    }

    ObjectInterpreter instproc evalSubstLevel { level script } {

        my instvar environment

        set return [ my evalSubCommands $level $script 1 ]
        set return [ $environment eval [ list subst -nocommands $return ] ]

        return $return
    }
}


