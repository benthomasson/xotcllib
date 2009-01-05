# Created at Tue Sep 16 21:30:40 EDT 2008 by bthomass

namespace eval ::xointerp {

    Class TclLanguage -superclass ::xotcl::Object

    TclLanguage @doc TclLanguage {

        Please describe the class TclLanguage here.
    }

    TclLanguage parameter {

    }

    TclLanguage proc atomp { x } {
        if [ catch {
            set return [ expr { [ llength $x ] == 1 } ]
        } ] {
            return 0
        }
        return $return
    }

    TclLanguage proc listp { x } {
        if [ nullp $x ] { return 1 }
        if [ atomp $x ] { return 1 }
        return [ info complete $x ]
    }

    TclLanguage proc nullp { x } {
        return [ expr { "" == "$x" } ]
    }

    TclLanguage proc variablep { x } {
        return [ string match "$*" $x ]
    }

    TclLanguage proc commandp { x } {
        return [ info complete $x ]
    }

    TclLanguage proc subcommandp { x } {
        return [ string match "\\\[*\\\]" $x ]
    }

    TclLanguage proc stringp { x } {
        return 1
    }

    TclLanguage proc commandToList { command } {

        spy command

        set stateStack ""
        set bracketCount 0

        set newCommand ""
        set bracketCommand ""

        set chars [ split $command "" ]
        set state normal
        set lastState normal

        foreach char $chars {

            switch -- $state {

                escape {
                    append newItem $char
                    set state [ pop stateStack ]
                    set lastState escape
                }
                escapeBrackets {
                    append bracketCommand $char
                    set state [ pop stateStack ]
                    set lastState escapeBrackets
                }

                normal {
                    switch -regexp -- $char {
                        { } {
                            if [ info exists newItem ] {
                                #puts $newItem
                                if { "$lastState" == "braces" } {
                                    set newItem [ lindex $newItem 0 ]
                                }
                                lappend newCommand $newItem
                                unset newItem
                            } 
                        }
                        {\n} {
                            if [ info exists newItem ] {
                                #puts $newItem
                                if { "$lastState" == "braces" } {
                                    set newItem [ lindex $newItem 0 ]
                                }
                                lappend newCommand $newItem
                                unset newItem
                            } 
                        }
                        {\t} {
                            if [ info exists newItem ] {
                                #puts $newItem
                                if { "$lastState" == "braces" } {
                                    set newItem [ lindex $newItem 0 ]
                                }
                                lappend newCommand $newItem
                                unset newItem
                            } 
                        }
                        {\\} {
                            set state escape
                            set lastState normal
                            push stateStack normal
                            append newItem $char
                        }
                        {\[} {
                            incr bracketCount
                            set state brackets
                            set lastState normal
                            set bracketCommand "\["
                            push stateStack normal
                        }
                        {\"} {
                            set state string
                            set lastState normal
                            append newItem "\""
                            push stateStack normal
                        }
                        {\{} {
                            set state braces
                            set lastState normal
                            append newItem "\{"
                            push stateStack normal
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
                            set lastState string
                            push stateStack string
                            append newItem $char
                        }
                        "\[" {
                            incr bracketCount
                            set state brackets
                            set lastState string
                            set bracketCommand "\["
                            push stateStack string
                        }
                        "\"" {
                            set state [ pop stateStack ]
                            set lastState string
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
                            set lastState braces
                            push stateStack braces
                            append newItem $char
                        }
                        "\{" {
                            push stateStack braces
                            append newItem "\{"
                        }
                        "\}" {
                            set state [ pop stateStack ]
                            set lastState braces
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
                            set lastState bracketBraces
                            push stateStack bracketBraces
                            append bracketCommand $char
                        }
                        "\{" {
                            push stateStack bracketBraces
                            append newItem "\{"
                        }
                        "\}" {
                            set state [ pop stateStack ]
                            set lastState bracketBraces
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
                            set lastState brackets
                            push stateStack brackets
                            append bracketCommand $char
                        }
                        "\{" {
                            set state bracketBraces
                            set lastState brackets
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
                                set lastState brackets
                                append newItem "$bracketCommand\]"
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
            if { "$lastState" == "braces" } {
                set newItem [ lindex $newItem 0 ]
            }
            lappend newCommand $newItem
        }

        return $newCommand
    }
}
