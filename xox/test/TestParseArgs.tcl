package provide xox::test::TestParseArgs 1.0

package require XOTcl
package require xox

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    ::xotcl::Class TestParseArgs -superclass ::xounit::TestCase

    TestParseArgs instproc testSetVar { } {

        set pa [ ::xox::ParseArgs new -other 5 ]
        my assertEquals [ $pa set other ] 5 
    }

    TestParseArgs instproc testFlag { } {

        set pa [ ::xox::ParseArgs new -other ]
        my assertEquals [ $pa set other ] 1 
    }

    TestParseArgs instproc testParse { } {

        set pa [ ::xox::ParseArgs parse "-other 5" ]
        my assertEquals [ $pa set other ] 5 
        set pa [ ::xox::ParseArgs parse "-other" ]
        my assertEquals [ $pa set other ] 1 
    }

    TestParseArgs instproc testConfigureObject { } {

        set pa [ ::xox::ParseArgs parse "-other 5" ]
        $pa configureObject [ self ] 
        my assertEquals [ my set other ] 5 
        set pa [ ::xox::ParseArgs parse "-other" ]
        $pa configureObject [ self ] 
        my assertEquals [ my set other ] 1 
        set pa [ ::xox::ParseArgs parse "-another(1) 2" ]
        $pa configureObject [ self ] 
        my assertEquals [ my set another(1) ] 2 
        set pa [ ::xox::ParseArgs parse "-another(2)" ]
        $pa configureObject [ self ] 
        my assertEquals [ my set another(2) ] 1 
    }

    TestParseArgs instproc testExtractToObject { } {

        set pa [ ::xox::ParseArgs parse "-other 5" ]
        $pa extractToObject [ self ] other 
        my assertEquals [ my set other ] 5 
        set pa [ ::xox::ParseArgs parse "-other" ]
        $pa extractToObject [ self ] other
        my assertEquals [ my set other ] 1 
    }

    TestParseArgs instproc testProcConfigureObject { } {

        ::xox::ParseArgs configureObject [ self ]  "-other 5"
        my assertEquals [ my set other ] 5 
        ::xox::ParseArgs configureObject [ self ]  "-other"
        my assertEquals [ my set other ] 1 
    }

    TestParseArgs instproc testGetArgsObject { } {

        set o [ ::xox::ParseArgs getArgsObject {}  "-other 5" ]
        my assertEquals [ $o other ] 5 
        my assertEquals [ $o x ] "" 
        set o [ ::xox::ParseArgs getArgsObject {other} "-other" ]
        my assertEquals [ $o other ] 1 
        set o [ ::xox::ParseArgs getArgsObject {other} "" ]
        my assertEquals [ $o other ] 0 
        set o [ ::xox::ParseArgs getArgsObject {other another} "-other" ]
        my assertEquals [ $o other ] 1
        my assertEquals [ $o another ] 0
        set o [ ::xox::ParseArgs getArgsObject {other another} "-other -another" ]
        my assertEquals [ $o other ] 1
        my assertEquals [ $o another ] 1
    }

    TestParseArgs instproc testConfigureScope { } {

        ::xox::ParseArgs configureScope "-other 5"

        my assertEquals $other 5

    }
}
