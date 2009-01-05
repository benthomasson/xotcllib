
namespace eval ::xox {

    Class MetaData

    MetaData instproc @parameter { parameter text } {

        my set "@parameter($parameter)" $text
    }

    MetaData instproc @arg { method arg text } {

        my set "@arg($method $arg)" $text
    }

    MetaData instproc @args { method arguments } {

        my set "@args($method)" $arguments
    }

    MetaData instproc @nonposargs { method arguments } {

        my set "@nonposargs($method)" $arguments
    }

    MetaData instproc @example { method text } {

        my set "@example($method)" $text
    }

    MetaData instproc @command { method text } {

        my set "@command($method)" $text
    }

    MetaData instproc @return { method text } {

        my lappend "@return($method)" $text
    }

    MetaData instproc @author { author } {

        my lappend "@author" $author
    }

    MetaData instproc @changes { date change } {

        my lappend "@changes($date)" $change
    }

    MetaData instproc @see { method see } {

        my lappend "@see($method)" $see
    }

    MetaData instproc @date { date } {

        my lappend "@date" $date
    }

    MetaData instproc @tag { method tag } {

        my lappend "@tag($method)" $tag 
        my lappend "@tagged($tag)" $method 
    }

    MetaData instproc hasTag { method tag } {

        if { ! [ my exists @tag($method) ] } { return 0 }

        return [ expr { [ lsearch -exact [ my set @tag($method) ] $tag ] != -1 } ]
    }

    MetaData instproc getTagged { tag } {

        if { ! [ my exists @tagged($tag) ] } { return "" }
        return [ lsort -unique [ my set @tagged($tag) ] ]
    }

    MetaData instproc @@doc { token doc } {

        error "@@doc call: Please load xodocument first"
    }

    MetaData instproc  getCommand { method } {

        if [ my exists @command($method) ] {

            return [ my set @command($method) ]
        }

        return $method
    }

    MetaData instproc getSee { token } {

        if [ my exists "@see($token)" ] {

            return [ lsort -unique [ my set "@see($token)" ] ]
        }

        return ""
    }

    MetaData instproc  getParameter { parameter } {

        if [ my exists "@parameter($parameter)" ] {

            return [ my set "@parameter($parameter)" ]
        }

        return ""
    }

    MetaData instproc  getArgument { method arg } {

        if { [ llength $arg ] == 2 } {

            return [ lindex $arg 1 ]
        }

        if [ my exists "@arg($method $arg)" ] {

            return [ my set "@arg($method $arg)" ]
        }

        return ""
    }

    MetaData instproc  getDoc { method } {

        if [ my exists #($method) ] {

            return "    [ string trim [ my set #($method) ] ]"
        }

        return ""
    }

    MetaData instproc  getReturn { method } {

        if [ my exists @return($method) ] {

            return [ my set @return($method) ]
        }

        return none
    }

    MetaData instproc  getExample { method } {

        if [ my exists @example($method) ] {

            return [ string trim [ ::xox::MetaData removeLeftSpace [ my set @example($method) ] ] "\n\r" ]
        }

        return ""
    }

    MetaData instproc getClassNonPosArgs { method } {

        set args [ my info nonposargs $method ] 

        if [ my exists @nonposargs($method) ] {

            set args [ concat [ my set @nonposargs($method) ] $args ]
        }

        return $args
    }

    MetaData instproc getClassArgs { method } {

        set args [ my info args $method ] 

        if { "$args" == "args" } {

            if [ my exists @args($method) ] {

                return [ my set @args($method) ]
            } 

            return "args"
        }

        return $args
    }

    MetaData instproc  getNonPosArgs { method } {

        set args [ my info instnonposargs $method ] 

        if [ my exists @nonposargs($method) ] {

            set args [ concat [ my set @nonposargs($method) ] $args ]
        }

        return $args
    }

    MetaData instproc  getArgs { method } {

        catch {
            set args args
            set args [ my info instargs $method ] 
        }

        if { "$args" == "args" } {

            if [ my exists @args($method) ] {

                return [ my set @args($method) ]
            } 

            return "args"
        }

        return $args
    }

    MetaData proc removeLeftSpace { text } {

        set lines [ split $text "\n" ]

        set spaces ""
        set first ""
        foreach line $lines {

            set first $line 
            if { "" != "[ string trim $line ]" } { break }
        }

        foreach char [ split $first {} ] {

            if { "$char" == " " } {

                append spaces $char
            } else {
                break
            }
        }

        set length [ string length $spaces ]

        set newLines ""

        set first 1

        foreach line $lines {

            if { !$first } {

                append newLines "\n"
            }
            set first 0

            if [ string match ${spaces}* $line ] {

                append newLines [ string range $line $length end ]

            } else {

                append newLines $line
            }
        }

        return $newLines
    }
}
