# Created at Mon Oct 27 17:54:15 EDT 2008 by ben

namespace eval ::xoweb {

    Class MultiuserApplicationClass -superclass ::xoweb::ApplicationClass

    MultiuserApplicationClass @doc MultiuserApplicationClass {

        Please describe the class MultiuserApplicationClass here.
    }

    MultiuserApplicationClass parameter {
        root
        url
        args
    }

    MultiuserApplicationClass instproc processRequest { argumentList } {

        set user [ ::xoweb::User getXowebUser ]

        set instance [ my getInstance $user ]
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

    MultiuserApplicationClass instproc getInstance { user args } {

        my instvar root url

        if { ! [ my exists instances($user) ] } {

            my set instances($user) [ eval my new $args -set user [ ::xoweb::User getUser $user ] -root $root -url $url ]
        } 

        return [ my set instances($user) ]
    }

    MultiuserApplicationClass instproc installApplication { namespace root url args } {

        my installed 1

        namespace eval $namespace { 

        }

        my  args $args
        my  root $root
        my  url "${root}${url}"

        proc ${namespace}::${url} { args } [ subst {

             return \[ [ self ] processRequest \$args \]
        } ]

        ::Direct_Url ${root} ${namespace}::
    }
}


