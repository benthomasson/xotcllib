# Created at Thu Oct 23 20:12:41 EDT 2008 by ben

namespace eval ::xoweb {

    ::xoweb::ApplicationClass create CodeSearch -superclass ::xoweb::Application

    CodeSearch @doc CodeSearch {

        Please describe the class CodeSearch here.
    }

    CodeSearch parameter {

    }

    CodeSearch instproc initialLoad { args } {

        #::xoweb reload

        return [ ::xoweb::makePage { } {
                html {
                    new XowebCSS 
                    div -class object {
                        h1 ' CodeSearch
                        form -action "" -method GET {
                            input -name "text" -type text -value ""
                            input -name "method" -value Search_Classes -type submit
                        }
                        form -action "" -method GET {
                            input -name "text" -type text -value ""
                            input -name "method" -value Search_Methods -type submit
                        }
                        form -action "" -method GET {
                            input -name "text" -type text -value ""
                            input -name "method" -value Search_Tags -type submit
                        }
                        form -action "" -method GET {
                            input -name "text" -type text -value ""
                            input -name "method" -value Search_Code -type submit
                        }
                        form -action "" -method GET {
                            input -name "text" -type text -value ""
                            input -name "method" -value Search_Variables -type submit
                        }
                    }
                }
        } ]
    }

    CodeSearch instproc Search_Classes { -text } { } {
        
        my instvar root

        set classes ""

        foreach class [ ::xox::ObjectGraph findAllInstances ::xotcl::Class ] {

            if [ string match *${text}* $class ] {

                lappend classes $class
            }
        }

        return [ ::xoweb::makePage { } {
                html {
                    new XowebCSS -width 80%
                    div -class object {
                        h1 ' CodeSearch - Search Classes
                        h3 ' Results
                        ul foreach class $classes {
                            li a -href [ cleanUpLink "$root/classinspector?object=${class}" ] ' $class
                        }
                    }
                }
        } ]
    }

    CodeSearch instproc Search_Methods { -text } { } {

        my instvar root

        set methods ""

        foreach class [ ::xox::ObjectGraph findAllInstances ::xotcl::Class ] {

            foreach method [ $class info instprocs ] {

                if [ string match *${text}* $method ] {

                    lappend methods $class $method 
                }
            }
        }

        return [ ::xoweb::makePage { } {
                html {
                    new XowebCSS -width 80%
                    div -class object {
                        h1 ' CodeSearch - Search Methods
                        h3 ' Results
                        ul foreach { class method } $methods {
                            li a -href "[ cleanUpLink $root/classinspector?object=${class}]#${method}" ' $class $method
                        }
                    }
                }
        } ]
    }

    CodeSearch instproc Search_Tags { -text } { } {

        my instvar root

        set methods ""

        foreach class [ ::xox::ObjectGraph findAllInstances ::xotcl::Class ] {

            foreach method [ $class info instprocs ] {

                if [ $class hasTag $method $text ] {

                    lappend methods $class $method 
                }
            }
        }

        return [ ::xoweb::makePage { } {
                html {
                    new XowebCSS -width 80%
                    div -class object {
                        h1 ' CodeSearch - Search Methods
                        h3 ' Results
                        ul foreach { class method } $methods {
                            li a -href "[ cleanUpLink $root/classinspector?object=${class}]#${method}" ' $class $method
                        }
                    }
                }
        } ]
    }

    CodeSearch instproc Search_Code { -text } { } {

        my instvar root

        set methods ""

        foreach class [ ::xox::ObjectGraph findAllInstances ::xotcl::Class ] {

            foreach method [ $class info instprocs ] {

                if [ string match *${text}* [ $class info instbody $method ] ] {

                    lappend methods $class $method 
                }
            }
        }

        return [ ::xoweb::makePage { } {
                html {
                    new XowebCSS -width 80%
                    div -class object {
                        h1 ' CodeSearch - Search Methods
                        h3 ' Results
                        ul foreach { class method } $methods {
                            li a -href "[ cleanUpLink $root/classinspector?object=${class}]#${method}" ' $class $method
                        }
                    }
                }
        } ]
    }

    CodeSearch instproc Search_Variables { -text } { } {

        my instvar root

        set variables ""

        foreach object [ ::xox::ObjectGraph findAllInstances ::xotcl::Object ] {

            if [ $object hasclass ::xotcl::Attribute ] { continue }

            foreach variable [ $object info vars ] {

                if [ string match *${text}* $variable ] {

                    lappend variables $object $variable 
                }
            }
        }

        return [ ::xoweb::makePage { } {
            html {
                new XowebCSS -width 80%
                div -class object {
                    h1 ' CodeSearch - Search Methods
                    h3 ' Results
                    ul foreach { object variable } $variables {
                        li { 
                            a -href "[ cleanUpLink $root/objectinspector?object=${object}]#${variable}" ' $object $variable
                            ' " = "
                            catch { ' "{[ $object set $variable ]}" }
                        }
                    }
                }
            }
        } ]
    }
}


