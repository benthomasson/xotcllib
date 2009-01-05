# Created at Mon Apr 21 01:01:36 PM EDT 2008 by bthomass

namespace eval ::xointerp {

    Class SimpleObjectModelBuilder -superclass ::xointerp::ModelBuildingInterpreter

    SimpleObjectModelBuilder @doc SimpleObjectModelBuilder {

        Please describe the class SimpleObjectModelBuilder here.
    }

    SimpleObjectModelBuilder parameter {
        { errorMessage "" }
    }

    SimpleObjectModelBuilder instproc buildObject { object script } {

        my object $object
        my tclEval $script
        return $object
    }

    SimpleObjectModelBuilder instproc findClass { name } {

        return ""
    }

    SimpleObjectModelBuilder instproc setParameter { command } {

        my instvar errorMessage

        error "Invalid command: $command\n$errorMessage\n"
    }
}


