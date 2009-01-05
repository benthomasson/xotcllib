
namespace eval ::xoshell { 

Class create CommandEditor -superclass { ::xoshell::CommandLineInterface }

CommandEditor id {$Id: CommandEditor.tcl,v 1.1 2007/08/13 18:39:28 bthomass Exp $}
  
CommandEditor @doc CommandEditor {
Please describe CommandEditor here.
}
       
CommandEditor parameter {
    { script }
    { scriptIndex 0 }
    { lines "" }
    { currentLine 0 }
}

CommandEditor instproc lineIndex { line } {

    return [ lindex $line 0 ]
}

CommandEditor instproc lineChars { line } {

    return [ lindex $line 1 ]
}

CommandEditor instproc getCommand { } {

    set command ""

    foreach line [ my lines ] {

        append command [ join [ my lineChars $line ] "" ]
        append command "\n"
    }

    return [ string trim  $command ]
}

CommandEditor instproc processCommand { } {

    my instvar shell scriptIndex script

    set command [ my readCommand ]

    #my debug ":$command:"
    #puts "\r"

    if { $scriptIndex >= [ llength [ $script getCommands ] ] } {

        $shell processCommand $command

    } else {
        
        #my debug "$command $scriptIndex"

        $shell processCommand $command $scriptIndex
    }
    my scriptIndex [ llength [ $script getCommands ] ]
    #my debug [$script getCommands]
}

CommandEditor instproc readCommand { } {

    my instvar shell currentLine lines

    while { 1 } {

        my enableRaw
        my readLine 
        my disableRaw

        set command [ my getCommand ]

        if [ info complete $command ] {

            for { set i $currentLine } { $i < [ llength $lines ] } { incr i } {

                puts ""
            }

            my lines ""
            my currentLine 0
            return $command

        } else {

            $shell addPrompt 
        }

        after 1
    }
}

CommandEditor instproc readLine { } {
    my instvar channel line index lines currentLine shell

    set line ""
    set index 0
    
    if { "stdin" != "$channel" } {
        my lines [ list [ list 0 [ split [ gets $channel ] "" ] ] ]
        return
    }

    set done 0

    while { !$done } {

        set character [ read $channel 1 ]
        scan $character %c c

        #puts -nonewline ":$c:"

        switch $c {
            1 { 
                my moveToStart 
            }
            2 { #left 
                my moveLeft 
            }
            6 { #right
                my moveRight
            }
            3 { 
                my eraseLine $line $index
                set line ""
                set index 0
            }
            5 { 
                my moveToEnd 
            }
            8 {
                if { $index > 0 } {
                    incr index -1
                    set line [ lreplace $line $index $index ]
                    my eraseCharacter $line $index
                }
            }
            9 {
                my tabComplete
            }
            13 -
            10 { 
                    puts "\r"
                    flush stdout
                    set done 1 
            }
            14 { #down
                my downArrow
            }
            16 { #up
                my upArrow
            }
            27 {
                set control [ read $channel 1 ]
                scan $control %c c1
                #puts -nonewline "<$c1>"
                set command [ read $channel 1 ]
                scan $command %c c2
                #puts -nonewline "{$c}"

                switch $c2 {
                    68 { #left 
                        if { $index > 0 } {
                            incr index -1
                            puts -nonewline "$character$control$command"
                        }
                    }
                    67 { #right
                        if { $index < [ llength $line ] } {
                            incr index 
                            puts -nonewline "$character$control$command"
                        }
                    }
                    66 { #down 
                        my downArrow
                    }
                    65 { #up 
                        my upArrow
                    }
                }
            }
            127 {
                if { $index > 0 } {
                    incr index -1
                    set line [ lreplace $line $index $index ]
                    my eraseCharacter $line $index
                }
            }
            default { 
                if [ string is print $character ] {
                    if { $index == [ llength $line ] } {
                        if { "$character" == "?" && $index > 0 } {
                            if [ catch {
                                my getHelp
                            } ] {
                                incr index
                                lappend line $character 
                                puts -nonewline $character
                            }
                        } else {
                            incr index
                            lappend line $character 
                            puts -nonewline $character
                        }
                    } else {
                        set line [ linsert $line $index $character ]
                        incr index
                        my insertCharacter $line $index $character 
                    }
                } else {

                    puts -nonewline ":$c:"
                }
            }
        }
        flush stdout
    }

    my setLine
    my incr currentLine
}

CommandEditor instproc setLine { } {

    my instvar currentLine line lines index 

    if { $currentLine >= [ llength $lines ] } {

        my lappend lines [ list [ llength $line ] $line ]

    } else {

       lset lines $currentLine [ list [ llength $line ] $line ] 
    }
}

CommandEditor instproc printPromptLine { } {

    my instvar currentLine shell scriptIndex

    my clearLine
    puts -nonewline "\r"

    if { $currentLine == 0 } {
        $shell prompt
    } else {
        $shell addPrompt
    }
    my printLine
}

CommandEditor instproc upArrow { } {

    my instvar currentLine line index lines shell

    if { $currentLine <= 0 } {

        my previousHistoryCommand
        return
    }

    my setLine

    my previousLine
}

CommandEditor instproc previousLine { } {

    my instvar currentLine line index lines shell

    puts -nonewline "\x1B\x5B\x41"
    flush stdout
    my incr currentLine -1
    puts -nonewline "\r"
    #my moveToStart
    set line [ my lineChars [ lindex $lines $currentLine ] ]
    if { $index > [ llength $line ] } {

        set index [ llength $line ]
    }

    my printPromptLine
}

CommandEditor instproc downArrow { } {

    my instvar currentLine lines line index shell

    set length [ llength $lines ]

    if { $currentLine >= ($length - 1) } {

        my nextHistoryCommand
        return
    }

    my setLine

    my nextLine
}

CommandEditor instproc nextLine { } {

    my instvar currentLine lines line index shell

    puts -nonewline "\x1B\x5B\x42"
    flush stdout
    my incr currentLine
    puts -nonewline "\r"
    #my moveToStart
    set line [ my lineChars [ lindex $lines $currentLine ] ]
    if { $index > [ llength $line ] } {

        set index [ llength $line ]
    }

    my printPromptLine
}

CommandEditor instproc nextHistoryCommand { } {

    my instvar channel script scriptIndex 

    if { $scriptIndex < [ llength [ $script getCommands ] ] } {
        incr scriptIndex  
        my clearLine
        my eraseCommand 
        my setCommand [ $script getCommand $scriptIndex ]
    }
}

CommandEditor instproc previousHistoryCommand { } {

    my instvar channel script scriptIndex 

    if { $scriptIndex > 0 } {
        incr scriptIndex -1 
        my eraseCommand 
        my setCommand [ $script getCommand $scriptIndex ]
    }
}

CommandEditor instproc eraseCommand { } {

    my instvar lines currentLine line index shell

    for { set i $currentLine } { $i > 0 } { incr i -1 } {

        my cursorUp
    }

    set length [ llength $lines ] 

    my clearLine

    $shell prompt

    for { set i 1 } { $i < $length } { incr i } {
        puts ""
        my clearLine
    }

    for { set i 1 } { $i < $length } { incr i } {
        my cursorUp
    }

    set line ""
    set index 0
    set lines ""
    set currentLine 0
}

CommandEditor instproc setCommand { command } {

    my instvar lines line index

    set command [ string trim $command ]

    my printCommand $command

    #my debug $command
    #puts "\r"

    set lines ""
    set newLines [ split $command "\n" ]

    if { 1 == [ llength $newLines ] } {
        set line [ split [ lindex $newLines 0 ] "" ]
        set index [ llength $line ]
        my currentLine 0
        return
    }

    foreach aLine [ lrange $newLines 0 end-1 ] {

        #my debug $aLine
        #puts "\r"

        set line [ split $aLine "" ]
        my setLine
        my incr currentLine
    }

    set line [ split [ lindex $newLines end ] "" ]
    set index [ llength $line ]

    #my debug $lines
    #puts "\r"

}

CommandEditor instproc printCommand { command } {

    my instvar shell

    set lines [ split $command "\n" ]

    my clearLine
    $shell prompt
    puts -nonewline [ lindex $lines 0 ]

    foreach line [ lrange $lines 1 end ] {

        puts "\r"
        my clearLine
        $shell addPrompt
        puts -nonewline $line
    }
}

CommandEditor instproc clearLine { } {
    puts -nonewline "\x1B\[2K"
    puts -nonewline "\r"
    flush stdout
}

CommandEditor instproc cursorUp { } {

    puts -nonewline "\x1B\x5B\x41"
    flush stdout
}

}


