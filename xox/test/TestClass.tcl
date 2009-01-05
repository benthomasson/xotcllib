package provide xox::test::TestClass 1.0

package require XOTcl
package require xox

namespace eval ::xox::test {

    ::xotcl::Class TestClass -superclass ::xounit::TestCase

    TestClass instproc testGetPackage {} {

        my assertEquals [ ::xox::test::TestClass getPackage ] ::xox
    }

    TestClass instproc testVersion { } {

        my assertEquals [ [ ::xox::Class new ] version ] 1.0

        set class [ ::xox::Class new -id "X Y 1.1 Z A" ]
        my assertEquals [ $class version ] 1.1
    }

    TestClass instproc testTag { } {

        set class [ ::xotcl::Class new ] 

        $class @tag a xyz

        my assertFalse [ $class hasTag a abc ] 
        my assert [ $class hasTag a xyz ] 
    }

    TestClass instproc testClassUnknown { } {

        set name [ Class XYZ123 ]
        my assertEquals $name ::xox::test::XYZ123
    }

    TestClass instproc testObjectUnknown { } {

        my assertError {

            Object XYZ123
        }
    }
   
}
