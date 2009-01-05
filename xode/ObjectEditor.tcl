# Created at Tue Dec 23 14:08:03 EST 2008 by ben

namespace eval ::xode {

    ::xox::SingletonClass create ObjectEditor -superclass ::xotcl::Object

    ObjectEditor @doc ObjectEditor {

        Please describe the class ObjectEditor here.
    }

    ObjectEditor parameter {
        { message "#Editing \\\$object which is an instance of \\\[ \\\$object info class \\\]
#All lines starting with # are ignored.
#Each line contains one variable and value pair.
#Save and exit to change values: (ESC):wq(ENTER)"}
    }

    ObjectEditor instproc edit { -noninteractive:switch } { object } {

        my instvar message 

        package require fileutil

        set tempfile [ ::fileutil::tempfile /tmp/object ]

        set out [ open $tempfile w ]

        puts $out [ subst $message ]

        foreach var [ $object info vars ] {

            if [ $object array exists $var ] { 
                foreach index [ lsort [ $object array names ] ] {
                    puts $out "$var($index) {[ $object set $var($index) ]}"
                }
            } elseif [ $object exists $var ] {
                puts $out "$var {[ $object set $var ]}"
            } else {
                puts $out $var
            }
        }

        flush $out
        close $out

        if { ! $noninteractive } {
            package require Expect
            spawn -noecho vim $tempfile
            interact
        }

        set data [ ::xox::readFile $tempfile ]
        set lines [ split $data "\n" ]
        set line ""
        while { "" != "$lines" } {
            set nextLine [ string trim [ lindex $lines 0 ] ]
            set lines [ lrange $lines 1 end ]
            if { "" == "$nextLine" } { continue }
            if { "" == "$line" && [ string match #* $nextLine ] } { continue }
            append line $nextLine
            if [ info complete $line ] {
                set var [ lindex $line 0 ]
                set value [ lindex $line 1 ]
                $object set $var $value
                set line ""
            } else {
                append line "\n"
            }
        }

        file delete $tempfile
    }
}


