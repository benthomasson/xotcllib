# Created at Tue Jul 10 15:58:15 EDT 2007 by bthomass

package require xounit

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    Class TestXmlNodeSchemaWriter -superclass ::xounit::TestCase

    TestXmlNodeSchemaWriter parameter {

    }

    TestXmlNodeSchemaWriter instproc setUp { } {

        #add set up code here
    }

    TestXmlNodeSchemaWriter instproc test { } {

        #implement test here
    }

    TestXmlNodeSchemaWriter instproc tearDown { } {

        #add tear down code here
    }
}

package provide xox::test::TestXmlNodeSchemaWriter 1.0

