package provide xox::test::TestReload 1.0

package require XOTcl
package require xox

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    ::xotcl::Class TestReload -superclass ::xounit::TestCase

    TestReload instproc testRecreateClass {} {

        Class ::A
        set a [ ::A new ]
        Class ::A

        my assertEquals [ $a info class ] ::A
    }

    TestReload instproc testReloadObject {} {

        Class ::B
        set b [ ::B new ]

        set o [ Object new ]

        ::xox loadClass ::xox::Object

        my assertEquals [ $o info class ] ::xotcl::Object
        my assertEquals [ $b info class ] ::B

        my testRecreateClass
    }

    TestReload instproc testReloadClass {} {

        Class ::C
        set c [ ::C new ]
        set o [ Object new ]


        ::xox loadClass ::xox::Class

        my assertEquals [ $o info class ] ::xotcl::Object
        my assertEquals [ $c info class ] ::C

        my testRecreateClass
    }

    TestReload instproc testReloadReload {} {

        Class ::D
        set d [ ::D new ]
        set o [ Object new ]

        ::xox loadClass ::xox::Reload

        my assertEquals [ $o info class ] ::xotcl::Object
        my assertEquals [ $d info class ] ::D

        my testRecreateClass
    }

    TestReload instproc testReloadTestReload {} {

        Class ::E
        set e [ ::E new ]
        set o [ Object new ]

        ::xox loadClass ::xox::test::TestReload

        my assertEquals [ $o info class ] ::xotcl::Object
        my assertEquals [ $e info class ] ::E

        my testRecreateClass
    }

}
