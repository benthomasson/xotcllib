# Created at Sat Jan 05 00:10:09 EST 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestCase -superclass ::xounit::TestCase

    TestCase # TestCase {

        Please describe the class TestCase here.
    }

    TestCase instmixin ::xointerp::Interpretable

    TestCase parameter {

    }

}


