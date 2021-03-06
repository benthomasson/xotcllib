# Created at Fri Sep 26 01:31:28 EDT 2008 by bthomass

namespace eval ::xoide::test {

    Class TestScript -superclass ::xoide::TkTestCase

    TestScript parameter {

    }

    TestScript instproc test { } {

        my instvar root

        toplevel $root
        wm minsize $root 30 5
        wm title $root "[ my info class ] [ self proc ]"

        set pane [ panedwindow ${root}.p -orient vertical -showhandle 1 ]
        pack $pane -expand yes -fill both

        set script [ ::xoide::Script new -name $pane.frame ]
        pack $pane.frame 

        my interact 10000
    }
}


