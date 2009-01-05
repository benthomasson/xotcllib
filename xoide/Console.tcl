# Created at Fri Sep 26 01:31:10 EDT 2008 by bthomass

namespace eval ::xoide {

    Class Console -superclass ::xoide::ScrolledText

    Console @doc Console {

        Please describe the class Console here.
    }

    Console parameter {
        console

    }

    Console instproc init { } {

        my instvar scrolledText name console

        frame $name
        set scrolledText [ ScrolledText new $name.console -width 80 -height 10 -name Console ]

        pack $name.console -fill both -expand true -side left

        set console [ $scrolledText text ]
        set popupMenu [ ::xoide::ConsolePopup new -name $name.popupMenu -console $console ]
        $console tag configure output -foreground blue
        bind $console <ButtonPress-2> "tk_popup [ $popupMenu popupMenu ] %X %Y"
    }
}


