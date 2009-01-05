# Created at Tue May 29 18:14:08 EDT 2007 by bthomass

package require xounit

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    Class TestHigherOrderTcl -superclass ::xounit::TestCase

    TestHigherOrderTcl parameter {

    }

    TestHigherOrderTcl instproc testMapcar { } {

        my assertEquals \
            [ ::xox::mapcar { expr {1 + $item} } item {1 2 3 4 5} ] \
            {2 3 4 5 6}
        
        set list {1 2 3 4 5}

        my assertEquals \
            [ ::xox::mapcar { expr {2 + $item} } item $list ] \
            {3 4 5 6 7}

        proc getListXYZ { } {

            return {1 2 3 4 5}
        }

        my assertEquals \
            [ ::xox::mapcar { expr {3 + $item} } item [ getListXYZ ] ] \
            {4 5 6 7 8}
    }

    TestHigherOrderTcl instproc testRemoveIfNot { } {

        my assertEquals \
            [ ::xox::removeIfNot { ::xox::oddp $x } x { 1 2 3 4 5 } ] \
            {1 3 5}

        my assertEquals \
            [ ::xox::removeIf { ::xox::oddp $x } x { 1 2 3 4 5 } ] \
            {2 4}

        my assertEquals \
            [ ::xox::removeIf { expr { "2" == "$x" } } x { 1 2 3 4 5 } ] \
            {1 3 4 5}
    }

    TestHigherOrderTcl instproc testOddp { } {

        my assert [ ::xox::oddp 1 ]
        my assertFalse [ ::xox::oddp 2 ]

        my assert [ ::xox::oddp 51 ]
        my assertFalse [ ::xox::oddp 98 ]
    }

    TestHigherOrderTcl instproc testEvenp { } {

        my assertFalse [ ::xox::evenp 1 ]
        my assert [ ::xox::evenp 2 ]

        my assertFalse [ ::xox::evenp 51 ]
        my assert [ ::xox::evenp 98 ]
    }

    TestHigherOrderTcl instproc testWithOpenFile { } {

        set data nothing
        my assertEquals $data nothing
        my assertFalse [ info exists error ]

        ::xox::withOpenFile test/withOpenFile r file {

            set data [string trim [ read $file ] ]
            my assertEquals $data hello
        }

        my assertEquals $data hello
        my assertFalse [ info exists error ]
    }

    TestHigherOrderTcl instproc testWithOpenFileError { } {

       my assertError {
           
           ::xox::withOpenFile test/noSuchFile r file {

           }
       }

       my assertError { close $file }
    }

    TestHigherOrderTcl instproc testWithOpenScriptError { } {

        my assertError {

           ::xox::withOpenFile test/withOpenFile r file {

               error "script error"
           }
        }

        my assertError { close $file }
    }

    TestHigherOrderTcl instproc testReadFile { } {

        my assertFalse [ info exists data]

        my assertEquals hello [ string trim [ ::xox::readFile test/withOpenFile ]]
        
        my assertFalse [ info exists data]

    }

    TestHigherOrderTcl instproc testIdentity { } {

        my assertEquals [ ::xox::identity a ] a


        my assertEquals [ ::xox::mapcar {
            ::xox::identity $x 
        } x {1 2 3 4 5} ] {1 2 3 4 5}
    }

    TestHigherOrderTcl instproc testFlet { } {

        proc ::xox::test::do1234 { } {

            return 6
        }

        my assertEquals [ info commands ::xox::test::do1234 ] ::xox::test::do1234

        ::xox::flet ::xox::test::do1234 { } {
            return 5
        } {
            my assertEquals [ ::xox::test::do1234 ] 5 1
        }

        my assertEquals [ ::xox::test::do1234 ] 6 2
    }

    TestHigherOrderTcl instproc testIfEmpty { } {

        set a 0

        ::xox::ifEmpty "" {

            set a 5
        }

        my assertEquals $a 5

        set empty ""


        ::xox::ifEmpty "" {

            set a 3
        }

        my assertEquals $a 3

        ::xox::ifEmpty "" {

            return
        }

        my fail "ifEmpty should return"
    }

    TestHigherOrderTcl instproc testLet { } {

        set a 5

        my assertEquals $a 5 1

        ::xox::let {{a 6}} {

            my assertEquals $a 6 2
        }

        my assertEquals $a 5 3

        ::xox::let {{a 6}} {

            my assertEquals $a 6 4

            ::xox::let {{a 7}} {

                my assertEquals $a 7 5
            }

            my assertEquals $a 6 6
        }
    }

    TestHigherOrderTcl instproc testMultipleLet { } {

        set a 5
        set b 5
        set c 5
        set d 5

        my assertEquals $a 5 1
        my assertEquals $b 5 1
        my assertEquals $c 5 1
        my assertEquals $d 5 1

        ::xox::let {{a 6} {b 7} {c 8}} {

            my assertEquals $a 6 2
            my assertEquals $b 7 3
            my assertEquals $c 8 4
        }

        my assertEquals $a 5 1
        my assertEquals $b 5 1
        my assertEquals $c 5 1
        my assertEquals $d 5 1
    }

    TestHigherOrderTcl instproc testGlobalLet { } {

        namespace eval ::abc {
        }

        set ::abc::aGlobalVar 5

        my assertEquals $::abc::aGlobalVar 5

        ::xox::let {{::abc::aGlobalVar 6}} {

            my assertEquals $::abc::aGlobalVar 6
        }

        my assertEquals $::abc::aGlobalVar 5
    }

    TestHigherOrderTcl instproc testLetUnset { } {

        my assertFalse [ info exists a ]

        ::xox::let {{a 5}} {

            my assertEquals $a 5
        }

        my assertFalse [ info exists a ]
    }
}

package provide xox::test::TestHigherOrderTcl 1.0

