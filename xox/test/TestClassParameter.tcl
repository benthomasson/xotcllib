

package provide xox::test::TestClassParameter 1.0

package require xounit
package require xox::test

namespace eval ::xox::test {

    Class TestClassParameter -superclass ::xounit::TestCase

    Class create A 
    A parametercmd a
    A classParameter a
    A classParameter b
    A classParameter c
    A classParameter d
    A classParameter e
    A a 1

    Class create B -superclass ::xotcl::Class
    
    B parameter b

    B create C
    C classParameter a
    C classParameter b
    C classParameter c
    C classParameter d
    C classParameter e
    C b 1
    
    Class create D -superclass ::xotcl::Class

    D parameter { 
        { a 1 }
        { b 2 }
        { c 3 }
        { d 4 } 
    }

    D create E
    E classParameter a
    E classParameter b
    E classParameter c
    E classParameter d

    Class create F -superclass ::xotcl::Class


    F create G
    F create H -superclass ::xox::test::G

    G parametercmd data
    G classParameter data
    G parametercmd nodata
    G classParameter nodata
    G data "shared data"

    TestClassParameter instproc testBasic {} {

        my assertEquals [ ::xox::test::A exists a ] 1
        my assertEquals [ ::xox::test::A a ] 1

        set a [ ::xox::test::A new ]

        my assert [ Object isobject $a ]
        my assert [ $a hasclass ::xox::test::A ]

        my assertFalse [ $a exists a ]

        my assertEquals [ $a a ] 1

        $a a 2
        my assert [ $a exists a ]
        my assertEquals [ $a a ] 2
    }

    TestClassParameter instproc testSubclass {} {

        my assertEquals [ ::xox::test::C exists b ] 1
        my assertEquals [ ::xox::test::C b ] 1

        set c [ ::xox::test::C new ]

        my assert [ Object isobject $c ]
        my assert [ $c hasclass ::xox::test::C ]

        my assertFalse [ $c exists b ]

        my assertEquals [ $c b ] 1

        $c b 2
        my assert [ $c exists b ]
        my assertEquals [ $c b ] 2
    }

    TestClassParameter instproc testParameterValue {} {

        my assertEquals [ ::xox::test::E exists b ] 1
        my assertEquals [ ::xox::test::E b ] 2

        set e [ ::xox::test::E new ]

        my assert [ Object isobject $e ]
        my assert [ $e hasclass ::xox::test::E ]

        my assertFalse [ $e exists b ]

        my assertEquals [ $e b ] 2

        $e b 3
        my assert [ $e exists b ]
        my assertEquals [ $e b ] 3
    }

    TestClassParameter instproc testClassHierarchy {} {

        my assertEquals [ ::xox::test::G exists data ] 1
        my assertEquals [ ::xox::test::G data ] "shared data"
        my assertNotEquals [ ::xox::test::H exists data ] 1


        set h [ ::xox::test::H new ]

        my assert [ Object isobject $h ]
        my assert [ $h hasclass ::xox::test::H ]

        my assertFalse [ $h exists data ]

        my assertEquals [ $h data ] "shared data"
        catch {
        $h nodata 
        } result

        my assertEquals "Could not find nodata in any of ::xox::test::H ::xox::test::G ::xotcl::Object!" $result
    }
}

