# Created at Thu Nov 06 19:26:46 EST 2008 by ben

namespace eval ::xoweb {

    ::xodsl::LanguageClass create AjaxWidget -superclass ::xohtml::HtmlWidget

    AjaxWidget @doc AjaxWidget {

        Please describe the class AjaxWidget here.
    }

    AjaxWidget parameter {
        url
        id
        { cssClass "" }
    }

    AjaxWidget instproc processRequest { argumentList } {
        
        set method initialLoad
        set arguments ""

        foreach { arg value } $argumentList {

            if { "-widgetMethod" == "$arg" } {

                set method $value
            } else {
                lappend arguments ${arg} $value
            }
        }

        puts "$method $arguments"
        
        catch { 
            set return [ eval [ self ] $method $arguments  ]
        }  return 

        return $return
    }

    AjaxWidget instproc initialLoad { } {

        my instvar id cssClass

        return [ ::xoweb::makePage { } {
            div -id $id -class $cssClass {
                ' Loading...
            }
        } ]
    }

    AjaxWidget instproc formatWidget { } {

        return [ my initialLoad ]
    }

    AjaxWidget instproc formatWidgetWithCollector { collector } {

        my instvar environment htmlWidgetCode

        $collector append string [ my initialLoad ]
        return
    }
}


