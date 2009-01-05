
namespace eval ::xox {

    Class Args

    namespace import -force ::xotcl::*

    Class ParseArgs 

    ParseArgs proc parse { arguments } {

        return [ eval my new $arguments ]
    }

    ParseArgs proc getArgsObject { flags arguments } {

        set object [ Object new ]


        $object proc unknown { name args } {

            if { [ llength $args ] == 0 } {
                my set $name 1
            } else {
                my set $name $args
            }
        }

        eval $object configure $arguments

        foreach var [ $object info vars ] {

            $object parametercmd $var
        }

        foreach flag $flags {

            $object proc $flag { } [ subst {

                if \[ my exists $flag \] {
                    return \[ my set $flag \]
                } else {
                    return 0
                }
            } ]
        }

        $object proc unknown { args } {

            return ""
        }

        return $object
    }

    ParseArgs proc configureScope { arguments } {

        set object [ Object new ]

        my configureObject $object $arguments

        foreach var [ $object info vars ] {

            if [ $object array exists $var ] {
                if [ uplevel [ list info exists $var ] ] { uplevel [ list unset $var ] }
                foreach index [ $object array names $var ] {
                    uplevel [ list set ${var}(${index}) [ $object set ${var}(${index}) ] ]
                }
            } elseif [ $object exists $var ] {
                if [ uplevel [ list array exists $var ] ] { uplevel [ list unset $var ] }
                uplevel [ list set $var [ $object set $var ] ]
            } else {
                #do nothing for declared variables
            }
        }

        $object destroy
    }

    ParseArgs proc configureObject { object arguments } {

        [ eval my new $arguments ] configureObject $object
    }

    ParseArgs instproc extractToObject { object vars } {

        foreach var $vars {

            if { ![ my exists $var ] } { continue }

            $object set $var [ my set $var ]
        }
    }

    ParseArgs instproc configureObject { object } {

        foreach var [ my info vars ] {

            if { [ my array exists $var ] } {
                $object array set $var [ my array get $var ]
            } else {
                $object set $var [ my set $var ]
            }
        }
    }


    ParseArgs instproc unknown { name args } {

        if { [ llength $args ] == 0 } {
            my set $name 1
        } else {
            my set $name $args
        }
    }
}


