# Created at Tue Jun 05 17:06:43 EDT 2007 by bthomass


namespace eval ::xox {

    namespace import -force ::xotcl::*

    Class AutoLoadSuperClass 

    AutoLoadSuperClass # AutoLoadSuperClass {

        Mixin class that automatically loads the package that
        contains the superclass if that package exists.  

        The package is determined by the full namespace name
        of the class.

        Example:

        Class:

        ::xounit::TestCase

        Package:

        xounit::TestCase

        This follows the standard naming conventions set by xotcllib. 
        This class also solves the problem of loading the superclasses
        before the subclasses.
    }

    AutoLoadSuperClass # superclass {


        Set the superclass for a class and load the superclass if
        it is not yet loaded.
    }

    AutoLoadSuperClass instproc autoLoadClass { class } {

        #my debug "class: $class"
        ::xox loadClass $class
    }

    AutoLoadSuperClass instproc superclass { superclasses } {

        #my debug "superclasses: $superclasses"

        foreach superclass $superclasses {

            if { ! [ uplevel ::xotcl::Object isclass $superclass ] } {

                my autoLoadClass $superclass
            }
        }

        return [ next ]
    }

    AutoLoadSuperClass instproc instmixin { args } {

        if { [ llength $args ] == 1 } {

            foreach instmixin [ lindex $args 0 ] {

                if { ! [ uplevel ::xotcl::Object isclass $instmixin ] } {
                    my autoLoadClass $instmixin
                }
            }

            return [ next ]
        }

        if { "[ lindex $args 0 ]" == "add" } {

        foreach instmixin [ lrange $args 1 end ] {

            #my debug "instmixin: $instmixin"

            if { ! [ uplevel ::xotcl::Object isclass $instmixin ] } {
                my autoLoadClass $instmixin
            }
        }
        }

        return [ next ]
    }

    ::xotcl::Class instmixin add ::xox::AutoLoadSuperClass
}


