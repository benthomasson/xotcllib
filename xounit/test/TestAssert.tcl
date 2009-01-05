

namespace eval ::xounit::test {

    namespace import -force ::xotcl::*

    Class TestAssert -superclass ::xounit::TestCase

    TestAssert instproc testAssert1 {} {

        my assert 1 {Test true}
    }

    TestAssert instproc testAssert0 {} {

        my assertFailure { my assert 0 {Passed} }
    }

    TestAssert instproc testAssertExists {} {

       my assertFailure { my assertExists someVariable }
       my assertNotExists someVariable
       my set someVariable someValue
       my assertExists someVariable 
       my assertFailure { my assertNotExists someVariable }
    }

    TestAssert instproc testAssertExists2 {} {

       set a [ ::xounit::Assert new ]

       my assertFailure { $a assertExists someVariable }
       $a assertNotExists someVariable
       $a set someVariable someValue
       $a assertExists someVariable 
       my assertFailure { $a assertNotExists someVariable }
    }

    TestAssert instproc testAssertExistsValue {} {

       set a [ ::xounit::Assert new ]

       my assertFailure { $a assertExistsValue someVariable }
       $a set someVariable ""
       my assertFailure { $a assertExistsValue someVariable }
       $a set someVariable someValue
       $a assertExistsValue someVariable 
    }

    TestAssert instproc testFailure {} {

        my assertEquals [ [ my assertFailure { my fail ack } ] message ] ack
    }

    TestAssert instproc testNoFailure {} {

        my assertNoFailure { }
        my assertFailure { my assertNoFailure { my fail ack } }
    }

    TestAssert instproc testAssertDoNotFindIn {} {

        my assertDoNotFindIn a b
        my assertFailure { my assertDoNotFindIn a a }
    }

    TestAssert instproc testAssertObject {} {

        my assertObject [ Object new ] 
        set old [ Object new ]
        $old destroy
        my assertFailure { my assertObject $old }
    }

    TestAssert instproc testAssertExistsObject {} {

        set a [ ::xounit::Assert new ]

        $a set a 5
        $a set o [ Object new ]

        my assertFailure { $a assertExistsObject a }
        my assertFailure { $a assertExistsObject b }
        $a assertExistsObject o
    }

    TestAssert instproc testAssertFindIn {} {

        set a [ ::xounit::Assert new ]

        $a assertFindIn a a "Should find a"
        $a assertFindIn a abcdefgh "Should find a"
        $a assertFindIn a "
        
        abcdefgh" "Should find a"

        $a assertFindIn TestCasesAreCool "I dont know about you but I think TestCasesAreCool" 

        my assertFailure { $a assertFindIn b a }

        my assertFailure { $a assertFindIn "" a }
    }

    TestAssert instproc testRegexPositive {} {

        set a [ ::xounit::Assert new ]

        $a assertRegex a a

        $a assertRegex . a

        set all [ $a assertRegex {!+} !!!!. ]

        my assertEquals !!!! $all 
    }

    TestAssert instproc testRegexFail {} {

        set a [ ::xounit::Assert new ]

        my assertFailure {

        $a assertRegex a b

        } "\$a assertRegex a b should have failed"
    }

    TestAssert instproc testAssertError { } {

        my assertNoError { set a 1 } "A"
        my assertError { error a } "B"
    }

    TestAssert instproc testAssertNoErrorFail { } {

        my assertFailure {

        my assertNoError { error Passed } "Passed"

        }
    }

    TestAssert instproc testAssertErrorFail { } {

        my assertFailure {

        my assertError { set a Passed } "Passed"

        }
    }

    TestAssert instproc testAssertInteger { } {

        my assertInteger 0
        my assertInteger -100
        my assertInteger 100

        my assertFailure { my assertInteger A }
        my assertFailure { my assertInteger "" }
        my assertFailure { my assertInteger [ Object new ] }
    }

    TestAssert instproc testAssertIntegerInRange { } {

        my assertIntegerInRange 0 0 1
        my assertIntegerInRange -100 -1000 0
        my assertIntegerInRange 100 0 1000 

        my assertFailure { my assertIntegerInRange A 0 100 }
        my assertFailure { my assertIntegerInRange "" 0 100 }
        my assertFailure { my assertIntegerInRange [ Object new ] 0 100 }
        my assertFailure { my assertIntegerInRange -1 0 100 }
        my assertFailure { my assertIntegerInRange 101 0 100 }
    }

    TestAssert instproc testAssertValueInList { } {

        set list ""

        my assertFailure { my assertValueInList $list A }
        my assertFailure { my assertValueInList $list B }

        set list [ list A B ]

        my assertValueInList $list A
        my assertValueInList $list B

        set list [ list A ]

        my assertValueInList $list A
        my assertFailure { my assertValueInList $list B }

        set list [ list B ]

        my assertValueInList $list B
        my assertFailure { my assertValueInList $list A }
    }

    TestAssert instproc testAssertObjectInList { } {

        set objects ""

        set o1 [ ::xotcl::Object new ]
        set o2 [ ::xotcl::Object new ]

        my assertFailure { my assertObjectInList $objects $o1 }
        my assertFailure { my assertObjectInList $objects $o2 }

        set objects [ list $o1 $o2 ]

        my assertObjectInList $objects $o1
        my assertObjectInList $objects $o2

        set objects [ list $o1 ]

        my assertObjectInList $objects $o1
        my assertFailure { my assertObjectInList $objects $o2 }

        set objects [ list $o2 ]

        my assertObjectInList $objects $o2
        my assertFailure { my assertObjectInList $objects $o1 }
    }

    TestAssert instproc notestCheck { } {

        my assertFalse [ my catchAndReport {

            my assertFalse 1 "testCheck pass"
        } ]
    }

    TestAssert instproc testAssertEmpty { } {

        my assertEmpty ""

        my assertFailure {

            my assertEmpty "not empty"
        }
    }

    TestAssert instproc testAssertObjectValues { } {

        set object [ Object new ]

        $object set a 5
        $object set b 6
        $object set c 7
        $object set d 8

        my assertObjectValues $object {
            a 5
            b 6
            c 7
            d 8
        }

        my assertFailure {

            my assertObjectValues $object {
                a 5
                b 6
                c 7
                d 8
                e 9
            }
        }
    }

    TestAssert instproc testAssertObjectTreeValues { } {

        set object [ Object new ]

        $object set a 5
        $object set b 6
        $object set c 7
        $object set d 8

        set child [ Object create ${object}::child ]

        $child set e 9
        $child set f 10

        my assertObjectTreeValues $object {
            a 5
            b 6
            c 7
            d 8
            child {
                e 9
                f 10
            }
        }

        my assertFailure {

            my assertObjectTreeValues $object {
                a 5
                b 6
                c 7
                d 8
                child {
                    e 9
                    f 11
                }
            }
        }

        my assertFailure {

            my assertObjectTreeValues $object {
                a 5
                b 6
                c 7
                d 8
                notchild {
                    e 9
                    f 10
                }
            }
        }
    }

    TestAssert instproc testAssertDomEquals { } {

        set assert [ ::xounit::Assert new ]

        package require tdom

        set x [ [ dom parse "<root/>" ] documentElement ]
        set y [ [ dom parse "<root/>" ] documentElement ]
        $assert assertDomEquals $x $y "" 1

        set x [ [ dom parse "<root/>" ] documentElement ]
        set y [ [ dom parse "<notroot/>" ] documentElement ]
        my assertFailure { $assert assertDomEquals $x $y "" } 2

        set x [ [ dom parse "<root/>" ] documentElement ]
        set y [ [ dom parse "<notroot/>" ] documentElement ]
        $assert assertDomEquals $x $y "root" 3

        set x [ [ dom parse "<root>text</root>" ] documentElement ]
        set y [ [ dom parse "<root>text</root>" ] documentElement ]
        $assert assertDomEquals $x $y "" 4

        set x [ [ dom parse "<root>text</root>" ] documentElement ]
        set y [ [ dom parse "<root>not text</root>" ] documentElement ]
        my assertFailure { $assert assertDomEquals $x $y "" } 5

        set x [ [ dom parse "<root><a>text</a></root>" ] documentElement ]
        set y [ [ dom parse "<root><a>text</a></root>" ] documentElement ]
        $assert assertDomEquals $x $y "" 6

        set x [ [ dom parse "<root><a>text</a></root>" ] documentElement ]
        set y [ [ dom parse "<root><a>not text</a></root>" ] documentElement ]
        my assertFailure { $assert assertDomEquals $x $y "" } 7

        set x [ [ dom parse "<root><extra/><a>text</a></root>" ] documentElement ]
        set y [ [ dom parse "<root><a>text</a></root>" ] documentElement ]
        $assert assertDomEquals $x $y "extra" 8

        set x [ [ dom parse "<root><extra/><a>text</a></root>" ] documentElement ]
        set y [ [ dom parse "<root><a>not text</a></root>" ] documentElement ]
        my assertFailure { $assert assertDomEquals $x $y "extra" } 9

        set x [ [ dom parse "<root><a>text</a><extra/></root>" ] documentElement ]
        set y [ [ dom parse "<root><a>text</a></root>" ] documentElement ]
        $assert assertDomEquals $x $y "extra" 9.1

        set x [ [ dom parse "<root><a>text</a></root>" ] documentElement ]
        set y [ [ dom parse "<root><a>text</a><extra/></root>" ] documentElement ]
        $assert assertDomEquals $x $y "extra" 9.2

        set x [ [ dom parse "<root><a>text</a><extra/></root>" ] documentElement ]
        set y [ [ dom parse "<root><a>text</a><extra/></root>" ] documentElement ]
        $assert assertDomEquals $x $y "extra" 9.3

        set x [ [ dom parse "<root><a>text</a><extra/><x/></root>" ] documentElement ]
        set y [ [ dom parse "<root><a>text</a><extra/></root>" ] documentElement ]
        my assertFailure { $assert assertDomEquals $x $y "extra" } 9.4

        set x [ [ dom parse "<root><a>text</a><extra/></root>" ] documentElement ]
        set y [ [ dom parse "<root><a>text</a><extra/><y/></root>" ] documentElement ]
        my assertFailure { $assert assertDomEquals $x $y "extra" } 9.5

        set x [ [ dom parse "<root><a>text</a><extra/><extra/></root>" ] documentElement ]
        set y [ [ dom parse "<root><a>text</a></root>" ] documentElement ]
        $assert assertDomEquals $x $y "extra" 9.6

        set x [ [ dom parse "<root><a>text</a><extra/><x/><extra/></root>" ] documentElement ]
        set y [ [ dom parse "<root><a>text</a><x/></root>" ] documentElement ]
        $assert assertDomEquals $x $y "extra" 9.7

        set x [ [ dom parse "<root><a>text</a><extra/><x/><extra/><y/></root>" ] documentElement ]
        set y [ [ dom parse "<root><a>text</a><x/><y/></root>" ] documentElement ]
        $assert assertDomEquals $x $y "extra" 9.7

        set x [ [ dom parse "<root><a>text</a><extra/></root>" ] documentElement ]
        set y [ [ dom parse "<root><a>text</a></root>" ] documentElement ]
        my assertFailure { $assert assertDomEquals $x $y "" } 10

        set x [ [ dom parse "<root><a>text</a></root>" ] documentElement ]
        set y [ [ dom parse "<root><a>text</a><extra/></root>" ] documentElement ]
        my assertFailure { $assert assertDomEquals $x $y "" } 11
    } 

    TestAssert instproc testAssertXmlEquals { } {

        set assert [ ::xounit::Assert new ]

        package require tdom

        $assert assertXmlEquals "<root/>" "<root/>" "" 1

        set x "<root/>" 
        set y "<notroot/>" 
        my assertFailure { $assert assertXmlEquals $x $y "" } 2

        set x "<root/>" 
        set y "<notroot/>" 
        $assert assertXmlEquals $x $y "root" 3

        set x "<root>text</root>" 
        set y "<root>text</root>" 
        $assert assertXmlEquals $x $y "" 4

        set x "<root>text</root>" 
        set y "<root>not text</root>" 
        my assertFailure { $assert assertXmlEquals $x $y "" } 5

        set x "<root><a>text</a></root>" 
        set y "<root><a>text</a></root>" 
        $assert assertXmlEquals $x $y "" 6

        set x "<root><a>text</a></root>" 
        set y "<root><a>not text</a></root>" 
        my assertFailure { $assert assertXmlEquals $x $y "" } 7

        set x "<root><extra/><a>text</a></root>" 
        set y "<root><a>text</a></root>" 
        $assert assertXmlEquals $x $y "extra" 8

        set x "<root><extra/><a>text</a></root>" 
        set y "<root><a>not text</a></root>" 
        my assertFailure { $assert assertXmlEquals $x $y "extra" } 9

        set x "<root><a>text</a><extra/></root>" 
        set y "<root><a>text</a></root>" 
        $assert assertXmlEquals $x $y "extra" 9.1

        set x "<root><a>text</a></root>" 
        set y "<root><a>text</a><extra/></root>" 
        $assert assertXmlEquals $x $y "extra" 9.2

        set x "<root><a>text</a><extra/></root>" 
        set y "<root><a>text</a><extra/></root>" 
        $assert assertXmlEquals $x $y "extra" 9.3

        set x "<root><a>text</a><extra/><x/></root>" 
        set y "<root><a>text</a><extra/></root>" 
        my assertFailure { $assert assertXmlEquals $x $y "extra" } 9.4

        set x "<root><a>text</a><extra/></root>" 
        set y "<root><a>text</a><extra/><y/></root>" 
        my assertFailure { $assert assertXmlEquals $x $y "extra" } 9.5

        set x "<root><a>text</a><extra/><extra/></root>" 
        set y "<root><a>text</a></root>" 
        $assert assertXmlEquals $x $y "extra" 9.6

        set x "<root><a>text</a><extra/><x/><extra/></root>" 
        set y "<root><a>text</a><x/></root>" 
        $assert assertXmlEquals $x $y "extra" 9.7

        set x "<root><a>text</a><extra/><x/><extra/><y/></root>" 
        set y "<root><a>text</a><x/><y/></root>" 
        $assert assertXmlEquals $x $y "extra" 9.7

        set x "<root><a>text</a><extra/></root>" 
        set y "<root><a>text</a></root>" 
        my assertFailure { $assert assertXmlEquals $x $y "" } 10

        set x "<root><a>text</a></root>" 
        set y "<root><a>text</a><extra/></root>" 
        my assertFailure { $assert assertXmlEquals $x $y "" } 11
    } 
}
