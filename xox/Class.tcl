
package require XOTcl

namespace eval ::xotcl {

    Class # Class description {

        Class is a meta-class that creates new classes.
        To make a new class use:

        Class YourClass

        You can then make instances from that class.

        set someInstance [YourClass new ]

        To make a new meta-class use:

        Class SingletonClass -superclass Class

        SingletonClass instproc getInstance { } {

            return [ my new ]
        }

        This can then be used to make new classes with special
        properties. 

        SingletonClass Server

        This can then be used to make new instances:

        set instance [ Server getInstance ]
    }

    Class instmixin add ::xox::MetaData

    Class # parameter id { holds the CVS ID of the class } 

    Class parameter { 
        { id "" }
    }

    Class # instproc id description {

        Sets the CVS id of the class. This is useful for 
        versioning code.
    }

    Class # parameter version { extracts the version from the CVS ID }

    Class instproc version { } {

        my instvar id
        set version [ lindex $id 2 ]

        if { "" == "$version" } {

            return 1.0
        }

        return $version
    }

    Class instproc getID { } {

        my instvar id
        if { "" == "$id" } {

            return "Id:"
        }
        return [ string trim [ string range $id 1 end-1 ] ]
    }

    Class instproc classParameter { variable } {

        my instproc $variable "{ $variable \"\" }" "

        if { \"\" == \"\$$variable\" } {

            if { ! \[ my exists $variable \] } {

                set classList \[ my info class \]

                set classList \[ concat \$classList \[ \$classList info heritage \] \]

                foreach class \$classList {

                    if \[ \$class exists $variable \] {

                        return \[ \$class set $variable \]
                    }
                }

                error \"Could not find $variable in any of \$classList!\"

            } else {

                return \[ my set $variable \]
            }
        }
            
        if { \"\" == \"\$$variable\" } { return \[ my set $variable \] }

        return \[ my set $variable \$$variable \]
    "

    }

    Class instproc classParameterArray { variable } {

        my instproc $variable " index { $variable \"\" }" "

        if { \"\" == \"\$$variable\" } {

            if { ! \[ my exists ${variable}(\$index) \] } {

                set classList \[ my info class \]

                set classList \[ concat \$classList \[ \$classList info heritage \] \]

                foreach class \$classList {

                    if \[ \$class exists ${variable}(\$index) \] {

                        return \[ \$class set ${variable}(\$index) \]
                    }
                }

                error \"Could not find $variable in any of \$classList!\"

            } else {

                return \[ my set ${variable}(\$index) \]
            }
        }
            
        if { \"\" == \"\$$variable\" } { return \[ my set ${variable}(\$index) \] }

        return \[ my set ${variable}(\$index) \$$variable \]
    "
    }

    Class instproc getPackage { } {
        
        set namespace [ namespace qualifiers [ self ] ]

        while { ! [ ::xotcl::Object isobject $namespace ] } {

            if { "" == "$namespace" } {

                error "No package found"
            }

            set namespace [ namespace qualifiers $namespace ]
        }

        return $namespace
    }

    Class instproc garbageCollect { }  {

        #do not garbage collect classes
    }

    Class instproc unknown { args } {

        error "[ self ] Unknown command: \"$args\""
    }

    Class proc unknown { args } {

        return [ uplevel [ self ] create $args ]
    }

}

