# Created at Thu Sep 25 20:17:22 EDT 2008 by bthomass

namespace eval ::xoide {

    Class ScrolledText

    ScrolledText parameter {
        { name "" }
        frame
        text
        width 
        height
        errors
    }

    ScrolledText instproc init { frame } {

        my instvar width height name

        frame $frame  
        my frame $frame 
        eval {text $frame.text -wrap none \
            -xscrollcommand [ list $frame.xscroll set ] \
            -yscrollcommand [ list $frame.yscroll set ]} \
            -width $width -height $height \
            -background white
        my text $frame.text
        scrollbar $frame.xscroll -orient horizontal \
            -command [ list $frame.text xview ]
        scrollbar $frame.yscroll -orient vertical \
            -command [ list $frame.text yview ]
        if { "" != "$name" } {
            label $frame.label -text $name
            grid $frame.label -sticky nw
        }
        grid $frame.text $frame.yscroll -sticky news
        grid $frame.xscroll -sticky news
        if { "" != "$name" } {
            grid rowconfigure $frame 0 -weight 0
            grid rowconfigure $frame 1 -weight 1
        } else {
            grid rowconfigure $frame 0 -weight 1
        }
        grid columnconfigure $frame 0 -weight 1
    }
}


