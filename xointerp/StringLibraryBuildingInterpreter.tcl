# Created at Mon Jan 07 13:40:42 EST 2008 by bthomass

namespace eval ::xointerp {

    Class StringLibraryBuildingInterpreter -superclass ::xointerp::LibraryInterpreter

    StringLibraryBuildingInterpreter # StringLibraryBuildingInterpreter {

        Please describe the class StringLibraryBuildingInterpreter here.
    }

    StringLibraryBuildingInterpreter parameter {

    }

    StringLibraryBuildingInterpreter instproc tclEvalLevel { level script } {

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

                puts "SBI tclEval: $error\n\t while executing\n $level $command\n\t in script \n\t $script"

                return -code 1 -errorinfo $::errorInfo $error
            }
        }

        return [ string trim $return ]
    }

    StringLibraryBuildingInterpreter instproc generate { script } {

        my instvar currentLevel

        set level [ self callinglevel ]

        set oldLevel $currentLevel
        set currentLevel $level

        set return [ my evalSubstLevel $level $script ]

        set return [ uplevel $level [ list subst -nocommands $return ] ]

        set currentLevel $oldLevel

        return $return
    }
}


