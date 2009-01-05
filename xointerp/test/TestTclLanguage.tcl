# Created at Tue Sep 16 21:30:40 EDT 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestTclLanguage -superclass ::xounit::TestCase

    TestTclLanguage parameter {

    }

    TestTclLanguage instproc setUp { } {

        #add set up code here
    }

    TestTclLanguage instproc testCommandToList { } {

        my assertEquals [ ::xointerp::TclLanguage commandToList {} ] {}
        my assertEquals [ ::xointerp::TclLanguage commandToList { } ] {}
        my assertEquals [ ::xointerp::TclLanguage commandToList {
} ] {}
        my assertEquals [ ::xointerp::TclLanguage commandToList "\t" ] {}
        my assertEquals [ ::xointerp::TclLanguage commandToList {set a 5} ] {set a 5}
        my assertEquals [ ::xointerp::TclLanguage commandToList {set a 5 } ] {set a 5}
        my assertEquals [ ::xointerp::TclLanguage commandToList {set a(2) 5 } ] {set a(2) 5}
        my assertEquals [ ::xointerp::TclLanguage commandToList {set a(2) 5} ] {set a(2) 5}
        my assertEquals [ ::xointerp::TclLanguage commandToList {set a(2) [ set b 5 ]} ] {set a(2) {[ set b 5 ]}}
        my assertEquals [ ::xointerp::TclLanguage commandToList {set a(2) x[ set b 5 ]} ] {set a(2) {x[ set b 5 ]}}

    }

    TestTclLanguage instproc testCommandToList2 { } {

        my assertEquals [ ::xointerp::TclLanguage commandToList {set a {5}} ] {set a 5}
        my assertEquals [ ::xointerp::TclLanguage commandToList {set a {5} } ] {set a 5}
    }

    TestTclLanguage instproc tearDown { } {

        #add tear down code here
    }
}


