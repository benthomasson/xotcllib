# Created at Mon Apr 21 02:18:44 PM EDT 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestBuildable -superclass ::xounit::TestCase

    TestBuildable parameter {

    }

    TestBuildable instproc setUp { } {

        #add set up code here
    }

    TestBuildable instproc test { } {

        Class create X

        X instMultilineSetter xyz

        set x [ X new ]

        $x xyz 5

        my assertEquals [ $x xyz ] 5 
    }

    TestBuildable instproc tearDown { } {

        #add tear down code here
    }
}


