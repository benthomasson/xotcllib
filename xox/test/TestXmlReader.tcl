# Created at Tue Jul 10 14:50:06 EDT 2007 by bthomass

package require xounit

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    Class TestXmlReader -superclass ::xounit::TestCase

    TestXmlReader parameter {

    }
}

package provide xox::test::TestXmlReader 1.0

