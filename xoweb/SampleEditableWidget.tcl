# Created at Sat Nov 08 21:42:20 EST 2008 by ben

namespace eval ::xoweb {

    Class SampleEditableWidget -superclass ::xoweb::EditableWidget

    SampleEditableWidget @doc SampleEditableWidget {

        Please describe the class SampleEditableWidget here.
    }

    SampleEditableWidget parameter {
        { name Guest }
        { cssClass "" }
    }

    SampleEditableWidget instproc initialLoad { } {

        my instvar id cssClass name self editMode

        if $editMode { return [ my editWidget ] }

        return [ ::xoweb::makePage { } {

            div -id $id -class $cssClass {
                ' Hi $name im $id
                , $self editButton
            }
        } ]
    }
}


