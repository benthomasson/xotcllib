# Created at Fri Oct 17 18:44:57 EDT 2008 by ben

namespace eval ::xodsl {

    Class StringBuilding -superclass ::xotcl::Object

    StringBuilding @doc StringBuilding {

        Please describe the class StringBuilding here.
    }

    StringBuilding parameter {
        collector
        { collectors "" }
    }

    StringBuilding instproc appendString { args } {

        my instvar collector

        set value [ next ]
        if { [ my exists collector ] && [ self ] != [ self callingobject ] } {
            $collector append string "$value"
        }
        return $value
    }

    StringBuilding instproc installFilter { } {

        my filter appendString

        my filterguard appendString {
            [ self calledproc ] != "init" &&
            [ self calledproc ] != "configure" &&
            [ self calledproc ] != "instvar" &&
            [ self calledproc ] != "filter" &&
            [ self calledproc ] != "info" &&
            [ self calledproc ] != "collector" &&
            [ self calledproc ] != "collectors" &&
            [ self calledproc ] != "evaluateStringScript" &&
            [ self calledproc ] != "evaluateInternalStringScript" 
        }

        return
    }

    StringBuilding instproc removeFilter { } {

        my filter delete appendString

        return
    }

    StringBuilding instproc evaluateStringScript { script } {

        my instvar environment 

        my installFilter

        ::xoexception::try { 

            $environment eval $script

        } finally {

            my removeFilter
        }
    }

    StringBuilding instproc evaluateInternalStringScript { script } {

        my instvar environment collector collectors

        lappend collectors $collector

        set collector [ Object new -set string "" ]

        ::xoexception::try { 

            $environment eval $script

        } finally {

            set string [ $collector set string ]
            set collector [ lindex $collectors end ]
            set collectors [ lrange $collectors 0 end-1 ]
        }

        return $string
    }

    StringBuilding instproc mysubst { script } {

        my instvar environment collector collectors

        lappend collectors $collector

        set collector [ Object new -set string "" ]

        ::xoexception::try { 

            set string [ $environment eval "subst {$script}" ]

        } finally {

            set collector [ lindex $collectors end ]
            set collectors [ lrange $collectors 0 end-1 ]
        }

        return $string
    }
}


