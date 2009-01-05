# Created at Sat Aug 09 14:11:56 EDT 2008 by bthomass

namespace eval ::xounit::test {

    Class TestTestResultsWriter -superclass ::xounit::TestCase

    TestTestResultsWriter parameter {

    }

    TestTestResultsWriter instproc setUp { } {

        #add set up code here
    }

    TestTestResultsWriter instproc testWriteTextResults { } {

        set writer [ ::xounit::TestResultsWriter new ]
        puts [ $writer writeTextResults [ [ eval ::xounit::RunTests new xodsl ] results ] ]
    }

    TestTestResultsWriter instproc testNoColor { } {

        set writer [ ::xounit::TestResultsWriter new -nocolor ]
        puts [ $writer writeTextResults [ [ eval ::xounit::RunTests new xodsl ] results ] ]
    }

    TestTestResultsWriter instproc testWriteEmailResults { } {

        set writer [ ::xounit::TestResultsWriter new ]
        puts [ $writer writeEmailResults [ [ eval ::xounit::RunTests new xodsl ] results ] ]
    }

    TestTestResultsWriter instproc testWriteWebResults { } {

        set writer [ ::xounit::TestResultsWriter new ]
        set html [ $writer writeWebResults [ [ eval ::xounit::RunTests new xodsl ] results ] ]
        puts $html
        ::xox::writeFile /tmp/testWriteWebResults.html $html
    }

    TestTestResultsWriter instproc tearDown { } {

        #add tear down code here
    }
}


