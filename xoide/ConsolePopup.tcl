# Created at Fri Sep 26 16:13:29 EDT 2008 by bthomass

namespace eval ::xoide {

    Class ConsolePopup -superclass ::xoide::PopupMenu

    ConsolePopup @doc ConsolePopup {

        Please describe the class ConsolePopup here.
    }

    ConsolePopup parameter {
        console
    }

    ConsolePopup instproc init { } {

        my instvar popupMenu

        next 

        $popupMenu add command -label "Clear" -command "[ self ] clearConsole"
    }

    ConsolePopup instproc clearConsole { } {

        my instvar console 

        $console delete 1.0 end
    }
}


