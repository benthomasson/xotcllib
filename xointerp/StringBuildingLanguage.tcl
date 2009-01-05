# Created at Sun Feb 10 11:26:02 EST 2008 by bthomass

namespace eval ::xointerp {

    Class StringBuildingLanguage -superclass ::xointerp::Interpretable

    StringBuildingLanguage # StringBuildingLanguage {

        Please describe the class StringBuildingLanguage here.
    }

    StringBuildingLanguage parameter {
        interpreter
        collector
    }

    StringBuildingLanguage instproc evalWrite { args } {

        my instvar interpreter collector

        if { [ llength $args ] == 1 } {
            set args [ lindex $args 0 ]
        }

        $collector append string [ my iEval $interpreter $args ]

        return
    }

    StringBuildingLanguage instproc write { args } {

        my instvar interpreter collector

        if { [ llength $args ] == 1 } {
            set args [ lindex $args 0 ]
        }

        $collector append string $args

        return
    }

    StringBuildingLanguage instproc ' { args } {

        my instvar interpreter collector

        if { [ llength $args ] == 1 } {
            set args [ lindex $args 0 ]
        }

        $collector append string $args

        return
    }
}


