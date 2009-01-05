# Created at Tue Jun 05 17:06:43 EDT 2007 by bthomass

package require xounit

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    Class TestAutoLoadSuperClass -superclass ::xounit::TestCase

    TestAutoLoadSuperClass parameter {

    }

    TestAutoLoadSuperClass instproc setUp { } {

        #add set up code here
    }

    TestAutoLoadSuperClass instproc test { } {

        #implement test here
    }

    TestAutoLoadSuperClass instproc tearDown { } {

        #add tear down code here
    }
}

package provide xox::test::TestAutoLoadSuperClass 1.0

