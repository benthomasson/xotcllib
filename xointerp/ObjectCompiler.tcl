# Created at Sun Sep 07 08:58:06 EDT 2008 by bthomass

namespace eval ::xointerp::gensym { }

namespace eval ::xointerp {

    Class ObjectCompiler -superclass ::xointerp::StringBuildingInterpreter

    ObjectCompiler @doc ObjectCompiler {

        Please describe the class ObjectCompiler here.
    }

    ObjectCompiler set commandNumber 0 

    ObjectCompiler parameter {
        interpreter
    }

    ObjectCompiler instproc compileEnvironmentExpression { condition } {

        my instvar library environment

        $library mixin add ::xointerp::Compilable

        return "\[ $environment eval { expr { [ my evalSubCommands XXX $condition 1 ] } } \]"
    }

    ObjectCompiler instproc compileSubCommands { script } {

        my instvar library

        $library mixin add ::xointerp::Compilable

        return [ my evalSubCommands XXX $script 1 ]
    }

    ObjectCompiler instproc compileScript { script } {

        my instvar library

        $library mixin add ::xointerp::Compilable

        return [ my tclEval $script ]
    }

    ObjectCompiler instproc evalCommand { level command { inString 0 } } {

        my instvar environment library interpreter

        set command [ string trim $command ]
        if { "$command" == "" } { return }
        set commandName [ lindex $command 0 ]

        set command [ string trim [ my evalSubCommands $level $command 1 ] ]

        if { [ lsearch -exact [ $library compilableProcs ] $commandName ] != -1 } {

            set length [ string length $commandName ]
            set arguments [ string range $command $length end]
            set return [ my compileCompilableCommand $commandName $arguments ]

        } elseif { [ lsearch -exact [ $library interpretableProcs ] $commandName ] != -1 } {

            set length [ string length $commandName ]
            set command "$commandName $interpreter [ string range $command $length end]"

            set return [ my interpretCommand $commandName $command ]

        } else {

            set return [ my compileCommand $commandName $command ]
        }

        return $return
    }

    ObjectCompiler instproc evalSubCommand { level command { inString 0 } } {

        return "\[ [ my tclEvalLevel $level $command ] \]"
    }

    ObjectCompiler instproc compileCompilableCommand { commandName arguments } {

        my instvar environment library useGlobalProc

        return [ $library $commandName [ self ] $arguments ]
    }

    ObjectCompiler instproc interpretCommand { commandName command } {

        my instvar environment library useGlobalProc

        return "$library $command"
    }

    ObjectCompiler instproc compileCommand { commandName command } {

        my instvar environment library useGlobalProc

        if { [ lsearch -exact $useGlobalProc $commandName ] != -1 } {
            #do nothing
        } elseif { "[ $library info methods $commandName ]" == "$commandName" } {
            set command "$library $command"
        }

        return "$environment eval { $command }"
    }

    ObjectCompiler instproc prepareArgument { arg } {

        if [ ::xointerp::TclLanguage subcommandp $arg ] { 
            return $arg
        } elseif [ ::xointerp::TclLanguage variablep $arg ] { 
            return $arg
        } else {
            return [ list $arg ]
        }
    }

}


