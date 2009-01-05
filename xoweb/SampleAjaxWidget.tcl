# Created at Thu Nov 06 20:26:40 EST 2008 by ben

namespace eval ::xoweb {

    Class SampleAjaxWidget -superclass ::xoweb::AjaxWidget

    SampleAjaxWidget @doc SampleAjaxWidget {

        Please describe the class SampleAjaxWidget here.
    }

    SampleAjaxWidget parameter {

    }

    SampleAjaxWidget instproc done { } {

        return [ ::xoweb::makePage { } {
            ' Done
        } ]
    }
}


