# Created at Thu Feb 07 01:25:00 PM EST 2008 by bthomass

namespace eval ::xointerp {

    Class ClassModelBuildingInterpreter -superclass ::xointerp::ModelBuildingInterpreter

    ClassModelBuildingInterpreter # ClassModelBuildingInterpreter {

        Please describe the class ClassModelBuildingInterpreter here.
    }

    ClassModelBuildingInterpreter parameter {

        { builderClass ::xointerp::ClassModelBuildingInterpreter }
    }

    ClassModelBuildingInterpreter instproc findClass { name } {

        if { "Object" == "$name" } { return "::xotcl::Object" }
        if { "Class" == "$name" } { return "::xotcl::Class" }

        if { [ my isclass $name ] } { return $name } 

        set package [ ::xox::Package getPackageFromClass $name ]

        if  { "" == "$package" } { return "" }

        catch { package require $package }

        if { [ my isclass $name ] } { return $name } 

        return ""
    }
}


