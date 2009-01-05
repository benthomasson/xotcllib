# Created at Sat Feb 09 23:10:50 EST 2008 by bthomass

namespace eval ::xointerp {

    Class LibraryInterpreter -superclass ::xointerp::TclInterpreter

    LibraryInterpreter # LibraryInterpreter {

        Please describe the class LibraryInterpreter here.
    }

    LibraryInterpreter parameter {
        library
        { useGlobalProc {set lappend incr} }
    }

    LibraryInterpreter instproc evalCommand { level command { inString 0 } } {

        my instvar library

        set newCommand [ string trim [ my evalSubCommands $level $command $inString ] ]

        if { "$newCommand" == "" } { return }

        set commandName [ lindex $newCommand 0 ]


        if { [ lsearch -exact [ $library interpretableProcs ] $commandName ] != -1 } {

            set length [ string length $commandName ]
            set newCommand "$commandName [self] [ string range $newCommand $length end]"
        }

        if { [ lsearch -exact [ my useGlobalProc ] $commandName ] != -1 } {
            #do nothing
        } elseif { "[ $library info methods $commandName ]" == "$commandName" } {
            set newCommand "$library $newCommand"
        }

        set code [ catch {

        set return [ uplevel $level $newCommand ]

        } return ] 

        if { $code == 1 } {

            if { ! [ my isobject $return ] } {

                set return [ ::xointerp::ScriptException new $return -command $command ]
            } 
        }

        if $code {

            puts "LI evalCommand: $return\n\twhile executing\n $level $library {$newCommand} $inString"
        }

        return -code $code -errorinfo $::errorInfo $return
    }
}


