# Created at Mon Jan 07 13:40:42 EST 2008 by bthomass

namespace eval ::xointerp {

    Class StringBuildingInterpreter -superclass ::xointerp::ObjectInterpreter

    StringBuildingInterpreter # StringBuildingInterpreter {

        Please describe the class StringBuildingInterpreter here.
    }

    StringBuildingInterpreter parameter {
    }

    StringBuildingInterpreter instproc tclEvalLevel { level script } {

        set return ""

        set commands [ split $script "\n" ]

        while { "" != "$commands" } {

            set commandCommands [ my getCompleteCommand $commands ]
            set command [ lindex $commandCommands 0 ]
            set commands [ lindex $commandCommands 1 ]

            if { "" == "$command" } continue

            if [ catch {

                append return [ my evalCommand $level $command ]
                append return "\n"

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

        return [ string range $return 0 end-1 ]
    }
}


