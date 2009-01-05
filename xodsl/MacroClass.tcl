# Created at Wed Oct 29 01:39:01 EDT 2008 by ben

namespace eval ::xodsl {

    Class MacroClass -superclass ::xotcl::Object

    MacroClass @doc MacroClass {

        Please describe the class MacroClass here.
    }

    MacroClass parameter {

    }

    MacroClass instproc instmacro { name args } {

        if { [ llength $args ] == 2 } {
            set nonposargs ""
            set posargs [ lindex $args 0 ]
            set body [ lindex $args 1 ]
        } elseif { [ llength $args ] == 3 } {
            set nonposargs [ lindex $args 0 ]
            set posargs [ lindex $args 1 ]
            set body [ lindex $args 2 ]
        } else {
            error "Incorrect arguments to instmacro: should be 'name posargs body'"
        }

        set map ""

        foreach arg $nonposargs {

            set arg [ string range [ lindex $arg 0 ] 1 end ]

            lappend map "%$arg"
            lappend map "\$$arg"
        }

        foreach arg $posargs {

            set arg [ lindex $arg 0 ]

            lappend map "%$arg"
            lappend map "\$$arg"
        }

        my instproc $name $nonposargs $posargs [ subst {
            my instvar environment
            set body \[ string map "$map" {$body} \]
            \$environment eval \$body
            return 
        } ]
    }
}


