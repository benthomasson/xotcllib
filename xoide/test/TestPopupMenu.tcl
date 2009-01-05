# Created at Fri Sep 26 16:06:12 EDT 2008 by bthomass

namespace eval ::xoide::test {

    Class TestPopupMenu -superclass ::xoide::TkTestCase

    TestPopupMenu parameter {

    }

    TestPopupMenu instproc test { } {

        my instvar root

        toplevel $root
        wm minsize $root 30 5
        wm title $root "[ my info class ] [ self proc ]"

        set popupMenu [ ::xoide::PopupMenu new -name ${root}.popupMenu ]
        $popupMenu widgetCommand add command -label "Click me!" -command "[ self ] set click 1"
        tk_popup [ $popupMenu popupMenu ] 100 100

        my interact 1000

        my assertTrue [ my exists click ] "You didn't click me :("
    }
}


