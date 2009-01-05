# Created at Sat Oct 25 22:17:12 EDT 2008 by ben

namespace eval ::xoweb {

    ::xoweb::ApplicationClass create ClassInspector -superclass ::xoweb::Application

    ClassInspector @doc ClassInspector {

        Please describe the class ClassInspector here.
    }

    ClassInspector parameter {

    }

    ClassInspector instproc initialLoad { -object } {

        my instvar url root

        #::xoweb reload

        if { ! [ info exists object ] } {

            return [ ::xoweb::makePage { } {
                add ::xoweb::XowebLanguage
                basicPage -title "Class Inspector" {
                    new XowebCSS
                    div -class object {
                        h1 ' Class Inspector
                        form -action "" -method GET {
                            input -name "object" -type text -value ""
                            input -value "Type a Class" -type submit
                        }
                        form -action "$root/search" -method GET {
                            input -name "text" -type text -value ""
                            input -name "method" -value Search_Classes -type hidden
                            input -value "Find a Class" -type submit
                        }

                        hr 

                        h3 ' Select a Class

                        ul foreach class [ lsort -dictionary [ ::xox::ObjectGraph findAllInstances ::xotcl::Class ] ] {

                            li a -href "?object=[ cleanUpLink $class ]" ' $class
                        }
                    }
                }
            } ]
        }

        return [ ::xoweb::makePage {
            ClassDoc cDoc {
                 ObjectInspectorLink oLink {
                     url $root/classinspector
                 }
            }
        } {
                add ::xoweb::XowebLanguage
                basicPage -title "Class Inspector: $object" {
                    new XowebCSS -width 80%
                    use cDoc -object $object
                }
        } ]
    }
}


