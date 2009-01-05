# Created at Sat Nov 08 21:21:58 EST 2008 by ben

namespace eval ::xoweb {

    Class EditableWidget -superclass ::xoweb::AjaxWidget

    EditableWidget @doc EditableWidget {

        Please describe the class EditableWidget here.
    }

    EditableWidget parameter {
        { editable 0 }
        { editMode 0 }
    }

    EditableWidget instproc editButton { } {

        my instvar url id editable

        if { !$editable } { return } 

        return [ ::xoweb::makePage { } {

            form -action "javascript:o=new Object();ajaxWidgetCall('$id','$url','$id','editWidget',o);" {
                input -type submit -value Edit
            }

        } ]
    }

    EditableWidget instproc editWidget { } {

        my instvar url id self editable editMode

        if { ! $editable && ! $editMode } { return  [ my initialLoad ] }

        return [ ::xoweb::makePage { } {

            div -id $id -class edit {

                b ' Editing $self
                foreach var [ $self info vars ] {
                    if [ $self array exists $var ] { continue }
                    form -action "javascript:o=new Object();o.var='$var';o.value=\$('${id}_$var').getValue();ajaxWidgetAction('$id','$url','setValue',o);" {
                        ' "$var : "
                        input -id ${id}_$var -type text -value [ $self set $var ]
                    }
                }
                form -action "javascript:o=new Object();ajaxWidgetCall('$id','$url','$id','initialLoad',o);" {
                    input -type submit -value Done
                }
            }
        } ]
    }


    EditableWidget instproc setValue { -var -value } { } {

        puts "Setting $var to $value on [ self ]"
        my set $var $value
        return
    }
}


