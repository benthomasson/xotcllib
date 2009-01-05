# Created at Thu Jun 21 14:07:00 EDT 2007 by bthomass

package require xounit

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    Class TestEval -superclass ::xounit::TestCase

    TestEval parameter {

    }

    TestEval instproc setUp { } {

        catch { unset ::xox::test::evalXYZ }
    }

    TestEval instproc test { } {

        set eval [ ::xox::Eval new \
                    -script "set ::xox::test::evalXYZ 5" ]

        my assertFalse [ info exists ::xox::test::evalXYZ ]

        $eval configureNode

        my assert [ info exists ::xox::test::evalXYZ ]

        my assertEquals $::xox::test::evalXYZ 5

        my assertFalse [ info exists ::xox::evalObject ]
    }

    TestEval instproc testEvalObject { } {

        set eval [ ::xox::Eval new ]
        
        $eval script "

            set ::xox::test::evalXYZ 6

            [ self ] assertObject \$::xox::evalObject
            [ self ] assertEquals $eval \$::xox::evalObject
        " 

        my assertFalse [ info exists ::xox::test::evalXYZ ]

        $eval configureNode

        my assert [ info exists ::xox::test::evalXYZ ]
        my assertEquals $::xox::test::evalXYZ 6

        my assertFalse [ info exists ::xox::evalObject ]
    }

    TestEval instproc testXml { } {

        set reader [ ::xox::XmlNodeReader new ]

        set eval [ ::xox::Eval new ]

        set xml \
"<eval>
    <script>
    set ::xox::test::evalXYZ 7
    [ self ] assertObject \$::xox::evalObject
    \$::xox::evalObject set abc 6
    </script>
</eval>
"

        $reader buildNodes $eval $xml

        my assert [ info exists ::xox::test::evalXYZ ]
        my assertEquals $::xox::test::evalXYZ 7

        my assert [ $eval exists abc ]
        my assertEquals [ $eval set abc ] 6

        my assertFalse [ info exists ::xox::evalObject ]
    }
}

package provide xox::test::TestEval 1.0

