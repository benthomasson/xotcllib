# Created at Sun Feb 10 11:26:02 EST 2008 by bthomass

namespace eval ::xodsl {

    ::xodsl::LanguageClass create StringBuildingLanguage -superclass ::xodsl::Language

    StringBuildingLanguage # StringBuildingLanguage {

        Please describe the class StringBuildingLanguage here.
    }

    StringBuildingLanguage parameter {
        collector
    }

    StringBuildingLanguage @doc evalWrite {

        Evaluate the arguments and write the return value to the document.
    }

    StringBuildingLanguage @arg evalWrite args { Evaluate the arguments and write the return values to the document. }

    StringBuildingLanguage @example evalWrite {

        evalWrite expr { 1 + 1 }
        #OR
        evalWrite { expr { 1 + 1 } }
    }

    StringBuildingLanguage instproc evalWrite { args } {

        my instvar environment collector

        if { [ llength $args ] == 1 } {
            set args [ lindex $args 0 ]
        }

        $collector append string [ $environment eval $args ]

        return
    }

    StringBuildingLanguage @doc , {

        Evaluate the arguments and write the return value to the document.

        This command is syntatic sugar for evalWrite. It is written as a single comma.
    }

    StringBuildingLanguage @arg , args { Evaluate the arguments and write the return values to the document. }

    StringBuildingLanguage @example , {

        , expr { 1 + 1 }
        #OR
        , { expr { 1 + 1 } }
    }

    StringBuildingLanguage instproc , { args } {

        my instvar environment collector

        if { [ llength $args ] == 1 } {
            set args [ lindex $args 0 ]
        }

        $collector append string [ $environment eval $args ]

        return
    }

    StringBuildingLanguage @doc write {

        Write the arguments as strings to the document.
    }

    StringBuildingLanguage @arg write args { Write the arguments to the document as strings. }

    StringBuildingLanguage @example write {

        write "Hello World"
        #OR
        write Hello World
    }

    StringBuildingLanguage instproc write { args } {

        my instvar collector

        if { [ llength $args ] == 1 } {
            set args [ lindex $args 0 ]
        }

        $collector append string $args

        return
    }

    StringBuildingLanguage @doc ' {

        Write the arguments as strings to the document.

        This command is syntatic sugar for write.  It is written as a single quote.
    }

    StringBuildingLanguage @arg ' args { Write the arguments to the document as strings. }

    StringBuildingLanguage @example ' {

        ' "Hello World"
        #OR
        ' Hello World
    }

    StringBuildingLanguage instproc ' { args } {

        my instvar collector

        if { [ llength $args ] == 1 } {
            set args [ lindex $args 0 ]
        }

        $collector append string $args

        return
    }

}

