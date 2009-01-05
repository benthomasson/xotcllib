# Created at Mon Jan 28 21:04:21 EST 2008 by bthomass

namespace eval ::xointerp {

    Class ModelBuildingInterpreter -superclass ::xointerp::ObjectInterpreter  

    ModelBuildingInterpreter # ModelBuildingInterpreter {

        Please describe the class ModelBuildingInterpreter here.
    }

    ModelBuildingInterpreter parameter {
        { object "" }
        { objects "" }
        { builderClass ::xointerp::ModelBuildingInterpreter }
        { callInit 0 }
    }

    ModelBuildingInterpreter instproc init { } {

        my instvar environment 

        if { ! [ my exists environment ] } {
            my environment [ Object new ]
        }
    }

    ModelBuildingInterpreter instproc tclEval { script } {

        my instvar objects 

        next

        return $objects
    }

    ModelBuildingInterpreter instproc evalCommand { level command { inString 0 } } {

        my instvar object 

        set newCommand [ string trim $command ]
        if { "$newCommand" == "" } { return }
        set commandName [ lindex $newCommand 0 ]

        if { "" == "$object" } {

            set class [ my findClass $commandName ] 

            if { "" != "$class" } {

                if { [ llength $newCommand ] == 2 } {

                    return [ my createNewObject $class [ lindex $newCommand 1 ] ]
                } 

                if { [ llength $newCommand ] == 3 } {

                    return [ my createNewNamedObject $class [ lindex $newCommand 1 ] [ lindex $newCommand 2 ] ]
                } 

                error "Error: incorrect number of arguments to $class\nShould be $class \[name\] { script } "

            } else {

                error "Error: $commandName is an unknown class name"
            }

        } else {

            set class [ my findClass $commandName ] 

            if { "" != "$class" } {

                if { [ llength $newCommand ] == 2 } {

                    return [ my createChildOf $class [ lindex $newCommand 1 ] ]
                }

                if { [ llength $newCommand ] == 3 } {

                    return [ my createNamedChildOf $class [ lindex $newCommand 1 ] [ lindex $newCommand 2 ] ]
                }

                error "Error: incorrect number of arguments to $class\nShould be $class \[name\] { script } "

            } else {

                if { "[ $object info methods $commandName ]" == "$commandName" } {

                    return [ my callMethod $newCommand ]

                } else {

                    return [ my setParameter $newCommand ]
                }
            }
        }
    }

    ModelBuildingInterpreter instproc newBuilder { object } {

        my instvar builderClass environment callInit

        return [ $builderClass new -object $object -environment $environment -callInit $callInit ]
    }

    ModelBuildingInterpreter instproc createNewObject { class body } {

        set object [ $class new -noinit ]
        set childBuilder [ my newBuilder $object ]

        $childBuilder tclEval $body

        $childBuilder destroy
        if { [ lsearch -exact [ my objects ] $object ] == -1 } {
            my lappend objects $object
        }
        if [ my callInit ] {
            $object init
        }
        return $object
    }

    ModelBuildingInterpreter instproc createNewNamedObject { class name body } {

        if [ my isobject $name ] {
            set object $name
            set created 0
        } else {
            set object [ $class create $name -noinit ]
            set created 1
        }
        set childBuilder [ my newBuilder $object ]

        $childBuilder tclEval $body

        $childBuilder destroy
        if { [ lsearch -exact [ my objects ] $object ] == -1 } {
            my lappend objects $object
        }
        if { [ my callInit ] && $created } {
            $object init
        }
        return $object
    }

    ModelBuildingInterpreter instproc createChildOf { class body } {

        my instvar object 

        set child [ $class new -childof $object -noinit ]
        set childBuilder [ my newBuilder $child ]

        $childBuilder tclEval $body

        $childBuilder destroy
        if { [ my callInit ] } {
            $child init
        }
        return $child
    }

    ModelBuildingInterpreter instproc createNamedChildOf { class name body } {

        my instvar object 

        if [ my isobject ${object}::${name} ] {

            set child ${object}::${name}
            set created 0
        } else {
            set child [ $class create ${object}::${name} -noinit ]
            set created 1
        }
        set childBuilder [ my newBuilder $child ]

        $childBuilder tclEval $body

        $childBuilder destroy
        if { [ my callInit ] && $created } {
            $child init
        }
        return $child
    }

    ModelBuildingInterpreter instproc callMethod { command } {

        my instvar object environment

        return [ $environment eval $object $command ]
    }

    ModelBuildingInterpreter instproc setParameter { command } {

        my instvar object environment

        return [ $environment eval $object set $command ]
    }

    ModelBuildingInterpreter instproc findClass { name } {

        if { "$name" == "Object" } {

            return ::xotcl::Object
        }

        return ""
    }

    ModelBuildingInterpreter instproc addToModel { model script } {

        my set object $model
        my tclEval $script 
        return $model
    }
}


