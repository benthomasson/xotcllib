# Created at Tue May 29 18:14:08 EDT 2007 by bthomass

package require xounit

namespace eval ::tclisp::test {

    namespace import -force ::xotcl::*
    namespace import -force ::tclisp::*

    Class TestTclisp -superclass ::xounit::TestCase

    TestTclisp parameter {

    }

    TestTclisp instproc testMapcar { } {

        my assertEquals \
            [ mapcar [ lambda { item } { 
                expr {1 + $item} 
                } ] {1 2 3 4 5} ] \
            {2 3 4 5 6}
        
        set list {1 2 3 4 5}

        my assertEquals \
            [ mapcar [ lambda { item } {
                expr {2 + $item} 
                } ] $list ] \
            {3 4 5 6 7}

        proc getListXYZ { } {

            return {1 2 3 4 5}
        }

        my assertEquals \
            [ mapcar [ lambda { item } {
                expr {3 + $item} 
                } ] [ getListXYZ ] ] \
            {4 5 6 7 8}
    }

    TestTclisp instproc testRemoveIfNot { } {

        my assertEquals \
            [ removeIfNot oddp { 1 2 3 4 5 } ] \
            {1 3 5}

        my assertEquals \
            [ removeIf oddp { 1 2 3 4 5 } ] \
            {2 4}

        my assertEquals \
            [ removeIf [ lambda { x } { expr { "2" == "$x" } } ] { 1 2 3 4 5 } ] \
            {1 3 4 5}
    }

    TestTclisp instproc testRemoveIfNot2 { } {

        my assertEquals \
            [ removeIfNot oddp { 1 2 3 4 5 } ] \
            {1 3 5}

        my assertEquals \
            [ removeIf oddp { 1 2 3 4 5 } ] \
            {2 4}

        my assertEquals \
            [ removeIf [ lambda { x } {
                expr { "2" == "$x" }
                } ] { 1 2 3 4 5 } ] \
            {1 3 4 5}
    }

    TestTclisp instproc testOddp { } {

        my assert [ oddp 1 ]
        my assertFalse [ oddp 2 ]

        my assert [ oddp 51 ]
        my assertFalse [ oddp 98 ]
    }

    TestTclisp instproc testEvenp { } {

        my assertFalse [ evenp 1 ]
        my assert [ evenp 2 ]

        my assertFalse [ evenp 51 ]
        my assert [ evenp 98 ]
    }

    TestTclisp instproc testWithOpenFile { } {

        set data nothing
        my assertEquals $data nothing
        my assertFalse [ info exists error ]

        ::tclisp::withOpenFile test/withOpenFile r file {

            set data [string trim [ read $file ] ]
            my assertEquals $data hello
        }

        my assertEquals $data hello
        my assertFalse [ info exists error ]
    }

    TestTclisp instproc testWithOpenFileError { } {

       my assertError {
           
           ::tclisp::withOpenFile test/noSuchFile r file {

           }
       }

       my assertError { close $file }
    }

    TestTclisp instproc testWithOpenScriptError { } {

        my assertError {

           ::tclisp::withOpenFile test/withOpenFile r file {

               error "script error"
           }
        }

        my assertError { close $file }
    }

    TestTclisp instproc testReadFile { } {

        my assertFalse [ info exists data]

        my assertEquals hello [ string trim [ ::tclisp::readFile test/withOpenFile ]]
        
        my assertFalse [ info exists data]

    }

    TestTclisp instproc testIdentity { } {

        my assertEquals [ identity a ] a


        my assertEquals [ mapcar {identity} \
        {1 2 3 4 5} ] {1 2 3 4 5}
    }

    TestTclisp instproc testFlet { } {

        proc ::tclisp::test::do1234 { } {

            return 6
        }

        my assertEquals [ info commands ::tclisp::test::do1234 ] ::tclisp::test::do1234

        flet ::tclisp::test::do1234 { } {
            return 5
        } {
            my assertEquals [ ::tclisp::test::do1234 ] 5 1
        }

        my assertEquals [ ::tclisp::test::do1234 ] 6 2
    }

    TestTclisp instproc testIfNull { } {

        set a 0

        ifNull "" {

            set a 5
        }

        my assertEquals $a 5

        set empty ""


        ifNull "" {

            set a 3
        }

        my assertEquals $a 3

        ifNull "" {

            return
        }

        my fail "ifNull should return"
    }

    TestTclisp instproc testLet { } {

        set a 5

        my assertEquals $a 5 1

        let {{a 6}} {

            my assertEquals $a 6 2
        }

        my assertEquals $a 5 3

        let {{a 6}} {

            my assertEquals $a 6 4

            let {{a 7}} {

                my assertEquals $a 7 5
            }

            my assertEquals $a 6 6
        }
    }

    TestTclisp instproc testMultipleLet { } {

        set a 5
        set b 5
        set c 5
        set d 5

        my assertEquals $a 5 1
        my assertEquals $b 5 1
        my assertEquals $c 5 1
        my assertEquals $d 5 1

        let {{a 6} {b 7} {c 8}} {

            my assertEquals $a 6 2
            my assertEquals $b 7 3
            my assertEquals $c 8 4
            set e 5
        }

        my assertEquals $a 5 1
        my assertEquals $b 5 1
        my assertEquals $c 5 1
        my assertEquals $d 5 1
        my assertEquals $e 5 e
    }

    TestTclisp instproc testGlobalLet { } {

        namespace eval ::abc {
        }

        set ::abc::aGlobalVar 5

        my assertEquals $::abc::aGlobalVar 5

        let {{::abc::aGlobalVar 6}} {

            my assertEquals $::abc::aGlobalVar 6
        }

        my assertEquals $::abc::aGlobalVar 5
    }

    TestTclisp instproc testLetUnset { } {

        my assertFalse [ info exists a ]

        let {{a 5}} {

            my assertEquals $a 5
        }

        my assertFalse [ info exists a ]
    }

    TestTclisp instproc testUplevelProc { } {

        proc ::tclisp::test::testUp { a b c } {

            return [ uplevel [ subst {

                set a [ incr b ]

                return "$a $b $c"
            } ] ]
        }

        set return [ ::tclisp::test::testUp 1 2 3 ]

        my assert [ info exists a ] a
        my assertFalse [ info exists b ] b
        my assertFalse [ info exists c ] c

        my assertEquals $return {1 3 3}
    }

    TestTclisp instproc testMapcar2 { } {

        my assertEquals \
            [ mapcar [ lambda { item } {
                                    expr {1 + $item} 
                            } ] {1 2 3 4 5} ] {2 3 4 5 6}
        
        set list {1 2 3 4 5}

        my assertEquals \
            [ mapcar [ lambda { item } { 
                                    expr {2 + $item}
                            } ] $list ] {3 4 5 6 7}

        proc getListXYZ { } {

            return {1 2 3 4 5}
        }

        my assertEquals \
            [ mapcar [ lambda { item } {
                                    expr {3 + $item} 
                            } ] [ getListXYZ ] ] {4 5 6 7 8}

       set add 4

        my assertEquals \
            [ mapcar [ lambda { item } {
                                    upvar add add
                                    expr {$add + $item} 
                            } ] [ getListXYZ ] ] {5 6 7 8 9}

        my assertEquals \
            [ mapcar list { 1 2 3 4 5 } { a b c d e } ] \
                [ list {1 a} {2 b} {3 c} {4 d} {5 e} ]
    }

    TestTclisp instproc testMappend2 { } {

        set map [ mapcar list { 1 2 3 4 5 } { a b c d e } ] 
        my assertEquals $map \
                [ list {1 a} {2 b} {3 c} {4 d} {5 e} ]

        set cat [ eval concat $map ]
        my assertEquals $cat \
                [ list 1 a 2 b 3 c 4 d 5 e ]

        my assertEquals \
            [ mappend list { 1 2 3 4 5 } { a b c d e } ] \
                [ list 1 a 2 b 3 c 4 d 5 e ]
    }

    TestTclisp instproc testMultipleWordCommand { } {

        my assertEquals \
            [ removeIfNot {::xotcl::Object isclass} \
                    {::xox::Package 4 5 ::xotcl::Object} ] \
                    {::xox::Package ::xotcl::Object}

        my assertEquals \
            [ mapcar {file tail} {a a/b /a/b/c} ] {a b c}

        my assertEquals \
            [ removeIf nullp [ list {} a b {} c {} ] ] {a b c}
    }

    TestTclisp instproc testOrdinals {} {

        my assertEquals [ first {1 2 3} ] 1 
        my assertEquals [ second {1 2 3} ] 2 
        my assertEquals [ third {1 2 3} ] 3
        my assertEquals [ forth {1 2 3} ] {}

    }

    TestTclisp instproc testZZZLambdas {} {

        mapcar [ lambda { name } {

            list [ info arg $name ] [ info body $name ] 

        } ] [ info proc ::tclisp::lambdas::* ] 
    }
}

package provide tclisp::test::TestTclisp 1.0

