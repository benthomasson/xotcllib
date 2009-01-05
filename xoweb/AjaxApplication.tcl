# Created at Thu Nov 06 19:29:55 EST 2008 by ben

namespace eval ::xoweb {

    Class AjaxApplication -superclass ::xoweb::Application

    AjaxApplication @doc AjaxApplication {

        Please describe the class AjaxApplication here.
    }

    AjaxApplication parameter {
    }

    AjaxApplication instproc registerWidget { widget } {

        my instvar url

        set id [ my autoname widget ]
        $widget id $id
        $widget url $url
        $widget set self $widget
        my set widgets($id) $widget

        return $widget
    }

    AjaxApplication instproc processWidget { -id } { args } {

        if { ! [ my exists widgets($id) ] } {
            error "Cannot find widget: $id"
        }

        return [ [ my set widgets($id) ] processRequest $args ]
    }
}


