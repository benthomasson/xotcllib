# Created at Sun Oct 19 17:29:49 EDT 2008 by ben

namespace eval ::xodsl {

    ::xodsl::ModelBuildingLanguageClass create NamespaceObjectBuildingLanguage -superclass ::xodsl::ObjectBuildingLanguage

    NamespaceObjectBuildingLanguage @doc NamespaceObjectBuildingLanguage {

        Please describe the class NamespaceObjectBuildingLanguage here.
    }

    NamespaceObjectBuildingLanguage parameter {
        { packages ""}
    }

    NamespaceObjectBuildingLanguage @tag init hidden

    NamespaceObjectBuildingLanguage instproc init { } {
        next

        set classes ""

        foreach package [ my packages ] {

            set classes [ concat $classes [ ::xox::ObjectGraph findAllInstances ::xotcl::Class ::${package} ] ]
        }

        foreach class $classes {

            my proc [ namespace tail $class ] { name { script "" } } [ subst {
                my buildInstance $class \$name \$script
            } ]
        }
    }

    NamespaceObjectBuildingLanguage @tag buildNewObject hidden

    NamespaceObjectBuildingLanguage instproc buildNewObject { class } {

        my instvar object 

        set object [ $class new ]
        [ my info class ] updateEnvironment [ self ]
        [ my info class ] updateObjectEnvironment [ self ]
    }
}


