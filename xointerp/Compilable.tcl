# Created at Sun Sep 07 10:01:25 EDT 2008 by bthomass

namespace eval ::xointerp {

    Class Compilable -superclass ::xointerp::Interpretable

    Compilable @doc Compilable {

        Please describe the class Compilable here.
    }

    Compilable parameter {
    }

    Compilable instproc compilableProcs { } {

        return [ list if while for foreach time ] 
    }

    Compilable instproc if { compiler arguments } {

        set code ""

        foreach { keyword condition script } [ concat if $arguments ] {

            if { "$keyword" == "else" } {

                set script $condition

                append code [ subst { else {
                    [ $compiler compileScript $script ]
                } } ]
            }

            if { "$keyword" == "elseif" } {

                append code [ subst { elseif { [ $compiler compileEnvironmentExpression $condition ] } {
                    [ $compiler compileScript $script ]
                } } ]
            }

            if { "$keyword" == "if" } {
                append code [ subst { if { [ $compiler compileEnvironmentExpression $condition ] } {
                    [ $compiler compileScript $script ]
                }} ]
            }
        }

        return $code
    }

    Compilable instproc while { compiler arguments } {

        set condition [ lindex $arguments 0 ]
        set body [ lindex $arguments 1 ]

        set code ""

        append code [ subst { while { [ $compiler compileEnvironmentExpression $condition ] } {
            [ $compiler compileScript $body ]
        } } ]

        return $code
    }

    Compilable instproc for { compiler arguments } {

        set start [ lindex $arguments 0 ]
        set condition [ lindex $arguments 1 ]
        set next [ lindex $arguments 2 ]
        set body [ lindex $arguments 3 ]

        set code ""

        append code [ subst { for { [ $compiler compileScript $start ] } { [ $compiler compileEnvironmentExpression $condition ] } { [ $compiler compileScript $next ] } {
            [ $compiler compileScript $body ]
        } } ]

        return $code
    }

    Compilable instproc foreach { compiler arguments } {

        set arguments [ ::xointerp::TclLanguage commandToList $arguments ]

        #puts $arguments

        set varLists ""

        foreach { aVar aList } [ lrange $arguments 0 end-1 ] {
            set var [ $compiler prepareArgument $aVar ]
            set list [ $compiler prepareArgument $aList ]
            append varLists "$var $list "
        }

        set body [ lindex $arguments end ]

        set environment [ $compiler environment ]

        #puts $body

        set code ""

        append code [ subst { $environment eval { foreach $varLists {
            [ $compiler compileScript $body ]
        } } } ] 

        return $code
    }

    Compilable instproc time { compiler arguments } {

        set script [ lindex $arguments 0 ]
        set count [ lindex $arguments 1 ]

        set environment [ $compiler environment ]

        set code ""

        append code [ subst { $environment eval { time {
            [ $compiler compileScript $script ]
        } $count } } ]

        return $code
    }
}


