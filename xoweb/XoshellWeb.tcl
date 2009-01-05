# Created at Sat Nov 15 15:41:58 EST 2008 by ben

namespace eval ::xoweb {

    ::xoweb::MultiuserApplicationClass create XoshellWeb -superclass ::xoweb::Application

    XoshellWeb @doc XoshellWeb {

        Please describe the class XoshellWeb here.
    }

    XoshellWeb parameter {
        shellLanguage
        shellEnvironment
    }

    XoshellWeb instproc init { } {

        my instvar shellLanguage shellEnvironment 

        set shellLanguage [ ::xodsl::Language newLanguage ]
        set shellEnvironment [ $shellLanguage set environment ]
    }

    XoshellWeb instproc initialLoad { } {

        my instvar url

        return [ ::xoweb::makePage { } {
            html {
                head {
                    script -language "Javascript" -src "/files/prototype.js"
                    script -language "Javascript" -src "/files/xopro.js"
                }
                new XowebCSS -width 80%
                body {
                    div -class object {

                        h1 -class name ' Xoshell

                        form {
                            textarea -rows 20 -cols 80
                            br
                            ' xoshell>
                            input -type text -size 80 -id command -name command
                        }
                        javascript {
                            $('command').focus();
                        }
                    }
                }
            }
        } ]
    }
}


