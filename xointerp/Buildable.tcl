# Created at Mon Apr 21 02:18:44 PM EDT 2008 by bthomass

namespace eval ::xointerp {

    Class Buildable 

    Buildable proc fixArgs { arguments } {

        if { [ llength $arguments ] == 1 } {

            return [ lindex $arguments 0 ]
        }

        return $arguments
    }

    Buildable instproc instMultilineSetter { name } {

        my instproc $name { args } [ subst {

            if { "\$args" == "" } {
                return \[ my set $name \]
            }
            return \[ my set $name \[ ::xointerp::Buildable fixArgs \$args \] \]
        } ]
    }

    Class instmixin add ::xointerp::Buildable
}


