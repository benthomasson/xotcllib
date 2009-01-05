# Created at Fri Jun 15 07:47:43 EDT 2007 by bthomass

package require xounit

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    Class TestSimpleXmlNodeWriter -superclass ::xounit::TestCase

    TestSimpleXmlNodeWriter parameter {

    }

    TestSimpleXmlNodeWriter instproc test { } {

        set writer [ ::xox::SimpleXmlNodeWriter new ]
        set node [ ::xox::Node new ]

        $node set var value
        $node set other [ Object create ::foo ]
        $node set another [ ::xox::Node create ::bar ]
        $node set empty ""

        $node createChild snafu ::xox::Node

        set xml [ $writer generateXml $node ]

        my debug $xml

        return
    }
}

package provide xox::test::TestSimpleXmlNodeWriter 1.0

