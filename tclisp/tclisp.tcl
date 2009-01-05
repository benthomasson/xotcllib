#Created by ben using ::xox::Template
 
package require xox
::xox::Package create ::tclisp
::tclisp id {$Id: tclisp.tcl,v 1.3 2008/01/03 06:34:07 bthomass Exp $}
::tclisp @doc tclisp {
Please describe tclisp here.
}
::tclisp @doc UsersGuide {

}
::tclisp requires {
    xounit
}
::tclisp exports {
    mapcar
    lambda
    removeIf
    removeIfNot
    oddp
    evenp
    identity
    let
    flet
    ifNull
    mappend
    nullp
    first
    second
    third
    forth
    withOpenFile
    readFile
    appendFile
    writeFile
}
::tclisp imports {
    
}
::tclisp loadFirst {
    
}
::tclisp executables {
    
}
namespace eval ::tclisp {

    proc identity { x } {

        return $x 
    }

    proc first { list } {

        return [ lindex $list 0 ]
    }

    proc second { list } {

        return [ lindex $list 1 ]
    }

    proc third { list } {

        return [ lindex $list 2 ]
    }

    proc forth { list } {

        return [ lindex $list 3 ]
    }

    proc startsWith { string pattern } {

        return [ string match "${pattern}*" $string ]
    }

    proc nullp { value } {

        return [ expr { "" == "$value" } ]
    }

    proc mapcar { function args } {

        set return ""
        set index 0

        foreach x [ first $args ] {

            set arguments ""

            foreach list $args {

                lappend arguments [ lindex $list $index ]
            }

            lappend return [ uplevel $function $arguments ]

            incr index
        }

        return $return
    }

    proc ifNull { value script } {

        if [ nullp $value ] {

            set result ""

            return -code [ catch { uplevel $script } result ] -errorinfo $::errorInfo $result
        }
    }

    proc lambda { arguments body } {

        return [ ::tclisp::Lambda generateLambda $arguments $body ]
    }

    proc oddp { x } {

        expr { $x % 2 == 1} 
    }

    proc evenp { x } {

        expr { $x % 2 == 0} 
    }

    proc let { varValues script } {

        foreach varValue $varValues {

            set var [ lindex $varValue 0 ]
            set value [ lindex $varValue 1 ]

            if [ uplevel info exists $var ] {
 
                set oldValue($var) [ uplevel set $var ]
            }

            uplevel set $var $value
        }

        set code [ catch {

            uplevel $script

        } result ]
        set savedInfo $::errorInfo

        foreach varValue $varValues {

            set var [ lindex $varValue 0 ]
            set value [ lindex $varValue 1 ]

            if [ info exists oldValue($var) ] {
               uplevel set $var $oldValue($var)
            } else {
                uplevel unset $var
            }
        }

        return -code $code -errorinfo $savedInfo $result
    }

    proc removeIfNot { function list } {

        set return ""

        foreach item $list {

            if [ uplevel $function [ list $item ] ] {

                lappend return $item
            }
        }

        return $return
    }

    proc removeIf { function list } {

        set return ""

        foreach item $list {

            if { ![ uplevel $function [ list $item ] ] } {

                lappend return $item
            }
        }

        return $return
    }

    proc mappend { function args } {

        return [ eval concat [ uplevel ::tclisp::mapcar $function $args ] ]
    }

    proc flet { name arguments body script } {

        my debug "$name $arguments $body $script"

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

    proc withOpenFile { file direction handle script } {

        set code [ catch {

        set fileHandle [ open $file $direction ]

            uplevel set $handle $fileHandle
            uplevel $script

        } result ]

        if { "$direction" == "w"  } { flush $handle }
        if { "$direction" == "w+" } { flush $handle }
        if { "$direction" == "a" } { flush $handle }
        if { "$direction" == "a+" } { flush $handle }
        close $fileHandle

        return -code $code -errorinfo $::errorInfo $result 
    }

    proc readFile { file } {


        set data ""

        ::xox::withOpenFile $file r toRead {

            set data [ read $toRead ]
        }

        return $data
    }

    proc appendFile { file string } {


        set data ""

        ::xox::withOpenFile $file a toAppend {

            puts $toAppend $string
        }
    }

    proc writeFile { file string } {

        set data ""

        ::xox::withOpenFile $file w toWrite {

            puts $toWrite $string
        }
    }
}

::tclisp loadAll


