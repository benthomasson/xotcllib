# Created at Sun May 11 13:45:15 EDT 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestLibrary -superclass ::xounit::TestCase

    TestLibrary parameter {

    }

    TestLibrary instproc test { } {

            set library [ ::xointerp::Library new ]

            $library getCommands

    }
}


