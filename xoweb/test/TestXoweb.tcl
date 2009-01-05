# Created at Tue Oct 28 22:14:52 EDT 2008 by ben

namespace eval ::xoweb::test {

    Class TestXoweb -superclass ::xounit::TestCase

    TestXoweb parameter {

    }

    TestXoweb instproc setUp { } {

        #add set up code here
    }

    TestXoweb instproc testEmpty { } {

        my assertEquals [ ::xoweb::makePage { } { } ] {}
    }

    TestXoweb instproc testHtml { } {

        my assertEquals [ ::xoweb::makePage { } { html } ] {<html></html>}
    }

    TestXoweb instproc tearDown { } {

        #add tear down code here
    }
}


