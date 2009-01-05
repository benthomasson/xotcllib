# Created at Mon Apr 21 01:01:36 PM EDT 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestSimpleObjectModelBuilder -superclass ::xounit::TestCase

    TestSimpleObjectModelBuilder parameter {

    }

    TestSimpleObjectModelBuilder instproc setUp { } {

        my instvar builder

        set builder [ ::xointerp::SimpleObjectModelBuilder new ]
    }

    TestSimpleObjectModelBuilder instproc testPlainObject { } {

        my instvar builder

        set object [ $builder buildObject [ Object new ] {

            set a 5
            set b 6
            set c 7
        } ]

        my assertObject $object
        my assertEquals [ $object set a ] 5
        my assertEquals [ $object set b ] 6
        my assertEquals [ $object set c ] 7

        my assertEqualsByLine [ my assertError {

        $builder buildObject $object {
            e 8
        } } ] " Invalid command: e 8"
    }

    TestSimpleObjectModelBuilder instproc testCustomObject { } {

        my instvar builder

        set object [ Object new ]

        $object parametercmd a
        $object parametercmd b
        $object parametercmd c

        set object [ $builder buildObject $object {

            set a 5
            set b 6
            set c 7
        } ]

        my assertObject $object
        my assertEquals [ $object set a ] 5
        my assertEquals [ $object set b ] 6
        my assertEquals [ $object set c ] 7

        $builder errorMessage "hey there"

        my assertEqualsByLine [ my assertError {

        $builder buildObject $object {
            e 8
        } } ] " Invalid command: e 8\nhey there"
    }

    TestSimpleObjectModelBuilder instproc tearDown { } {

        #add tear down code here
    }
}


