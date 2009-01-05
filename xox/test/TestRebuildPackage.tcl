# Created at Thu Jul 12 13:58:16 EDT 2007 by bthomass

package require xounit

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    Class TestRebuildPackage -superclass ::xounit::TestCase

    TestRebuildPackage parameter {

    }

    TestRebuildPackage instproc setUp { } {

        #add set up code here
    }

    TestRebuildPackage instproc test { } {

        #implement test here
    }

    TestRebuildPackage instproc tearDown { } {

        #add tear down code here
    }
}

package provide xox::test::TestRebuildPackage 1.0

