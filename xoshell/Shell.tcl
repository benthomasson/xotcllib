namespace eval ::xoshell { 

Class create Shell -superclass { ::xotcl::Object }

Shell id {$Id: Shell.tcl,v 1.47 2008/12/02 01:26:21 bthomass Exp $}

Shell instmixin add ::xox::NotGarbageCollectable

  
Shell @doc Shell {
Shell allows users to communicate directly with objects
using a shell like interface.
}
    
Shell @doc input { }

Shell @doc output { }

Shell @doc error { }

Shell @doc done { }

Shell parameter {
   { input stdin }
   { output stdout }
   { error stderr }
   { done 0 }
   { name xoshell }
   { fileName }
   { cli }
   { environment }
   { language }
   { history "" }
   { doHistory 1 }
} 

Shell instproc init { } {

    my connectCli [ my input ]
}

Shell instproc connectCli { input } {

    my input $input
    my cli [ ::xoshell::CommandLineInterface new -channel $input -shell [ self ] ] 
}
        

Shell @doc addPrompt { 
addPrompt does ...
}

Shell instproc addPrompt {  } {
    my instvar output 

    puts -nonewline $output "+>"
    flush $output
}


Shell @doc checkInput { 
checkInput does ...
}

Shell instproc checkInput {  } {

    my instvar input cli

        if [ catch {

            $cli channel $input
            my processCommand [ $cli readCommand ]

        } result ] {

            my eputs $result
            my eputs $::errorInfo
        }
}


Shell @doc eputs { 
eputs does ...
            message -
}

Shell instproc eputs { message } {
    my instvar error
    puts $error $message
    flush $error
}



Shell @doc processCommand { 
processCommand does ...
            command -
}

Shell instproc processCommand { command } {
    my instvar done language

    set command [ string trim $command ]

    if { "" == "$command" } {

        my defaultMethod 
        return
    }

    catch {
        set firstCommand ""
        set secondCommand ""
        set firstCommand [ lindex $command 0 ]
        set secondCommand [ lindex $command 1 ]
    }

    set method ${firstCommand}

    if { "exit" == "$method" } {

        my exit
        return
    }
        

    if { ! [ my isCommand $method ] } {

        #my debug "unknownCommand $command"

        my unknownCommand $command
        return
    }

    if { "?" == "$secondCommand" } {

        my doHelp $language $firstCommand
        return
    }

    return [ my executeCommand $command ]
}

Shell instproc executeCommand { command } { 

    my instvar done environment

    set return ""

    if [ catch {

        set return [ $environment eval $command ]
        my putLine $return
        my lappend history $command

    } error ] {

        my eputs [ ::xoexception::Throwable extractMessage $error ]
    }

    if { ! $done } {
        my prompt
    }

    return $return
}

Shell instproc isCommand { method } { 

   return 1
}


Shell @doc prompt { 
prompt does ...
}

Shell instproc prompt {  } {
    my instvar output 

    puts -nonewline $output "[ my name ]>"
    flush $output
}



Shell instproc putLine { message } {
    my instvar output
    puts $output $message
    flush $output
}

Shell instproc puts { message } {
    my instvar output
    puts -nonewline $output $message
    flush $output
}


Shell @doc shell { 
shell does ...
}

Shell instproc shell {  } {
    my instvar done

    my prompt

    while { ! $done } {

        my checkInput
        after 1
        my writeHistory 
    }
}

Shell @doc getShortComment { 
getShortComment does ...
            method -
}

Shell instproc getShortComment { method } {
    set comment [ ::xox::ObjectGraph findFirstComment [ self ] $method ]
    return [ string trim [ lindex [ split $comment "."  ] 0 ] ]
}


Shell @doc unknownCommand { 
unknownCommand does ...
            command -
}

Shell instproc unknownCommand { command } {

    catch {
        set firstCommand ""
        set firstCommand [ lindex $command 0 ]
    }

    my eputs "Error: Unknown command $firstCommand"
    my prompt
}

Shell @doc defaultMethod { 
Default method is called when you just press enter.
}

Shell instproc defaultMethod {  } {
        my instvar shell

        #my *?*
        my prompt
}

Shell instproc findObject { object } {

    my instvar language
    
    return $object
}

Shell instproc getObjectAndCommand { command } {

    set current 0
    set next 1

    set userObject [ lindex $command $current ]
    set object [ lindex $command 0 ]
    set object [ my findObject $object ]

    if { ! [ string match ::* $object ] } {
        set object ::${object}
    }

    if [ my isobject $object ] {

        while { [ lsearch -exact [ $object info children ] ${object}::[ lindex $command $next ] ] != -1 } {

            set object ${object}::[ lindex $command $next ]
            set userObject "${userObject} [ lindex $command $next ]"
            incr current 
            incr next
        }

        return [ list $object [ lrange $command $next end ] $userObject ]

    } else {

        return ""
    }
}


Shell instproc getHelp { command } {

    my instvar language

    if { ! [ info complete $command ] } { 

        my putLine ""
        my prompt
        return
    }

    set objectAndCommand [ my getObjectAndCommand $command ]

    if { "" != "$objectAndCommand" } {

        my doHelp [ lindex $objectAndCommand 0 ] [ lindex [ lindex $objectAndCommand 1 ] 0 ]

    } else {

        my doHelp $language [ lindex $command 0 ]
    }
}

Shell instproc printCommands { object } {

        my putLine ""
        my putLine ""
        my putLine "Commands"
        my putLine "====================="

        catch {
        set commands [ $object info methods ]
        set commands [ $object getCommands ]
        }

        foreach method [ lsort $commands ] {

            my putLine [ format "%-20s%-20s" $method [ string map { "\n" " " } [ ::xox::ObjectGraph getShortComment $object $method ] ] ]
        }
}


Shell @doc doHelp { 
doHelp does ...
            command -
}

Shell instproc doHelp { object command } {

    my instvar done

    if { "" == "$command" } {

        my printCommands $object
        if { ! $done } { my prompt }
        return
    }

    set class [ ::xox::ObjectGraph findFirstImplementationClass $object ${command} ]
    if { "$class" == "" } { 
        my putLine ""
        my putLine "Not a command"
        if { ! $done } { my prompt }
        return 
    }

    my putLine ""
    my putLine ""
    my putLine "$command $class"
    my putLine "============================="
    my putLine [ $class getDoc $command ]
    my putLine "Arguments:"
    if { "[ $class getArgs $command ][ $class getNonPosArgs $command ]" == "" } {
        my putLine "\tnone"
    }
    foreach arg [ $class getNonPosArgs $command ] {
        set type [ lindex [ split $arg : ] 1 ]
        set arg [ lindex [ split $arg : ] 0 ]
        if { "" == "$type" } { set type "optional" }
        my putLine "\t$arg - ($type) [ $class getArgument $command $arg ]"
    }

    foreach arg [ $class getArgs $command ] {
        my putLine "\t$arg - [ $class getArgument $command $arg ]"
    }
    my putLine "Returns:"
    foreach return [ $class getReturn $command ] {
        my putLine "\t$return"
    }
    if { "" != "[ string trim [ $class getExample $command ] ]" } {
        my putLine "Example:"
        my putLine "---------------------------------"
        my putLine [ $class getExample $command ]
        my putLine "---------------------------------"
    }
    my putLine  ""

    if { ! $done } { my prompt }
}

Shell instproc getCommands { pattern } {

    set objectAndCommand [ my getObjectAndCommand $pattern ]
    set endsWithSpace [ string match "* " $pattern ]

    if { "" != "$objectAndCommand" } {

        return [ my getObjectCommands [ lindex $objectAndCommand 0 ] [ lindex $objectAndCommand 1 ] [ lindex $objectAndCommand 2 ] $endsWithSpace ]
        
    } else {

        return [ my getLibraryCommands $pattern ]
    }

    set oldcode {

        set current 0
        set next 1

        set userObject [ lindex $pattern $current ]
        set object [ lindex $pattern $current ]

        if { ! [ string match ::* $object ] } {
            set object ::${object}
        }
        
        if [ my isobject $object ] {

            while { [ lsearch -exact [ $object info children ] ${object}::[ lindex $pattern $next ] ] != -1 } {

                set object ${object}::[ lindex $pattern $next ]
                set userObject "${userObject} [ lindex $pattern $next ]"
                incr current 
                incr next
            }

            return [ my getObjectCommands $object [ lrange $pattern $next end ] $userObject ]
        }

        return [ my getLibraryCommands $pattern ]

    }
}

Shell instproc getVariables { pattern } {

    my instvar environment 

    set last [ lindex $pattern end ]

    set length [ string length $last ]
    incr length

    if { ! [ string match "\$*" $last ] } { return }

    set variables [ $environment info vars ]

    set newVariables ""

    foreach variable $variables {

        if [ $environment array exists $variable ] { continue }

        if [ string match "${last}*" "\$$variable" ] {

            lappend newVariables "[ string range [ string trim $pattern ] 0 end-$length ] \$$variable"
        }
    }

    return $newVariables
}

Shell instproc getLibraryCommands { pattern } {

    my instvar language 

    catch {
        set commands [ $language info methods ]
        set commands [ $language getCommands ]
    }

    set commands [ ::xox::removeIfNot {

        string match ${pattern}* $command

    } command $commands ]

    return $commands
}

Shell instproc getObjectCommands { object pattern { objectName "" } endsWithSpace } {

    if { "$objectName" == "" } {

        set objectName $object
    }

    catch {
        set commands [ $object info methods ]
        set commands [ $object getCommands ]
    }
    if $endsWithSpace {
        set pattern "$pattern "
    }

    set commands [ ::xox::removeIfNot {

        string match ${pattern}* $command

    } command $commands ]

    if { [ llength $commands ] == 1 && "[ lindex $commands 0 ]" == "$pattern" && $endsWithSpace } {
        return ""
    }

    set commands [ ::xox::mapcar {

        ::xox::identity "$objectName $command"

    } command $commands ]

    return $commands
}

Shell instproc exit { args } {

    my done 1
}

Shell instproc writeHistory { } {

    my instvar history fileName 

    if { [ my doHistory ] && [ my exists fileName ] && "$fileName" != "" } {

        ::xox::writeFile $fileName [ join $history "\n" ]
        return $fileName
    }
}

Shell instproc executeScript { } {

    my instvar fileName

    set script [ ::xox::readFile $fileName ]

    set lines [ lrange [ split $script "\n" ] 0 end-1 ]

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

Shell instproc getArguments { command } {

    my instvar language 

    #puts getArguments

    set endsWithSpace [ string match "* " $command ]

    set objectAndCommand [ my getObjectAndCommand $command ]

    if { "" != "$objectAndCommand" } {

        set object [ lindex $objectAndCommand 0 ]
        set command [ lindex $objectAndCommand 1 ]
        set userObject "[ lindex $objectAndCommand 2 ] "
        #puts "$object $command $userObject $endsWithSpace"
        if $endsWithSpace {
            set command "$command "
        }

    } else {

        set object $language
        set command $command
        set userObject ""
    }

    if [ catch {
        set method [ lindex $command 0 ]

        if $endsWithSpace {
            set commandSoFar [ string range $command 0 end-1 ]
            set argNumber [ llength $command ]
            incr argNumber -1
            set lastArg ""
        } else {
            set commandSoFar [ lrange $command 0 end-1 ]
            set argNumber [ llength $command ]
            incr argNumber -2
            set lastArg [ lindex $command end ]
        }
        set argumentNames [ [ ::xox::ObjectGraph findFirstImplementationClass $object $method ] info instargs $method ]
        set currentArgName [ lindex $argumentNames $argNumber ]
        if { $argNumber >= [ llength $argumentNames ] && "[ lindex $argumentNames end ]" == "args" } {
            set currentArgName args
        }
    } error ] {
        #puts $error
        return
    }

    #puts ":${endsWithSpace}:"
    #puts ":${command}:"
    ##puts ":${method}:"
    #puts ":${argNumber}:"
    #puts ":${lastArg}:"
    #puts ":${currentArgName}:"

    return [ my getObjectArguments $object $method $currentArgName $commandSoFar $lastArg $userObject ]
}

Shell instproc getObjectArguments { object method currentArgName commandSoFar lastArg userObject } {

    set getter "getValues@${method}@${currentArgName}"

    set return ""

    if { "[ $object info methods $getter ]" != "" } {

        foreach value [ eval [ list $object $getter ] [ lrange $commandSoFar 1 end ] ] {

            if { ! [ string match "${lastArg}*" $value ] } { continue }
            lappend return "$userObject$commandSoFar $value"
        }
    }

    return $return
}


}


