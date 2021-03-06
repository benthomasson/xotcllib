# Created at Tue May 29 18:14:08 EDT 2007 by bthomass


namespace eval ::xox {

    namespace import -force ::xotcl::*

    Class HigherOrderTcl -superclass ::xotcl::Object

    HigherOrderTcl # HigherOrderTcl {

        Higher order Tcl is a collection of functions (not procedures).
        Functions are different than procedures in that they are 
        deterministic and have no side effects.  This allows for 
        efficient, bug-free, and very quickly written code that is 
        known as functional programming.
    }

    HigherOrderTcl # genvar {

        Generates a new unique variable name that will not
        conflict with existing variables.  This is useful
        in higher order procedures.
    }

    HigherOrderTcl proc genvar { {name "" } } {

        return [ ::xox::GenerateVariable generateVariable $name ]
    }

    HigherOrderTcl # freevar {

        Frees the memory of a variable generated by ::xox::genvar.
        freevar also returns the value of the variable before
        it was freed.
    }

    HigherOrderTcl proc freevar { name } {

        return [ ::xox::GenerateVariable free $name ]
    }

    HigherOrderTcl # mapcar {

        Runs script for each element of a list with the element
        set to name for each iteration. mapcar returns a new
        list from the results of each script.

        Example:
        mapcar { expr { 1 + $x }}  x { 1 2 3 4 5 }
        =>
        {2 3 4 5 6}
    }

    HigherOrderTcl proc mapcar { script name list } {

        #my debug "$script $name $list"

        set temp [ ::xox::genvar ]

        set full "

            set $temp {}

            foreach $name {$list} {
                lappend $temp \[ eval { 
                    $script 
                    } \]
            }

            return \[ ::xox::freevar $temp \]
            
            "

        #my debug $full

        uplevel $full
    }

    HigherOrderTcl proc mappend { script name list } {

        #my debug "$script $name $list"

        set temp [ ::xox::genvar ]

        set full "

            set $temp {}

            foreach $name {$list} {
                append $temp \[ eval { 
                    $script 
                    } \]
            }

            return \[ ::xox::freevar $temp \]
            
            "

        #my debug $full

        uplevel $full
    }

    HigherOrderTcl # removeIfNot {

        Creates a new list that only contains elements
        where script returns true.  Each element in the
        list is set to name for each iteration of script.

        Example:

        removeIfNot { oddp $x } x {1 2 3 4 5} 
        => {1 3 5}
    }

    HigherOrderTcl proc removeIfNot { script name list } {

        set temp [ ::xox::genvar ]

        set full "
            set $temp {}

            foreach $name {$list} {

                if \[ eval { $script } \] {

                    lappend $temp \[ set $name \]
                }
            }

            return \[ ::xox::freevar $temp \]

            "

        #my debug $full

        uplevel $full
    }

    HigherOrderTcl # removeIf {

        Creates a new list that has all elements
        where script returns true removed.  Each element in the
        list is set to name for each iteration of script.

        Example:

        removeIf { oddp $x } x {1 2 3 4 5} 
        => {2 4}
    }

    HigherOrderTcl proc removeIf { script name list } {

        set temp [ ::xox::genvar ]

        set full "
            set $temp {}

            foreach $name {$list} {

                if { ! \[ eval { $script } \] } {

                    lappend $temp \[ set $name \]
                }
            }

            return \[ ::xox::freevar $temp \]

            "

        #my debug $full

        uplevel $full
    }

    HigherOrderTcl # oddp {

        Predicate that tests if x is oddp.
    }

    HigherOrderTcl proc oddp { x } {

        expr { $x % 2 == 1} 
    }

    HigherOrderTcl # evenp {

        Predicate that tests if x is even.
    }

    HigherOrderTcl proc evenp { x } {

        expr { $x % 2 == 0} 
    }

    HigherOrderTcl # withOpenFile {

        Opens a file in a direction and stores in the handle in handle,
        then runs script, then flushes (if appropriate), and closes
        then file. withOpenFile will close the file even if script
        causes an error.
    }

    HigherOrderTcl proc withOpenFile { file direction handle script } {

        set error [ ::xox::genvar ]

        uplevel "
            set $handle \[ open $file $direction \]

            if \[ catch {

            $script

            } $error \] {

                if { \"$direction\" == \"w\"  } { flush \$$handle }
                if { \"$direction\" == \"w+\" } { flush \$$handle }
                if { \"$direction\" == \"a\" } { flush \$$handle }
                if { \"$direction\" == \"a+\" } { flush \$$handle }
                close \$$handle

                error \[ ::xox::freevar $error \]
            } else {

                if { \"$direction\" == \"w\"  } { flush \$$handle }
                if { \"$direction\" == \"w+\" } { flush \$$handle }
                if { \"$direction\" == \"a\" } { flush \$$handle }
                if { \"$direction\" == \"a+\" } { flush \$$handle }
                close \$$handle
            }
            "
    }

    HigherOrderTcl # readFile {

        Opens, reads, and closes a file.  readFile then returns the data
        held in the file.
    }

    HigherOrderTcl proc readFile { file } {


        set data ""

        set file [ open $file r ]
        set data [ read $file ]
        close $file

        return $data
    }

    HigherOrderTcl # appendFile {

        Opens, appends a string, and closes a file.  
    }

    HigherOrderTcl proc appendFile { file string } {

        set data ""

        ::xox::withOpenFile $file a toAppend {

            puts $toAppend $string
        }
    }

    HigherOrderTcl # writeFile {

        Opens, writes a string, and closes a file.  
    }

    HigherOrderTcl proc writeFile { file string } {

        set data ""

        ::xox::withOpenFile $file w toWrite {

            puts $toWrite $string
        }
    }

    HigherOrderTcl proc identity { x } {

        return $x 
    }

    HigherOrderTcl proc first { list } {

        return [ lindex $list 0 ]
    }

    HigherOrderTcl proc second { list } {

        return [ lindex $list 1 ]
    }

    HigherOrderTcl proc startsWith { string pattern } {

        return [ string match "${pattern}*" $string ]
    }

    HigherOrderTcl proc ifEmpty { value script } {

        if { "$value" == "" } {

            set result ""

            return -code [ catch { uplevel $script } result ] -errorinfo $::errorInfo $result
        }
    }

    HigherOrderTcl proc lambda { arguments body } {

        return [ ::xox::Lambda generateLambda $arguments $body ]
    }

    HigherOrderTcl proc flet { name arguments body script } {

        #my debug "$name $arguments $body $script"

        set lambda ""

        if { [ info commands $name ] != "" } {
            set lambda [ ::xox::Lambda nextName ]
            rename $name $lambda
        }

        set result ""

        set code [ catch {

            uplevel [ list proc $name $arguments $body ]
            uplevel $script

        } result ]

        if { "" != "$lambda" } {

            rename $name {}
            rename $lambda $name
        }

        return -code $code -errorinfo $::errorInfo $result
    }

    HigherOrderTcl proc let { varValues script } {

        foreach varValue $varValues {

            set var [ lindex $varValue 0 ]
            set value [ lindex $varValue 1 ]

            if [ uplevel info exists $var ] {
 
                set oldValue($var) [ uplevel [ list set $var ] ]
            }

            uplevel [ list set $var $value ]
        }

        set code [ catch {

            uplevel $script

        } result ]
        set savedInfo $::errorInfo

        foreach varValue $varValues {

            set var [ lindex $varValue 0 ]
            set value [ lindex $varValue 1 ]

            if [ info exists oldValue($var) ] {
               uplevel [ list set $var $oldValue($var) ]
            } else {
                uplevel [ list unset $var ]
            }
        }

        return -code $code -errorinfo $savedInfo $result
    }

    #Install HigherOrderTcl procs into the xox namespace

    foreach proc [ ::xox::HigherOrderTcl info procs ] {

        namespace export $proc
        ::xox @doc $proc [ ::xox::HigherOrderTcl get# $proc ]

        proc ::xox::$proc { args } [ subst {

            set result {}

            return -code \[ catch { uplevel ::xox::HigherOrderTcl $proc \$args} result \] -errorinfo \$::errorInfo \$result
        } ]
    }
}


