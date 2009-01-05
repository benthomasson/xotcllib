# Created at Sun Oct 26 15:43:13 EDT 2008 by ben

namespace eval ::xoweb {

    ::xoweb::ApplicationClass create ProcedureInspector -superclass ::xoweb::Application

    ProcedureInspector @doc ProcedureInspector {

        Please describe the class ProcedureInspector here.
    }

    ProcedureInspector parameter {

    }

    ProcedureInspector instproc initialLoad { -procedure } { } {

        my instvar url

        if { ! [ info exists procedure ] } {

            return [ ::xoweb::makePage { } {
                html {
                    new XowebCSS 
                    div -class object {

                        h1 ' Procedure Inspector

                        ul foreach proc [ lsort -dictionary [ ::info procs ::* ] ] {
                            li a -href "?procedure=[ cleanUpLink $proc ]" ' $proc
                        }
                    }
                }
            } ]
        }

        return [ ::xoweb::makePage { } {
                html {
                    new XowebCSS 
                    div -class object {

                        h1 ' Procedure Inspector
                        
                        ' $procedure
                    }
                }
        } ]

    }
}


