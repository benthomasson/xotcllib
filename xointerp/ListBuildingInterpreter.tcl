# Created at Mon Jan 07 13:40:42 EST 2008 by bthomass

namespace eval ::xointerp {

    Class ListBuildingInterpreter -superclass ::xointerp::ObjectInterpreter

    ListBuildingInterpreter # ListBuildingInterpreter {

        Please describe the class ListBuildingInterpreter here.
    }

    ListBuildingInterpreter parameter {

    }

    ListBuildingInterpreter instproc tclEvalLevel { level script } {

        set return ""

        set commands [ split $script "\n" ]

        while { "" != "$commands" } {

            set commandCommands [ my getCompleteCommand $commands ]
            set command [ lindex $commandCommands 0 ]
            set commands [ lindex $commandCommands 1 ]

            if { "" == "$command" } continue

            if [ catch {

                lappend return [ my evalCommand $level $command ]

            } error ] {

                if { [ my isobject $error ] && [ $error hasclass ::xointerp::ScriptException ] && ! [ $error exists script ] } {
                    $error script $script
                } else {
                    $error append script "\nin script { \n $script \n }"
                }

                #puts "SBI tclEval: $error\n\t while executing\n $level $command\n\t in script \n\t $script"

                return -code 1 -errorinfo $::errorInfo $error
            }
        }

        return $return
    }
}


