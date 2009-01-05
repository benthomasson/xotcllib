# Created at Thu Oct 23 12:01:20 EDT 2008 by ben

namespace eval ::xohtml {

    Class ApplicationClass -superclass ::xohtml::SingletonClass

    ApplicationClass @doc ApplicationClass {

        Please describe the class ApplicationClass here.
    }

    ApplicationClass parameter {

    }

    ApplicationClass instproc processRequest { argumentList } {
        
        set instance [ my getInstance ]
        set method initialLoad
        set arguments ""

        foreach { arg value } $argumentList {

            if { "method" == "$arg" } {

                set method $value
            } else {
                lappend arguments -${arg} $value
            }
        }

        catch { 
            set return [ eval $instance $method $arguments  ]
        }  return 

        return $return
    }
}


