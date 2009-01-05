
namespace eval ::xox { 

Class create Script -superclass { ::xotcl::Object }
  
Script @doc Script {
    Script is a class for building object scripts.
}
       
Script parameter {
    { name "script" }
    { evalName "" }
    { commands "" }
    { scope "" }
    { scopeClass ::xotcl::Object }
    { parameters "" }
} 

Script instproc getScope { } {

    my instvar scope scopeClass

    if { ! [ my isobject $scope ] } {

        set scope [ $scopeClass new ]
    }

    return $scope
}

Script instproc evalCommands { } {

    set scope [ my getScope ]

    return [ $scope eval [ my getScript ] ]
}

Script instproc getScript { } {

    return [ join [ my getCommands ] "\n" ]
}

Script instproc getCommands { } {

    return [ my commands ] 
}

Script instproc getCommand { index } {

    return [ lindex [ my commands ] $index ]
}

Script instproc setCommand { index command } {

    my instvar commands
    lset commands $index $command
}

Script instproc insertCommand { index command } {

    my instvar commands
    set commands [ linsert $commands $index $command ]
}

Script instproc addCommand { command } {

    my lappend commands "$command"
}

Script instproc removeLastCommand { } {

    my instvar commands

    set commands [ lrange $commands 0 end-1 ]
}

Script instproc addEvalCommand { command } {

    my addCommand $command
    
    return [ my evalCommand $command ]
}

Script instproc evalCommand { command } {

    return [ [ my getScope ] eval $command ]
}

Script instproc generateScript { } {

    my instvar name 

    return [ subst {
package require xox
package require [ ::xox::Package getMainPackage [ [ my getScope ] info class ] ]

[ my generateObjectCreate "" ]
[ string trim [ my generateParameters $name ] ]
$name objectEval {
[ my generateEvalScript ]
}
    } ]
}

Script instproc generateObjectCreate { prefix } {

    my instvar name

    return [ subst {[ [ my getScope ] info class ] create ${prefix}::${name}
    } ]
}

Script instproc generateParameters { name } {

    return [ subst {[ ::xox::mappend {
    ::xox::identity "$name set $param \n"
} param [ my parameters ] ]
} ]
}

Script instproc getEvalName { } {

    my instvar name evalName

    if { "" == "$evalName" } {

        return $name
    }

    return $evalName
}

Script instproc generateEvalScript { } {

    return [ subst { 
[ my getScript ]
    } ]
}

Script instproc regsubCommand { command pattern variable } {

    return [ regsub -all "\\m${pattern}\\M" $command $variable ]
}

Script instproc parameterize { pattern variable } {

    my lappend parameters [ list $variable $pattern ]

    set commands ""

    foreach command [ my commands ] {

        lappend commands [ my regsubCommand $command $pattern "\$$variable" ]
    }

    my commands $commands
}

}


