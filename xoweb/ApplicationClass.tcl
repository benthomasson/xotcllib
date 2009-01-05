# Created at Thu Oct 23 12:01:20 EDT 2008 by ben

namespace eval ::xoweb {

    Class ApplicationClass -superclass ::xox::SingletonClass

    ApplicationClass @doc ApplicationClass {

        Please describe the class ApplicationClass here.
    }

    ApplicationClass parameter {
        { installed 0 }
        root
        url
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
        
        puts "$instance $method $arguments"

        if [ catch { 
            set return [ eval $instance $method $arguments  ]
        }  return ] {

            set return "<pre>$return\n$::errorInfo</pre>"
        }

        return $return
    }

    ApplicationClass instproc installApplication { namespace root url args } {

        my installed 1

        namespace eval $namespace { 

        }

        my root $root
        my url "${root}${url}"

        set instance [ my getInstance -root $root -url ${root}${url} ]
        $instance configure $args
        $instance root $root
        $instance url ${root}${url}

        proc ${namespace}::${url} { args } [ subst {

             return \[ [ self ] processRequest \$args \]
        } ]

        ::Direct_Url ${root} ${namespace}::
    }
}


