# Created at Tue Nov 18 20:02:22 EST 2008 by ben

namespace eval ::xoweb {

    Class XowebLanguage -superclass ::xotcl::Object

    XowebLanguage mixin add ::xodsl::MacroClass

    XowebLanguage @doc XowebLanguage {

        Please describe the class XowebLanguage here.
    }

    XowebLanguage parameter {

    }

    XowebLanguage instmacro basicPage { { -title "" } } { script } {

        html {
            head title ' %title
            body {
                    %script
            }
        }
    }

    XowebLanguage instmacro ajaxPage { { -title "" } } { script } {

        html {  
            head {  
                script -language "Javascript" -src "/files/prototype.js"
                script -language "Javascript" -src "/files/xopro.js"
                script -language "Javascript" -src "/files/sorter.js"
                meta -http-equiv Content-Type -content type/html -charset utf-8
                title ' %title
            }    
            body {
                    %script
            }
        }
    }
}


