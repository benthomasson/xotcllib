
namespace eval ::xointerp {

    Class NodeBuilding 

    NodeBuilding instproc createChildOf { class body } {

        my instvar object 

        set child [ $object createNewChild $class -noinit ]
        set childBuilder [ my newBuilder $child ]

        $childBuilder tclEval $body

        $childBuilder destroy
        if { [ my callInit ] } {
            $child init
        }
        return $child
    }

    NodeBuilding instproc createNamedChildOf { class name body } {

        my instvar object 

        if [ my isobject ${object}::${name} ] {

            set child ${object}::${name}
            set created 0
        } else {
            set child ${object}::${name}
            $class create $child -noinit -nodeName $name -nodeOrder [ $object incr nextChildNodeOrder ] 
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
}
