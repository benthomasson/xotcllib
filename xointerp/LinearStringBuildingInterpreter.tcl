# Created at Mon Aug 25 18:15:26 EDT 2008 by bthomass

namespace eval ::xointerp {

    Class LinearStringBuildingInterpreter -superclass ::xointerp::ObjectInterpreter

    LinearStringBuildingInterpreter @doc LinearStringBuildingInterpreter {

        Please describe the class LinearStringBuildingInterpreter here.
    }

    LinearStringBuildingInterpreter parameter {
        { string "" }
    }

    LinearStringBuildingInterpreter instproc buildString { script } {

        my string ""
        [ my library ] interpreter [ self ]
        [ my library ] collector [ self ]

        my tclEval $script

        return [ my string ]
    }

    LinearStringBuildingInterpreter instproc buildStringWithCollector { script collector } {

        [ my library ] interpreter [ self ]
        [ my library ] collector $collector

        my tclEval $script
    }
}


