# Created at Sat Oct 25 22:17:12 EDT 2008 by ben

namespace eval ::xoweb {

    ::xoweb::ApplicationClass create ObjectInspector -superclass ::xoweb::Application

    ObjectInspector @doc ObjectInspector {

        Please describe the class ObjectInspector here.
    }

    ObjectInspector parameter {

    }

    ObjectInspector instproc initialLoad { -object } {

        my instvar root


        #::xoweb reload

        if { ! [ info exists object ] } {

            return [ ::xoweb::makePage { } {

                html {
                    new XowebCSS 
                    div -class object {
                        h1 ' Object Inspector
                        form -action "" -method GET {
                            input -name "object" -type text -value ""
                            input -value "Select Object" -type submit
                        }
                    }
                }
            } ]
        }

        return [ ::xoweb::makePage { 
            ObjectDoc oDoc {
                 ObjectInspectorLink oLink {
                     url $root/classinspector
                 }
            }
        } {
                html {
                    new XowebCSS -width 80%
                    use oDoc -object $object
                }
        } ]
    }
}


