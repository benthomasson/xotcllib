# Created at Tue Jun 26 19:41:40 EDT 2007 by bthomass

package require xounit

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    Class TestTuple -superclass ::xounit::TestCase

}

package provide xox::test::TestTuple 1.0

