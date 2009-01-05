# Created at Fri Sep 26 16:14:07 EDT 2008 by bthomass

namespace eval ::xoide {

    Class ClassPopup -superclass ::xoide::PopupMenu

    ClassPopup @doc ClassPopup {

        Please describe the class ClassPopup here.
    }

    ClassPopup parameter {
        aClass
    }

    ClassPopup instproc init { } {

        my instvar popupMenu aClass

        if {![ Object isclass $aClass ]} { return }

        next

        $popupMenu add command -label Inspect -command "puts $aClass"
    }
}


