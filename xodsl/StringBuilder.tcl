# Created at Sat Oct 18 14:53:32 EDT 2008 by ben

namespace eval ::xodsl {

    Class StringBuilder -superclass ::xotcl::Object

    StringBuilder @doc StringBuilder {

        Please describe the class StringBuilder here.
    }

    StringBuilder parameter {
        { string "" }
        language
        environment
    }

    StringBuilder instproc buildString { script } {

        my string ""
        [ my language ] collector [ self ]
        [ my environment ] eval $script
        return [ my string ]
    }

    StringBuilder instproc buildStringWithCollector { script collector } {

        [ my language ] collector $collector
        [ my environment ] eval $script
    }
}


