# Created at Fri Sep 26 16:13:35 EDT 2008 by bthomass

namespace eval ::xoide {

    Class EditPopup -superclass ::xoide::PopupMenu

    EditPopup @doc EditPopup {

        Please describe the class EditPopup here.
    }

    EditPopup parameter {
        script
    }

    EditPopup instproc init { } {

        my instvar popupMenu

        next

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

    EditPopup instproc insertScript { script } {

    }
}


