# Created at Thu Jun 07 13:16:38 EDT 2007 by bthomass

package require xounit

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    Class TestGarbageCollector -superclass ::xounit::TestCase

    TestGarbageCollector parameter {

    }

    TestGarbageCollector instproc setUp { } {

        #add set up code here
    }

    TestGarbageCollector instproc test { } {

        #implement test here
    }

    TestGarbageCollector instproc tearDown { } {

        #add tear down code here
    }
}

package provide xox::test::TestGarbageCollector 1.0

