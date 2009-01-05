
namespace eval ::xoshell { 

Class create CommandLineInterface -superclass { ::xotcl::Object }

CommandLineInterface id {$Id: CommandLineInterface.tcl,v 1.19 2008/11/18 00:25:26 bthomass Exp $}

CommandLineInterface instmixin add ::xox::NotGarbageCollectable
  
CommandLineInterface @doc CommandLineInterface {
Please describe CommandLineInterface here.
}
       
CommandLineInterface parameter {
    { command "" }
    { channel stdin }
    { history "" }
    { historyIndex 0 }
    { shell }
}

CommandLineInterface instproc enableRaw { } {
    my instvar channel
    catch {
        exec /bin/stty raw -echo <@$channel
        fconfigure $channel -buffering none 
    }
}

CommandLineInterface instproc disableRaw { } {
    my instvar channel
    catch {
        exec /bin/stty -raw echo <@$channel
    }
}

CommandLineInterface instproc moveLeft { } {
    my instvar channel history historyIndex line index

    if { $index > 0 } {
        incr index -1
        puts -nonewline "\x1B\x5B\x44"
    }
}

CommandLineInterface instproc moveRight { } {
    my instvar channel history historyIndex line index

    if { $index < [ llength $line ] } {
        incr index 
        puts -nonewline "\x1B\x5B\x43"
    }
}

CommandLineInterface instproc nextHistoryCommand { } {

    my instvar channel history historyIndex line index

    if { $historyIndex < [ llength $history ] } {
        incr historyIndex  
        my eraseLine $line $index
        set line [ lindex $history $historyIndex ]
        set index [ llength $line ]
        regsub -all "\n" $line "\n\r" newLine
        puts -nonewline [ join $newLine "" ]
    }
}

CommandLineInterface instproc previousHistoryCommand { } {

    my instvar channel history historyIndex line index

    if { $historyIndex > 0 } {
        incr historyIndex -1 
        my eraseLine $line $index
        set line [ lindex $history $historyIndex ]
        set index [ llength $line ]
        regsub -all "\n" $line "\n\r" newLine
        puts -nonewline [ join $newLine "" ]
    }
}

CommandLineInterface instproc tabComplete { } {

    my instvar channel history historyIndex line index shell

    if { ! [ info complete [ join $line "" ] ] } { return }

    set commands [ lsort -unique [ $shell getCommands [ join $line "" ] ] ]

    set length [ llength $commands ]

    switch $length {
        0 { }
        1 { 
            my disableRaw
            puts ""
            set command [ lindex $commands 0 ]
            set line [ split "$command " "" ]
            set index [ llength $line ] 
            my enableRaw
            $shell prompt
            my printLine
            return
        }
        default {
            my disableRaw
            set line [ split [ my findLongestMatch $commands ] "" ]
            set index [ llength $line ] 
            puts ""
            my printPrettyLines [ join $commands ", " ]
            my enableRaw
            $shell prompt
            my printLine
            return
        }
    }

    set variables [ lsort -unique [ $shell getVariables [ join $line "" ] ] ]

    set length [ llength $variables ]

    switch $length {
        0 { }
        1 { 
            my disableRaw
            puts ""
            set variable [ lindex $variables 0 ]
            set line [ split "$variable " "" ]
            set index [ llength $line ] 
            my enableRaw
            $shell prompt
            my printLine
            return
        }
        default {
            my disableRaw
            set line [ split [ my findLongestMatch $variables ] "" ]
            set index [ llength $line ] 
            puts ""
            my printPrettyLines [ join $variables ", " ]
            my enableRaw
            $shell prompt
            my printLine
            return
        }
    }

    set arguments [ lsort -unique [ $shell getArguments [ join $line "" ] ] ]

    set length [ llength $arguments ]

    switch $length {
        0 { }
        1 { 
            my disableRaw
            puts ""
            set variable [ lindex $arguments 0 ]
            set line [ split "$variable " "" ]
            set index [ llength $line ] 
            my enableRaw
            $shell prompt
            my printLine
            return
        }
        default {
            my disableRaw
            set line [ split [ my findLongestMatch $arguments ] "" ]
            set index [ llength $line ] 
            puts ""
            puts [ join $arguments ",\n" ]
            my enableRaw
            $shell prompt
            my printLine
            return
        }
    }
}

CommandLineInterface instproc printPrettyLines { list } {

    set index [ string first " " $list 80 ]

    if { $index == -1 } {
        puts $list
        return
    }

    while { $index != -1 } {

        puts [ string range $list 0 $index ]
        set list [ string range $list $index end ]
        set index [ string first " " $list 80 ]
    }

    puts $list
}

CommandLineInterface instproc getHelp { } {

    my instvar channel history historyIndex line index shell

    my disableRaw
    $shell getHelp [ join $line {} ]
    my enableRaw

    my printLine
}

CommandLineInterface instproc findLongestMatch { commands } {

    set longestMatch 0
    set match ""
    set done 0

    while { !$done } {

        if { $longestMatch >= [ string length [ lindex $commands 0 ] ] } {

            break
        }

        set char [ string index [ lindex $commands 0 ] $longestMatch ]

        append match $char
        set matched 1

        foreach command $commands {

            if { ! [ string match ${match}* $command ] } {

                set matched 0
                set done 1
                break
            }
        }

        if $matched {
            incr longestMatch
        }
    }

    if { "$match" == "?" } {

        return ""
    }
        
         
    
    return [ string range [ lindex $commands 0 ] 0 [ expr { $longestMatch - 1 } ] ]
}

CommandLineInterface instproc printLine { } {

    my instvar line index 

    puts -nonewline [ join $line "" ]

    set length [ llength $line ]

    for { set i $index } { $i < $length } { incr i } {

        puts -nonewline "\b"
    }
}

CommandLineInterface instproc readCommand { } {

    my instvar shell

    while { 1 } {

        my enableRaw
        set line [ my readLine ]
        my disableRaw

        my append command $line
        my append command "\n"

        if [ info complete [ my command ] ] {

            set command [ string trim [ my command ] ]
            my command ""
            return $command

        } else {

            #$shell addPrompt 
        }

        after 1
    }
}

CommandLineInterface instproc readLine { } {
    my instvar channel history historyIndex line index shell


    set line ""
    set index 0

    if { "stdin" != "$channel" } {
        return [ gets $channel ]
    }

    set done 0
    set character ""

    while { !$done } {

        after 1

        set lastCharacter $character
        set character [ read $channel 1 ]
        catch { unset c }
        scan $character %c c

        if { ! [ info exists c ] } { continue }

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
                set historyIndex [ llength $history ]
            }
            4 {
                puts "Use control-z to exit"
                $shell prompt
                my printLine
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
                #if [ info complete [ join $line "" ] ] {
                    puts "\r"
                    flush stdout
                    set done 1 
               # } else {
               #     puts "\r"
               #     incr index
               #     lappend line "\n"
               # }
            }
            14 { #down
                my nextHistoryCommand
            }
            16 { #up
                my previousHistoryCommand
            }
            26 { 
                puts "Control-Z exiting..."
                $shell exit 
                return
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
                        my nextHistoryCommand
                    }
                    65 { #up 
                        my previousHistoryCommand
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
                        if { "$character" == "?" && "$lastCharacter" != "?" } {
                            if [ catch {
                                my getHelp
                            } error ] {
                                #incr index
                                #lappend line $character 
                                #puts -nonewline $character
                                puts $error
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

    if {  "" != "$line" } {

        my lappend history $line
    }

    my historyIndex [ llength $history ]

    return [ join $line "" ] 
}

CommandLineInterface instproc moveToStart { } {

    my instvar channel history historyIndex line index

    for { set i 0 } { $i < $index } { incr i } {

        puts -nonewline "\b"
    }

    set index 0
}

CommandLineInterface instproc moveToEnd { } {

    my instvar channel line index

    set length [ llength $line ] 

    for { set i $index } { $i < $length } { incr i } {

        puts -nonewline [ lindex $line $i ]
    }

    set index [ llength $line ]
}

CommandLineInterface instproc insertCharacter { line index character } {

    puts -nonewline $character
    set length [ llength $line ]

    for { set i $index } { $i < $length } { incr i } {

        puts -nonewline [ lindex $line $i ]
    }

    puts -nonewline " "

    for { set i $index } { $i < $length } { incr i } {
        puts -nonewline "\b"
    }
    puts -nonewline "\b"
}

CommandLineInterface instproc eraseCharacter { line index } {

    puts -nonewline "\b"
    set length [ llength $line ]

    for { set i $index } { $i < $length } { incr i } {

        puts -nonewline [ lindex $line $i ]
    }

    puts -nonewline " "


    for { set i $index } { $i < $length } { incr i } {
        puts -nonewline "\b"
    }
    puts -nonewline "\b"
}

CommandLineInterface instproc eraseLine { line index } {

    set length [ llength $line ]

    for { set i $index } { $i < $length } { incr i } {

        puts -nonewline " "
    }

    for { set i 0 } { $i < $length } { incr i } {

        puts -nonewline "\b \b"
    }
}

CommandLineInterface instproc readCharacter { } {
    my instvar channel
    set character [ read $channel 1 ]
    scan $character %c c
    puts $c
    return $character
}

}


