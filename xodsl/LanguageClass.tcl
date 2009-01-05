# Created at Fri Oct 17 03:28:28 PM EDT 2008 by bthomass

namespace eval ::xodsl {

    Class LanguageClass -superclass ::xotcl::Class

    LanguageClass @doc LanguageClass {

        A LanguageClass defines a new language.  This is a meta-class.
    }

    LanguageClass @doc createLanguage {

        Creates an instance from a LanguageClass Class.
    }
    
    LanguageClass @arg createLanguage name { The name of the instance }
    LanguageClass @arg createLanguage args { Initialization arguments }

    LanguageClass instproc createLanguage { name args } {

        set environment [ Object new ]
        set language [ eval my create $name $args [ list -set environment $environment ] ]

        my updateEnvironment $language

        return $language
    }

    LanguageClass instproc newLanguage { args } {

        set environment [ Object new ]
        set language [ eval my new $args [ list -set environment $environment ] ]

        my updateEnvironment $language

        return $language
    }

    LanguageClass instproc updateEnvironment { language } {

        set environment [ $language set environment ]
        set globalProcs [ lsort -unique [ $language set globalProcs ] ]

        foreach method [ $language info methods ] {

            if { [ lsearch -sorted $globalProcs $method ] == -1 } {
                $environment forward $method $language $method
            }
        }
    }

    LanguageClass instproc newEnvironment { language } {

        set environment [ Object new ]
        set globalProcs [ lsort -unique [ $language set globalProcs ] ]

        foreach method [ $language info methods ] {

            if { [ lsearch -sorted $globalProcs $method ] == -1 } {
                $environment forward $method $language $method
            }
        }

        return $environment
    }

    LanguageClass instproc publishLanguage { scope namespace } {

        set environment [ ::xodsl::NullEnvironment new -scope $scope -namespace $namespace ]
        set language [ my new -set environment $environment ]

        my publishCommandsToNamespace $language $namespace

        return $language
    }

    LanguageClass instproc publishCommandsToNamespace { language namespace } {

        set globalProcs [ lsort -unique [ $language set globalProcs ] ]

        set protectedProcs [ lsort {set return info class} ]

        foreach method [ $language getCommands ] {

            if { [ lsearch -sorted $globalProcs $method ] == -1 && [ lsearch -sorted $protectedProcs $method ] == -1 } {
                if { "[ info procs ${namespace}::${method} ]" == "${namespace}::${method}" } {
                    puts "WARNING: Redefining ${namespace}::${method}"
                    flush stdout
                } elseif { "[ info commands ${namespace}::${method} ]" == "${namespace}::${method}" } {
                    puts "WARNING: Redefining ${namespace}::${method}"
                    flush stdout
                } else {
                    #puts "NOTICE: Installing ${namespace}::${method}"
                    flush stdout
                }
                proc ${namespace}::${method} { args } [ subst {
                    uplevel $language $method \$args
                } ]
            }
        }
    }
}


