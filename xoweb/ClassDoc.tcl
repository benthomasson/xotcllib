# Created at Thu Oct 23 20:52:27 EDT 2008 by ben

namespace eval ::xoweb {

    ::xoweb::ApplicationClass create ClassDoc -superclass ::xoweb::Application

    ClassDoc @doc ClassDoc {

        Please describe the class ClassDoc here.
    }

    ClassDoc parameter {

    }

    ClassDoc instproc initialLoad { -class } { } {

        #::xoweb reload

        if { ! [ info exists class ] } {

            return [ ::xoweb::makePage { } {
                add ::xoweb::XowebLanguage
                basicPage -title "Class Doc" {
                    h1 ' Class Doc
                    form -action "" -method GET {
                        input -name "class" -type text -value ""
                        input -value "Select Class" -type submit
                    }
                }
            } ] 
        }

        return [ ::xoweb::makePage { } {
                add ::xoweb::XowebLanguage
                basicPage -title $class {
                    new ClassDoc -object $class
                }
        } ]
    }
}


