# Created at Mon Feb 04 10:22:54 AM EST 2008 by bthomass

namespace eval ::simpletest::test {

    Class TestSimpleTestCase -superclass ::xounit::TestCase

    TestSimpleTestCase parameter {

    }

    TestSimpleTestCase instproc setUp { } {

        #add set up code here
    }

    TestSimpleTestCase instproc test { } {

        #implement test here
    }

    TestSimpleTestCase instproc tearDown { } {

        #add tear down code here
    }
}


