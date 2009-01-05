# Created at Thu Jun 07 13:56:32 EDT 2007 by bthomass

package require xounit

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    Class TestNotGarbageCollectable -superclass ::xounit::TestCase

    TestNotGarbageCollectable parameter {

    }

    TestNotGarbageCollectable instproc setUp { } {

        #add set up code here
    }

    TestNotGarbageCollectable instproc test { } {

        #implement test here
    }

    TestNotGarbageCollectable instproc tearDown { } {

        #add tear down code here
    }
}

package provide xox::test::TestNotGarbageCollectable 1.0

