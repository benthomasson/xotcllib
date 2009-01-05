# Created at Thu Feb 07 01:48:33 PM EST 2008 by bthomass

namespace eval ::xointerp {

    Class NamespaceModelBuildingInterpreter -superclass ::xointerp::ClassModelBuildingInterpreter

    NamespaceModelBuildingInterpreter # NamespaceModelBuildingInterpreter {

        Please describe the class NamespaceModelBuildingInterpreter here.
    }

    NamespaceModelBuildingInterpreter parameter {

        { builderClass ::xointerp::NamespaceModelBuildingInterpreter }
        { namespaces "" }
    }

    NamespaceModelBuildingInterpreter instproc init { } {

        my instvar namespaces

        next

        foreach namespace $namespaces {

            catch { package require [ my getPackage $namespace ] }
        }
    }

    NamespaceModelBuildingInterpreter instproc findClass { name } {

        my instvar namespaces

        if { [ my isclass $name ] } { return $name } 

        foreach namespace $namespaces {

            if { [ my isclass ${namespace}::${name} ] } { return ${namespace}::${name} }
        }

        return ""
    }

    NamespaceModelBuildingInterpreter instproc getPackage { namespace } {

        set package $namespace

        if [ string match "::*" $package ] {

            set package [ string range $package 2 end ]
        }

        return $package
    }

    NamespaceModelBuildingInterpreter instproc newBuilder { object } {

        my instvar builderClass namespaces environment callInit

        return [ $builderClass new -object $object -namespaces $namespaces -environment $environment -callInit $callInit ]
    }
}


