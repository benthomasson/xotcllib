# Created at Sun Oct 19 16:44:40 EDT 2008 by bthomass

namespace eval ::xodsl {

    ::xodsl::ModelBuildingLanguageClass create ObjectBuildingLanguage -superclass ::xodsl::Language

    ObjectBuildingLanguage @doc ObjectBuildingLanguage {

        Please describe the class ObjectBuildingLanguage here.
    }

    ObjectBuildingLanguage parameter {

    }

    ObjectBuildingLanguage @tag useObject hidden

    ObjectBuildingLanguage instproc useObject { new } {

        my instvar object 

        set object $new
        [ my info class ] updateEnvironment [ self ]
        [ my info class ] updateObjectEnvironment [ self ]
    }

    ObjectBuildingLanguage @tag buildNewObject hidden

    ObjectBuildingLanguage instproc buildNewObject { } {

        my instvar object 

        set object [ Object new ]
        [ my info class ] updateEnvironment [ self ]
        [ my info class ] updateObjectEnvironment [ self ]
    }

    ObjectBuildingLanguage @tag buildInstance hidden

    ObjectBuildingLanguage instproc buildInstance { class name script } {

        my instvar object environment

        if { "" == "$script" } {

            set script $name
            set name ""
        }

        if { "" == "$name" } {
            set child [ $class new -childof $object ]
        } else {
            set child [ $class create ${object}::${name} ]
        }

        set childBuilder [ my newBuilder $child ]
        set childEnvironment [ $childBuilder set environment ]
        $childEnvironment eval $script
        catch { $childBuilder destroy }
        catch { $childEnvironment destroy }
    }

    ObjectBuildingLanguage @tag newBuilder hidden

    ObjectBuildingLanguage instproc newBuilder { child } {

        my instvar environment

        set childBuilder [ [ my info class ] newLanguage -set object $child]
        set newEnv [ $childBuilder set environment ]
        ::xox::ObjectGraph copyObjectVariables $environment $newEnv
        ::xodsl::ObjectBuildingLanguage updateObjectEnvironment $childBuilder
        return $childBuilder
    }

    ObjectBuildingLanguage instproc Object { name { script "" } } {

        my buildInstance Object $name $script
    }
}


