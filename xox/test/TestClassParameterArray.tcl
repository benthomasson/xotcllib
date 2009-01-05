

package provide xox::test::TestClassParameterArray 1.0

package require xounit
package require xox::test

namespace eval ::xox::test {

    Class TestClassParameterArray -superclass ::xounit::TestCase

    Class create A1 
    A1 classParameterArray a
    A1 classParameterArray b
    A1 classParameterArray c
    A1 classParameterArray d
    A1 classParameterArray e
    A1 set a(1) 1

    Class create B1 -superclass ::xotcl::Class
    
    B1 create C1
    C1 classParameterArray a
    C1 classParameterArray b
    C1 classParameterArray c
    C1 classParameterArray d
    C1 classParameterArray e
    C1 set b(1) 1
    
    Class create D1 -superclass ::xotcl::Class

    D1 create E1
    E1 set a(1) 1
    E1 set b(1) 2
    E1 set c(1) 3
    E1 set d(1) 4
    E1 classParameterArray a
    E1 classParameterArray b
    E1 classParameterArray c
    E1 classParameterArray d

    Class create F1 -superclass ::xotcl::Class


    F1 create G1
    F1 create H1 -superclass ::xox::test::G1

    G1 classParameterArray data
    G1 classParameterArray nodata
    G1 set data(1) "shared data"

    TestClassParameterArray instproc testBasic {} {

        my assertEquals [ ::xox::test::A1 array exists a ] 1
        my assertEquals [ ::xox::test::A1 set a(1) ] 1

        set a [ ::xox::test::A1 new ]

        my assert [ Object isobject $a ]
        my assert [ $a hasclass ::xox::test::A1 ]

        my assertFalse [ $a exists a(1) ]

        my assertEquals [ $a a 1 ] 1

        $a a 1 2
        my assert [ $a exists a ]
        my assertEquals [ $a a 1 ] 2
    }

    TestClassParameterArray instproc testSubclass {} {

        my assertEquals [ ::xox::test::C1 array exists b ] 1
        my assertEquals [ ::xox::test::C1 set b(1) ] 1

        set c [ ::xox::test::C1 new ]

        my assert [ Object isobject $c ]
        my assert [ $c hasclass ::xox::test::C1 ]

        my assertFalse [ $c exists b(1) ]

        my assertEquals [ $c b 1 ] 1

        $c b 1 2
        my assert [ $c exists b ]
        my assertEquals [ $c b 1 ] 2
    }

    TestClassParameterArray instproc testParameterValue {} {

        my assertEquals [ ::xox::test::E1 array exists b ] 1 1
        my assertEquals [ ::xox::test::E1 set b(1) ] 2 2

        set e [ ::xox::test::E1 new ]

        my assert [ Object isobject $e ] 3
        my assert [ $e hasclass ::xox::test::E1 ] 4

        my assertFalse [ $e array exists b ] 5

        my assertEquals [ $e b 1 ] 2 6

        $e b 1 3
        my assert [ $e exists b(1) ] 7
        my assertEquals [ $e b 1 ] 3 8
    }

    TestClassParameterArray instproc testClassHierarchy {} {

        my assertEquals [ ::xox::test::G1 exists data ] 1
        my assertEquals [ ::xox::test::G1 set data(1) ] "shared data"
        my assertNotEquals [ ::xox::test::H1 array exists data ] 1


        set h [ ::xox::test::H1 new ]

        my assert [ Object isobject $h ]
        my assert [ $h hasclass ::xox::test::H1 ]

        my assertFalse [ $h array exists data ]

        my assertEquals [ $h data 1 ] "shared data"
        catch {
        $h nodata 1
        } result

        my assertEquals "Could not find nodata in any of ::xox::test::H1 ::xox::test::G1 ::xotcl::Object!" $result
    }
}

