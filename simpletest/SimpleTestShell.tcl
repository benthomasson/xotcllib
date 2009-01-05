# Created at Tue Feb 19 19:44:24 EST 2008 by bthomass

namespace eval ::simpletest {

    Class SimpleTestShell -superclass ::xoshell::Shell

    SimpleTestShell # SimpleTestShell {

        Please describe the class SimpleTestShell here.
    }

    SimpleTestShell parameter {
        { script "" }
        { red "\x1B\[31;1m" }
        { clear "\x1B\[0m" }
    }

    SimpleTestShell instproc executeCommand { command } { 

        my instvar done environment

        if [ catch {

            my puts "[ $environment eval $command ]\n"
            my lappend history $command

        } error ] {

            if { [ my isobject $error ] && [ $error hasclass ::xounit::AssertionError ] } {

                my puts "[ my red]Failure:\n[ $error message ] [my clear]\n"
                my lappend history $command

            } else {

                my eputs "[ my red ]Error:\n$error"
                my eputs "$::errorInfo[ my clear ]"
            }
        }

        if { ! $done } {
            my prompt
        }
    }

    SimpleTestShell instproc writeHistory { } {

        my instvar history name fileName

       set header \
"#!/bin/bash
#\\
ulimit -n 128 ;\\
exec tclsh \"\$0\" \"\$@\"
"

        ::xox::withOpenFile $fileName w file {

            puts $file $header
            puts $file "package require simpletest"
            puts $file "::simpletest::test $name \{"
            puts $file [ join $history "\n" ]
            puts $file "\}"
            puts $file "::simpletest::runTest $name"
        }
        exec chmod +x $fileName
    }

    SimpleTestShell instproc installProc { } {

        my instvar fileName

        proc ::simpletest::runTest { args } {

        }

        proc ::simpletest::test { name script } [ subst {
            [ self ] name \$name
            [ self ] script \$script
            [ self ] executeScript 
        } ]

        source $fileName 
    }

    SimpleTestShell instproc executeScript { } {

        my instvar fileName script

        set lines [ lrange [ split $script "\n" ] 1 end-1 ]

        while { "$lines" != "" } {

            set command [ lindex $lines 0 ]
            set lines [ lrange $lines 1 end ]

            while { ! [ info complete $command ] } {

                append command "\n"
                append command [ lindex $lines 0 ]
                set lines [ lrange $lines 1 end ]
            }

            puts "$command"
            if { "$command" == "interact" } {
                my putLine "Entering interactive mode"
                my done 0
                my shell
                my putLine "Exiting interactive mode"
            } else {
                my executeCommand $command
            }
        }
    }

}


