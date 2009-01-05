
package require XOTcl

namespace eval ::xotcl {

    Object instproc objectEval { script } {

        set lines [ split $script "\n" ]

        set index 0
        set length [ llength $lines ]

        while { $index < $length } {

            set command [ lindex $lines $index ]
            incr index

            while { ! [ info complete $command ] } {

                append command "\n"
                append command [ lindex $lines $index ]
                incr index
                if { $index >= $length } {
                    break
                }
            }

            my eval $command
        }
    }

    Object instproc garbageCollect { } {

        my debug "Destroying [ self ] who is a [ my info class ]"

        my destroy
    }

    Object instproc . { paramName args } {

        if { [ llength $args ] == 0 } {

            return [ my $paramName ]
        }
        
        if { "." == "[ lindex $args 0 ]" } {

            return [ eval {[ my $paramName ]} $args ]
        }

        return [ eval my {$paramName} $args ]
    }

    Object instproc # { args } {

        set key [ lindex $args 0 ]
        set comment [ lindex $args end ]

        return [ my set "#($key)" $comment ]
    }

    Object instproc @doc { args } {

        set key [ lindex $args 0 ]
        set comment [ lindex $args end ]

        return [ my set "#($key)" $comment ]
    }

    Object instproc get# { args } {

        if { ! [ my exists "#($args)" ] } { return }
        return [ my set "#($args)" ]
    }

    Object instproc getClean# { args } {

        if { ! [ my exists "#($args)" ] } { return }
        set doc [ my set "#($args)" ]

        foreach line [ split $doc "\n" ] {

            set checkLine [ string trim $line ]

            if { [ string first "#" $checkLine ] == 0 } {

                set line [ string range $checkLine 1 end ]
            } 

            append newDoc $line
            append newDoc "\n"
        }

        return $newDoc
    }

    Object instproc methodTag { } {

        return "[ self callingclass ] [ self callingproc ]"
    }

    Object instproc shell { } {

        set commands ""

        catch { unset continuedCommand }

        set index 0
        while { 1 } {

            if [ info exists continuedCommand ] {
                puts -nonewline "[ self ] $index + "
                flush stdout
                set command [ gets stdin ]
                append continuedCommand "\n"
                append continuedCommand $command

                if { ! [ info complete $continuedCommand ] } {
                    continue
                }
                set command $continuedCommand
                unset continuedCommand
            } else {
                puts -nonewline "[ self ] $index % "
                flush stdout
                set command [ gets stdin ]
                set continuedCommand $command

                if { ! [ info complete $continuedCommand ] } {
                    continue
                }
                set command $continuedCommand
                unset continuedCommand
            }

            incr index
            if { "$command" == "exit" } {
                puts "[ self ] eval \{"
                puts [ join $commands "\n" ]
                puts "\}"
                break 
            }
            lappend commands $command
            if [ catch {
            puts [ my eval $command ]
            } result ] {

                puts $result
            }
        }
    }

    Object instproc ? { { command "?" } } {

        if [ uplevel #0 ::xotcl::Object isclass $command ] {

            return [ $command getClean# [ namespace tail $command ] ]
        }

        if [ uplevel #0 ::xotcl::Object isobject $command ] {

            return [ my ?object $command ]
        }

        set class [ ::xox::ObjectGraph findFirstImplementationClass [ self ] $command ]

        if { "" == "$class" } {

            my debug "No method found named $command."
            return

        }

        set help \
"
$class $command

[ ::xox::ObjectGraph findFirstComment [ self ] $command ]"

        catch {

        set args [ $class info instargs $command ]

        append help \
"
Example:
"

        append help "\$o $command"

        foreach arg $args {

            if { "$arg" == "args" } {

                append help " ..."
                continue
            }

            append help " \$$arg"
        }

        append help "\n"
        }


        my debug $help
    }

    Object instproc ?object { { object "" } } {

        if { "" == "$object" } {

            set object [ self ]

        } else {

            if { ! [ Object isobject $object ] } {

                my debug "$object is not an object"
                return
            }

            $object ?object
            return
        }
        
       set buffer "==============================================\n"
       append buffer "$object is a [ $object info class ]\n"

       foreach var [ lsort -dictionary [ my info vars ] ] {

           if [ my array exists $var ] {

           append buffer "$var: [ my array get $var ]\n"
           } else {
           append buffer "$var: [ my set $var ]\n"
           }
       }
       append buffer "==============================================\n"

       my debug $buffer
    }

    Object instproc ?code { command } {


        set class [ ::xox::ObjectGraph findFirstImplementationClass [ self ] $command ]

        if { "$class" == "" } {

            my debug "No command $command found in [ self ] [ self info class ]"
            return
        }

        my debug \
"$class instproc $command { [ $class info instargs $command ] } { [ $class info instbody $command ] }"

    }

    Object instproc ?methods { { prefix "" } } {

        if { "" != "$prefix" } {

        if [ uplevel #0 ::xotcl::Object isclass $prefix ] {

            set class $prefix

            set buffer "Methods available on $class\n\n"

            foreach method [ lsort -dictionary [ $class info instprocs ] ] {

                set comment [ $class getClean# $method ]
                set shortComment [ string trim [ lindex [ split $comment "." ] 0 ] ]

                append buffer "$method - $shortComment\n"
            }

            my debug $buffer
            return
        }

        }

        set buffer "Methods available on [ self ], a [ my info class ]\n\n"

        foreach method [ lsort -dictionary [ my info methods ] ] {

            if { "$prefix" != "" } {
            if { [ string first $prefix $method ] != 0 } { continue }
            }

            set comment [ ::xox::ObjectGraph findFirstComment [ self ] $method ]
            set shortComment [ string trim [ lindex [ split $comment "." ] 0 ] ]

            append buffer "$method - $shortComment\n"
        }

        my debug $buffer
    }

    Object instproc setParameterDefaults { } {

        set classes [ my info precedence ]

        for { set loop [ llength $classes ] } { $loop >=0 } { incr loop -1 } {

            set class [ lindex $classes $loop ]
            if { "" == "$class" } { continue }
            if { ! [ $class array exists __defaults ] } { continue }

            foreach parameter [ $class array names __defaults ] {

                my set $parameter [ $class set __defaults($parameter) ]
            }
        }
    }

    Object # Object {

        Object is the base class for all classes in XOTcl.
        Object can be used to make new objects.

        set instance [ Object new ]

        Object can be used as the ultimate superclass:

        Class SomeClass -superclass Object

        Note this is the same as: 

        Class SomeClass 
    }

    Object # . { Dereference method.
        
    Allows this notation to be used:

    $object . variableName . subvariableName . subsub 

    This would get the value of subsub in the object subvariableName
    in variableName in object.  The above is equivalent to

    [ [ [ $object variableName ] subvariableName ] subsub ]

    This only works for variables that have parameter methods
    accessing them.   Otherwise this method will error.

    }

    Object # # { Comment method.

    This method allows the association and retrieval of comments with
    anything method or just the object itself.  These 
    comments will be carried inside the object in memory.
    This method is most useful in Class objects for 
    commenting instprocs, instfilters, instforward, etc.
    It also allows for documentation programs to use
    introspection to grab the comments associated with a
    certain method.  This frees the documentation programs
    from having to reparse the code when XOTcl already
    does a perfectly good job of that. 

    Example:

    Class Car

    Car # drive {Car will return "vroooom"}

    Car instproc drive { } {

        return "vroooom"
    }

    This comment can be accessed by issuing:

    Car get# drive 

    This will return the full comment:

    instproc drive Car will return "vroooom"

    Interesting note:  Since the comment is carried
    along with the object in memory the comments can 
    be accessed at anytime using introspection.  Possible
    uses for these are very detailed debugging messages, 
    or online help when using xotclsh.  It also
    allows for comments to be sent "over the wire" if 
    combined with serialization.  

    }

    Object # ? { Help method.

    The help method, ?, allows the developer to access
    the class documentation while writing the code.  This
    is useful if experimenting with code in a debugger
    or tcl shell.  

    Usage:

    $o ? 

    This will return this message.

    $o ? set

    This will return the help message for the "set" method.

    Also see:
        ?methods
        ?code
        ?object

    }

    Object # ?methods { Help on all available methods. 

    This command will print a list of methods available on this
    object. It will also print the first sentence of the documentation
    associated with that method.

    }

    Object # ?code { Print the code for a method.

    This command will find and print the code associated with a method on this
    object. 
    
    }

    Object # Object {  
        
        This class holds the pre-defined  methods available for 
        all XOTcl objects. All these methods are also available 
        on classes. }

    Object # abstract { 
        
        Specify an abstract method for class/object with arguments. 
        An abstract method specifies an interface and returns an 
        error, if it is invoked directly. Sub-classes or mixins
        have to override it. }

    Object # copy {

         Perform a deep copy of the object/class (with all
         information, like class, parameter, filter, etc) to
         "newName". }

    Object # hasclass { 

         Test whether the argument is either a mixin or instmixin
         of the object or if it is on the class hierarchy of the
         object. This method combines the functionalities of istype
         and ismixin.}

    Object # move {
        
         Perform a deep move of the object/class (with all
         information, like class, parameter, filter, etc) to
         "newName". }

    Object # append {  
        
    Append to variable.

    append varName ?value value value ...?

    Example:

    set var 0
    for {set i 1} {$i<=10} {incr i} {
           append var "," $i
    }
    puts $var
    # Prints 0,1,2,3,4,5,6,7,8,9,10

        }

    Object # array { 
        
    Manipulate array variables.

    array anymore arrayName searchId 
    array donesearch arrayName searchId 
    array exists arrayName 
    array get arrayName ?pattern? 
    array names arrayName ?mode? ?pattern? 
    array nextelement arrayName searchId 
    array set arrayName list 
    array size arrayName 
    array startsearch arrayName 
    array statistics arrayName 
    array unset arrayName ?pattern? 
    }

    Object # autoname {

        autoname creates an automatically assigned name. 
        It is constructed from the base name plus an index, that is
        incremented for each usage. E.g.: 
        
        $obj autoname a

        produces a0, a1, a2, ... Autonames may have format strings
        as in the Tcl 'format' command. E.g.:

        $obj autoname a%06d

        produces a000000, a000001, a000002, ...
        
        
        }

    Object # check {

        Turn on/off assertion checking. Options argument is the
        list of assertions, that should be checked on the object
        automatically. Per default assertion checking is turned off.
         
        Examples: 
        
        o check {};         # turn off assertion checking on object o  
        o check all;        # turn on all assertion checks on object o   
        o check {pre post}; # only check pre/post assertions
        }

    Object # class {

        Changes the class of an object dynamically to newClass.  }

    Object # cleanup {

        Resets an object or class into an initial state, as after
        construction. Called during recreation process by the
        method 'recreate'
    }

    Object # configure {

    Calls the '-' methods. I.e. evaluates arguments and 
    calls everything starting with '-' (and not having a
    digit a second char) as a method. Every list element
    until the next '-' is interpreted as a method argument.
    configure is called before the constructor during
    initialization and recreation. E.g.

    Object o -set x 4

    here:

    o configure -set x 4

    is executed.
    }

    Object # destroy {

    Standard destructor. Can be overloaded for customized 
    destruction process. Actual destruction is done by instdestroy.
    "destroy" in principal does:

    Object instproc destroy args {
       [my info class] instdestroy [self]
    }


    }

    Object # eval {
        
    Eval args in the scope of the object. That is local variables
    are directly accessible as Tcl vars.

    }

    Object # extractConfigureArg {

    Check an argument list separated with '-' args, as for 
    instance configure arguments, and extract the argument's
    values. Optionally, cut the whole argument.

    }

    Object # exists {

    Check for existence of the named instance variable on the object.

    }

    Object # filter {

    If $args is one argument, it specifies a list of filters to be
    set. Every filter must be an XOTcl proc/instproc within the
    object scope. If $args it has more argument, the first one
    specifies the action. Possible values are set, get, add or
    delete, it modifies the current settings as indicated. For more
    details, check the tutorial.

    }

    Object # filterguard {

    Add conditions to guard a filter registration point. The filter
    is only executed, if the guards are true. Otherwise we ignore
    the filter. If no guards are given, we always execute the filter.

    }

    Object # filtersearch { 

    Search a full qualified method name that is currently registered
    as a filter. Return a list of the proc qualifier format: 
    'objName|classname proc|instproc methodName'.

    }

    Object # forward {

    Register a method (similar to a proc) for forwarding calls to a
    callee (target tcl command, other object). If the forwarder
    method is called, the actual arguments of the invocation are
    appended to the specified arguments. In callee an arguments
    certain substituions can take place:

    * %proc: subsituted by name of the forwarder method
    * %self: subsituted by name of the object
    * %1: subsituted by first argument of the invocation
    * %%: a single percent.
    * %tcl-command: command to be executed; substituted by result.

    Additionally each argument can be prefixed by the positional 
    prefix %@POS (note the delimiting space at the end) that can
    be used to specify an explicit position. POS can be a positive
    or negative integer or the word end. The positional arguments
    are evaluated from left to right and should be used in ascending
    order. valid Options are:

    * -objscope causes the target to be evaluated in the scope of
        the object,
    * -methodprefix string inserts the specified prefix in front of
        the second argument of the invocation,
    * -default is used for default method names (only in connection
        with %1)

    See tutorial for detailed examples.
    }

    Object # incr { 

    Increments the value stored in the variable whose name is 
    varName. The new value is stored as a decimal string in variable
    varName and also returned as result. Wrapper to the same named
    Tcl command (see documentation of Tcl command with the same name
    for details).

    }

    Object # info {

    *  Introspection of objects. The following options can be
    specified:  objName info args method: Returns the arguments of
    the specified proc (object specific method).
    * objName info body method: Returns the body of the specified
    proc (object specific method).
    * objName info class ?classname?: Returns the name of the class
    of the current object, if classname was not specified, otherwise
    it returns 1 if classname matches the object's class and 0 if not.
    * objName info children ?pattern?: Returns the list of aggregated
    objects with fully qualified names if pattern was not specified,
    otherwise it returns all children where the object name matches
    the pattern.
    * objName info commands ?pattern: Returns all commands defined
    for the object if pattern was not specified, otherwise it returns
    all commands that match the pattern.
    * objName info default method arg var: Returns 1 if the argument
    arg of the proc (object specific method) method has a default
    value, otherwise 0. If it exists the default value is stored in
    var.
    * objName info filter: Returns a list of filters. With -guard
    modifier all filterguards are integrated ( objName info filter 
    -guards). With -order modifier the order of filters (whole 
    hierarchy) is printed.
    * objName info filterguard name: Returns the guards for filter
    identified by name.
    * objName info hasNamespace: From XOTcl version 0.9 on,
    namespaces of objects are allocated on demand. hasNamespace
    returns 1, if the object currently has a namespace, otherwise 0.
    The method requireNamespace can be used to ensure that the
    object has a namespace.
    * objName info info: Returns a list of all available info options
    on the object.
    * objName info invar: Returns object invariants.
    * objName info metadata ?pattern?: Returns available metadata
    options.
    * objName info methods: Returns the list of all methods currently
    reachable for objName. Includes procs, instprocs, cmds, 
    instcommands on object, class hierarchy and mixins. Modifier 
    -noprocs only returns instcommands, -nocmds only returns procs. 
    Modifier -nomixins excludes search on mixins.
    * objName info mixin: Returns the list of mixins of the object. 
    With -order modifier the order of mixins (whole hierarchy) is 
    printed.
    * objName info nonposargs methodName: Returns non-positional arg
    list of methodName
    * objName info parent: Returns parent object name 
    (or "::" for no parent), in fully qualified form.
    * objName info post methodName: Returns post assertions of 
    methodName.
    * objName info pre methodName: Returns pre assertions of 
    methodName.
    * objName info procs ?pattern?: Returns all procs defined for 
    the object if pattern was not specified, otherwise it returns 
    all procs that match the pattern.
    * objName info vars ?pattern?: Returns all variables defined for
    the object if pattern was not specified, otherwise it returns all
    variables that match the pattern.

    }

    Object # invar {

    Binds an variable of the object to the current method's scope. 
    Example:

        kitchen proc enter {name} {
            my instvar persons
            set persons($name) [clock seconds]
        }

    Now persons can be accessed as a local variable of the method.
    A special syntax is: {varName aliasName}. This gives the variable
    with the name varName the alias aliasName. This way the variables
    can be linked to the methods scope, even if a variable with that
    name already exists in the scope.

    }

    Object @doc @doc {
     Comment method.

    This method allows the association and retrieval of comments with
    anything method or just the object itself.  These 
    comments will be carried inside the object in memory.
    This method is most useful in Class objects for 
    commenting instprocs, instfilters, instforward, etc.
    It also allows for documentation programs to use
    introspection to grab the comments associated with a
    certain method.  This frees the documentation programs
    from having to reparse the code when XOTcl already
    does a perfectly good job of that. 

    Example:

    Class Car

    Car @doc drive {Car will return "vroooom"}

    Car instproc drive { } {

        return "vroooom"
    }

    This comment can be accessed by issuing:

    Car get# drive 

    This will return the full comment:

    Car will return "vroooom"

    Interesting note:  Since the comment is carried
    along with the object in memory the comments can 
    be accessed at anytime using introspection.  Possible
    uses for these are very detailed debugging messages, 
    or online help when using xotclsh.  It also
    allows for comments to be sent "over the wire" if 
    combined with serialization.  
    }

    Object @doc ?object {

        Inspect an object.  This method will do introspection
        on an object and find all the data on that object.
        If no object is given it uses self.

        Example:

        ?object

        or

        ?object ::xotcl::__#0
    }


Object @doc lappend {

    Append list elements onto a variable.

    lappend varName ?value value value ...?

    Example:

    % set var 1
    1
    % lappend var 2
    1 2
    % lappend var 3 4 5
    1 2 3 4 5

}

Object @doc subst {

    Perform backslash, command, and variable substitutions.

    subst ?-nobackslashes? ?-nocommands? ?-novariables? string

    Example:

    set a 44
    subst {xyz {$a}}
        => {xyz {44}}

}

Object @doc set {

    Read and write variables.
    
    set varName ?value?

    Example:

    set r [expr rand()]

}

Object @doc unset {

    Delete variables.

    unset ?-nocomplain? ?--? ?name name name ...?

    Example:

    set a 5
    unset a

}
}


