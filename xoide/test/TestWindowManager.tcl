# Created at Thu Sep 25 22:31:16 EDT 2008 by bthomass

namespace eval ::xoide::test {

    Class TestWindowManager -superclass ::xoide::TkTestCase

    TestWindowManager parameter {

    }

    TestWindowManager instproc testLoadTk { } {

        package require XOTcl 1.5.5
        package require Tk 8.4
    }

    TestWindowManager instproc testTopLevel { } {

        my instvar root

        toplevel $root

        #my interact 1000
    }

    TestWindowManager instproc testWm { } {

        my instvar root

        toplevel $root
        wm title $root [ self proc ]
        wm minsize $root 30 5
        wm deiconify $root

        #my interact 3000
    }

    TestWindowManager instproc tearDown { } {

        #add tear down code here
    }
}


