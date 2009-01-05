# Created at Sun Oct 26 15:49:44 EDT 2008 by ben

namespace eval ::xoweb {

    ::xoweb::ApplicationClass create NamespaceInspector -superclass ::xoweb::Application

    NamespaceInspector @doc NamespaceInspector {

        Please describe the class NamespaceInspector here.
    }

    NamespaceInspector parameter {

    }

    NamespaceInspector instproc initialLoad { -namespace } { } {

        if { ! [ info exists namespace ] } {

            return [ ::xoweb::makePage { } {
                html {
                    new XowebCSS 
                    div -class object {

                        h1 ' Namespace Inspector

                        form -action "" -method GET {
                            input -name "namespace" -type text -value ""
                            input -value "Type a Namespace" -type submit
                        }

                        hr 

                        h2 ' Select a Namespace

                        ul foreach namespace [ lsort -dictionary [ ::namespace children :: ] ] {
                            li a -href "?namespace=[ cleanUpLink $namespace ]" ' $namespace
                        }
                    }
                }
            } ]
        }

        return [ ::xoweb::makePage { } {
                html {
                    new XowebCSS 
                    div -class object {

                        h1 ' Namespace Inspector
                        
                        ' $namespace
                    }
                }
        } ]

    }
}


