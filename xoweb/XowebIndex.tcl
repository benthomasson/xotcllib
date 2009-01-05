# Created at Sun Oct 26 15:07:29 EDT 2008 by ben

namespace eval ::xoweb {

    ::xoweb::ApplicationClass create XowebIndex -superclass ::xoweb::Application

    XowebIndex @doc XowebIndex {

        Please describe the class XowebIndex here.
    }

    XowebIndex parameter {

    }

    XowebIndex instproc initialLoad { } {

        return [ ::xoweb::makePage { } { 
            html {
                new XowebCSS 
                div -class object {
                    h1 ' Xoweb Application Index

                    ul foreach application [ ::xox::ObjectGraph findAllInstances ::xoweb::ApplicationClass ] {
                        if [ $application installed ] {
                            li a -href [ $application url ] ' [ namespace tail $application ]
                        }
                    }
                }
            }
        } ]
    }
}


