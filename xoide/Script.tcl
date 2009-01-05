# Created at Fri Sep 26 01:31:28 EDT 2008 by bthomass

namespace eval ::xoide {

    Class Script -superclass ::xoide::TkObject

    Script @doc Script {

        Please describe the class Script here.
    }

    Script parameter {
        script
    }

    Script instproc init {  } {

        my instvar script name scrolledText
        frame $name
        set scrolledText [ ScrolledText new $name.history -width 40 -height 50 -name Script ]
        set script [ $scrolledText text ]

        pack $name.history -fill both -expand true -side left
        set popupMenu [ ::xoide::EditPopup new -name $name.popupMenu -script $script ]

        bind $script <ButtonPress-2> "tk_popup [ $popupMenu popupMenu ] %X %Y"
        bind $script <Control-Return> "[ self ] executeScript; break"
    }

    Script instproc editPopup { } {

        my instvar popupMenu

        my makePopup

        set insertMenu [ my addPopupMenu Insert ]
        $insertMenu add command -label "#" -command "[ self ] insertScript {#\n#\n#}"
        $insertMenu add command -label "if" -command "[ self ] insertScript {if { } {\n    \n}}"
        $insertMenu add command -label "for" -command "[ self ] insertScript {for {set loop 0} {\$loop < \$limit} {incr loop} {\n    \n}}"
        $insertMenu add command -label "foreach" -command "[ self ] insertScript {foreach item \$list {\n    \n}}"
        $insertMenu add command -label "catch" -command "[ self ] insertScript {if \[ catch {\n    \n} result \] {\n    \n}}"
        $insertMenu add command -label "while" -command "[ self ] insertScript {while { ! \$done } {\n    \n}}"
        $insertMenu add command -label "switch" -command "[ self ] insertScript {switch \$switch {\n    case1 { }\n    case2 { }\n    default {}\n}}"
        $insertMenu add command -label "list" -command "[ self ] insertScript {set list \[ list a b c \]}"
        $insertMenu add command -label "proc" -command "[ self ] insertScript {#\n#\n#\nproc someProc { someArg } {\n\n\n}\n }"
    }
}


