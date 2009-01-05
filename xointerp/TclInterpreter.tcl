# Created at Thu Jan 03 20:24:16 EST 2008 by bthomass

namespace eval ::xointerp {

    proc isEmpty { var } {

        upvar $var stack

        return [ expr { "$stack" == "" } ]
    }

    proc push { var value } {

        uplevel [ list lappend $var $value ]
    }

    proc pop { var } {

        upvar $var stack

        set value [ lindex $stack end ]
        set stack [ lrange $stack 0 end-1 ]

        return $value
    }

    proc peek { var } {

        upvar $var stack

        return [ lindex $stack end ]
    }

    proc appendCommand { var string } {

        upvar $var command

        if { ! [ info complete $string ] } {

            append command $string
            return
        }

        catch {
            set length 0
            set length [ llength $string ]
        }

        if { $length == 1 } {

            append command $string
            return
        }

        append command [ list $string ]
        return
    }

    proc spy { var } {

        #uplevel [ list puts "$var: [ uplevel [ list set $var ] ]" ]
    }

    Class TclInterpreter -superclass ::xotcl::Object

    TclInterpreter # TclInterpreter {

        TclInterpter is a Tcl interpreter defined in user space.  This allows for customization of the
        interpreter through subclassing the TclInterpreter class.
    }

    TclInterpreter parameter {
        { currentLevel none }
    }

    TclInterpreter instproc tclEval { script } {

        my instvar currentLevel

        set level [ self callinglevel ]

        set oldLevel $currentLevel
        set currentLevel $level

        set code [ catch {

            set return [ my tclEvalLevel $level $script ]

        } return ]

        set currentLevel $oldLevel

        return -code $code -errorinfo $::errorInfo $return
    }

    TclInterpreter instproc tclEvalLevel { level script } {

        set return ""
        set code 0

        set commands [ split $script "\n" ]

        while { "" != "$commands" } {

            set commandCommands [ my getCompleteCommand $commands ]
            set command [ lindex $commandCommands 0 ]
            set commands [ lindex $commandCommands 1 ]

            if { "" == "$command" } continue

            set code [ catch { 

            set return [ my evalCommand $level $command ]

            } return ]

            if { $code == 1 } {

                if { [ my isobject $return ] && [ $return hasclass ::xointerp::ScriptException ] && ! [ $return exists script ] } {

                    $return script $script
                }
            }

            if { $code != 0 } { 

                set ::errorInfo "$return\n\twhile executing\n\t\"$command\"\n\tin script {\n\t[ string trim $script ]\n\t}"
                break 
            }
        }

        if $code {

            #puts "tclEval: return\n\twhile executing\n\t $command\n\t in script\n\t $script"
        }

        return -code $code -errorinfo $::errorInfo $return
    }

    TclInterpreter instproc evalSubCommand { level command { inString 0 } } {

        set return ""

        set code [ catch {

            set return [ my tclEvalLevel $level $command ]
            
        } return ]

        if $code {

            puts "evalSubCommand: $return \n\twhile executing\n $level $command $inString"
        }


        return -code $code -errorinfo $::errorInfo $return
    }

    TclInterpreter instproc evalCommand { level command { inString 0 } } {

        set code [ catch {

            set return [ uplevel $level [ my evalSubCommands $level $command $inString ] ]

        } return ] 

        if { $code == 1 } {

            if { ! [ my isobject $return ] } {

                set return [ ::xointerp::ScriptException new $return -command $command ]
            } 
        }

        #set ::errorInfo "$return\n\twhile executing\n $command"

        return -code $code -errorinfo $::errorInfo $return
    }

    TclInterpreter instproc getCompleteCommand { commands } {

        set command [ string trim [ lindex $commands 0 ] ]
        set commands [ lrange $commands 1 end ]

        while { ! [ info complete $command ] || "" == "$command" } {

            if { "" == "$commands" && ! [ info complete $command ] } { 
               error "Incomplete command: $command"
            }
 
            if { "" == "$commands" } { 
                return ""
            }

            if { "" == "$commands" } { return "" }

            set command "$command\n[ lindex $commands 0]"
            set commands [ lrange $commands 1 end ]
        }

        set command [ string trim $command ]

        #remove command if comment
        if { "[ string index $command 0 ]" == "#" } {
            set command ""
        }

        return [ list $command $commands ]
    }

    TclInterpreter instproc evalSubCommands { level command inString } {

        if $inString {

            return [ my evalSubCommandsInString $level $command ]

        } else {

            return [ my evalSubCommandsNotInString $level $command ]
        }
    }

    TclInterpreter instproc evalSubCommandsNotInString { level command } {

        spy command

        set stateStack ""
        set bracketCount 0

        set newCommand ""
        set bracketCommand ""

        set chars [ split $command "" ]
        set state normal

        set inString 0

        foreach char $chars {

            switch -- $state {

                escape {
                    append newItem $char
                    set state [ pop stateStack ]
                }
                escapeBrackets {
                    append bracketCommand $char
                    set state [ pop stateStack ]
                }

                normal {
                    switch -regexp -- $char {
                        {;} {
                            if [ info exists newItem ] {
                                appendCommand newCommand $newItem
                                append newCommand " "
                                unset newItem
                            }
                            my evalSubCommand $level $newCommand $inString 
                            set newCommand ""
                        }
                        { } {
                            if [ info exists newItem ] {
                                appendCommand newCommand $newItem
                                append newCommand " "
                                unset newItem

                            } else {
                                append newCommand " "
                            }
                        }
                        {\n} {
                            if [ info exists newItem ] {
                                appendCommand newCommand $newItem
                                append newCommand "\n"
                                unset newItem

                            } else {
                                append newCommand "\n"
                            }
                        }
                        {\t} {
                            if [ info exists newItem ] {
                                appendCommand newCommand $newItem
                                append newCommand "\t"
                                unset newItem

                            } else {
                                append newCommand "\t"
                            }
                        }
                        {\\} {
                            set state escape
                            push stateStack normal
                            append newItem $char
                        }
                        {\[} {
                            incr bracketCount
                            set state brackets
                            set bracketCommand "\["
                            push stateStack normal
                        }
                        {\"} {
                            set state string
                            append newItem "\""
                            push stateStack normal
                            set inString 1
                        }
                        {\{} {
                            set state braces
                            append newItem "\{"
                            push stateStack normal
                            set inString 1
                        }
                        default {
                            append newItem $char
                        }
                    }
                } 
                string {
                     switch -- $char {
                        "\\" {
                            set state escape
                            push stateStack string
                            append newItem $char
                        }
                        "\[" {
                            incr bracketCount
                            set state brackets
                            set bracketCommand "\["
                            push stateStack string
                        }
                        "\"" {
                            set state [ pop stateStack ]
                            append newItem "\""
                        }
                        default {
                            append newItem $char
                        }
                     }
                }
                braces {
                     switch -- $char {
                        "\\" {
                            set state escape
                            push stateStack braces
                            append newItem $char
                        }
                        "\{" {
                            push stateStack braces
                            append newItem "\{"
                        }
                        "\}" {
                            set state [ pop stateStack ]
                            append newItem "\}"
                        }
                        default {
                            append newItem $char
                        }
                     }
                }
                bracketBraces {
                     switch -- $char {
                        "\\" {
                            set state escapeBrackets
                            push stateStack bracketBraces
                            append bracketCommand $char
                        }
                        "\{" {
                            push stateStack bracketBraces
                            append bracketCommand "\{"
                        }
                        "\}" {
                            set state [ pop stateStack ]
                            append bracketCommand "\}"
                        }
                        default {
                            append bracketCommand $char
                        }
                     }
                }
                brackets {
                    switch -- $char {
                        "\\" {
                            set state escapeBrackets
                            push stateStack brackets
                            append bracketCommand $char
                        }
                        "\{" {
                            set state bracketBraces
                            push stateStack brackets
                            append bracketCommand $char
                        }
                        "\[" {
                            append bracketCommand $char
                            incr bracketCount 
                        }
                        "\]" {
                            incr bracketCount -1
                            if { $bracketCount == 0 } {
                                set state [ pop stateStack ]
                                set result [ my evalSubCommand $level [ string range $bracketCommand 1 end ] $inString ]
                                #puts "(1)RESULT: $result :LTUSER"
                                if [ string match "\{*" $result ] {
                                    append newItem [ list $result ]
                                } elseif [ string match " *" $result ] {
                                    append newItem [ list $result ]
                                } elseif [ string match "\t*" $result ] {
                                    append newItem [ list $result ]
                                } elseif [ string match "\n*" $result ] {
                                    append newItem [ list $result ]
                                } elseif [ string match "\"*" $result ] {
                                    append newItem [ list $result ]
                                } elseif [ string match "\\\[*" $result ] {
                                    append newItem [ list $result ]
                                } else {
                                    append newItem $result
                                }
                            } else {
                                append bracketCommand "\]"
                            }
                        }
                        default {
                            append bracketCommand $char
                        }
                    }
                }
            }
        }

        if [ info exists newItem ] {

            appendCommand newCommand $newItem
        }

        #spy newCommand

        #puts "NEWCOMMAND: $newCommand"

        return $newCommand
    }

    TclInterpreter instproc evalSubCommandsInString { level command } {

        #spy command

        set stateStack ""
        set bracketCount 0

        set newCommand ""
        set bracketCommand ""

        set chars [ split $command "" ]
        set state normal

        foreach char $chars {

            switch -- $state {

                escape {
                    append newCommand $char
                    set state [ pop stateStack ]
                }
                escapeBrackets {
                    append bracketCommand $char
                    set state [ pop stateStack ]
                }

                normal {
                    switch -regexp -- $char {
                        {\\} {
                            set state escape
                            push stateStack normal
                            append newCommand $char
                        }
                        {\[} {
                            incr bracketCount
                            set state brackets
                            set bracketCommand "\["
                            push stateStack normal
                        }
                        {\"} {
                            set state string
                            append newCommand "\""
                            push stateStack normal
                        }
                        {\{} {
                            set state braces
                            append newCommand "\{"
                            push stateStack normal
                        }
                        default {
                            append newCommand $char
                        }
                    }
                } 
                string {
                     switch -- $char {
                        "\\" {
                            set state escape
                            push stateStack string
                            append newCommand $char
                        }
                        "\[" {
                            incr bracketCount
                            set state brackets
                            set bracketCommand "\["
                            push stateStack string
                        }
                        "\"" {
                            set state [ pop stateStack ]
                            append newCommand "\""
                        }
                        default {
                            append newCommand $char
                        }
                     }
                }
                braces {
                     switch -- $char {
                        "\\" {
                            set state escape
                            push stateStack braces
                            append newCommand $char
                        }
                        "\{" {
                            push stateStack braces
                            append newCommand "\{"
                        }
                        "\}" {
                            set state [ pop stateStack ]
                            append newCommand "\}"
                        }
                        default {
                            append newCommand $char
                        }
                     }
                }
                bracketBraces {
                     switch -- $char {
                        "\\" {
                            set state escapeBrackets
                            push stateStack bracketBraces
                            append bracketCommand $char
                        }
                        "\{" {
                            push stateStack bracketBraces
                            append bracketCommand "\{"
                        }
                        "\}" {
                            set state [ pop stateStack ]
                            append bracketCommand "\}"
                        }
                        default {
                            append bracketCommand $char
                        }
                     }
                }
                brackets {
                    switch -- $char {
                        "\\" {
                            set state escapeBrackets
                            push stateStack brackets
                            append bracketCommand $char
                        }
                        "\{" {
                            set state bracketBraces
                            push stateStack brackets
                            append bracketCommand $char
                        }
                        "\[" {
                            append bracketCommand $char
                            incr bracketCount 
                        }
                        "\]" {
                            incr bracketCount -1
                            if { $bracketCount == 0 } {
                                set state [ pop stateStack ]
                                set result [ my evalSubCommand $level [ string range $bracketCommand 1 end ] 0 ]
                                #puts "(2)RESULT: $result :LTUSER"
                                append newCommand $result
                            } else {
                                append bracketCommand "\]"
                            }
                        }
                        default {
                            append bracketCommand $char
                        }
                    }
                }
            }
        }

        if { "$state" == "brackets" } {

            error "Missing closing bracket in:\n$command"
        }

        #spy newCommand

        return $newCommand
    }

    TclInterpreter instproc evalSubst { script } {

        my instvar currentLevel

        set level [ self callinglevel ]

        set oldLevel $currentLevel
        set currentLevel $level

        set return [ my evalSubstLevel $level $script ]


        set currentLevel $oldLevel

        return $return
    }

    TclInterpreter instproc evalSubstLevel { level script } {

        set return [ my evalSubCommands $level $script 1 ]
        set return [ uplevel $level [ list subst -nocommands $return ] ]

        return $return
    }

    TclInterpreter instproc evalSubstCurrentLevel { script } {

        my instvar currentLevel

        return [ my evalSubCommands $currentLevel $script 1 ]
    }

}


