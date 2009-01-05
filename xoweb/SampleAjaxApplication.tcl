# Created at Thu Nov 06 19:34:46 EST 2008 by ben

namespace eval ::xoweb {

    ::xoweb::ApplicationClass create SampleAjaxApplication -superclass ::xoweb::AjaxApplication

    SampleAjaxApplication @doc SampleAjaxApplication {

        Please describe the class SampleAjaxApplication here.
    }

    SampleAjaxApplication parameter {

    }

    SampleAjaxApplication instproc init { } {

        my instvar aWidget bWidget

        set aWidget [ my registerWidget [ ::xoweb::SampleAjaxWidget new ] ]
        set bWidget [ my registerWidget [ ::xoweb::SampleEditableWidget new -editable 1] ]
        puts $bWidget
    }

    SampleAjaxApplication instproc initialLoad { } {

        my instvar aWidget url bWidget 

        set divId [ $aWidget id ]
        puts $divId

        set self [ self ]

        return [ ::xoweb::makePage { } {

            add ::xoweb::XowebLanguage

            ajaxPage {

                h1 ' $self
                ul foreach id [ $self array names widgets ] {
                    li ' $id [ $self set widgets($id) ]
                }
                useExternal $aWidget
                form -action "javascript:o=new Object();o.id='$divId';o.widgetMethod='done';ajaxLoad('$divId','$url','processWidget',o);" {
                    input -type submit -value Run
                }
                useExternal $bWidget
            }
        } ]
    }
}


