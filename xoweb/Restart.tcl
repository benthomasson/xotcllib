# Created at Thu Oct 23 11:46:03 EDT 2008 by ben

namespace eval ::xoweb {

    ::xoweb::ApplicationClass create Restart -superclass ::xoweb::Application

    Restart @doc Restart {

        Please describe the class Restart here.
    }

    Restart parameter {

    }

    Restart instproc initialLoad { args } {

        my instvar url

        return [ ::xoweb::makePage { } {
            html {
                new XowebCSS 
                body {
                    div -class object {
                        h1 -class name ' Restart
                        form -action $url -method POST {
                            input -type submit -value "Restart Server"
                            input -type hidden -name method -value restart
                        }
                    }
                }
            }
        } ]
    }

    Restart instproc restart { } {

        my instvar url

        after 1000 ::exit

        return [ ::xoweb::makePage { } {
            html {
                new XowebCSS
                body {
                    div -class object {
                        h1 -class name ' Restarting...
                        a -href "$url" ' Back
                    }
                }
            }
        } ]
    }

    Restart instproc restarted { } {

        my instvar url

        return [ ::xoweb::makePage { } {
            html {
                new XowebCSS
                body {
                    h1 -class name ' Restarted
                }
            }
        } ]
    }
}


