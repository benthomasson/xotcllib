# Created at Fri Jun 01 07:39:09 EDT 2007 by bthomass

namespace eval ::xounit::test {

    namespace import -force ::xotcl::*

    Class TestTestSuiteContinuous -superclass ::xounit::TestCase

    TestTestSuiteContinuous parameter {

    }

    TestTestSuiteContinuous instproc getChannels { } {

        set openChannels [ file channels ]

        set openChannels [ ::xox::removeIf {

            string match sock* $channel

        } channel $openChannels ]

        return $openChannels
    }

    TestTestSuiteContinuous instproc testCloseFileChannels { } {

        set suite [ ::xounit::TestSuiteContinuous new ]

        $suite closeFileChannels

        my assertEquals [ my getChannels ] "stdin stdout stderr"

        open "/tmp/xounit[ clock seconds ]" w

        my assertNotEquals [ my getChannels ] "stdin stdout stderr"

        $suite closeFileChannels

        my assertEquals [ my getChannels ] "stdin stdout stderr"
    }
}


