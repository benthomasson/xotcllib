# Created at Thu Feb 07 01:25:00 PM EST 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestClassModelBuildingInterpreter -superclass ::xointerp::test::TestModelBuildingInterpreter

    TestClassModelBuildingInterpreter parameter {

    }

    TestClassModelBuildingInterpreter instproc setUp { } {

        my instvar builder

        set builder [ ::xointerp::ClassModelBuildingInterpreter new ]
    }

    TestClassModelBuildingInterpreter instproc testSetUp { } {

        my instvar builder

        my assert [ $builder hasclass ::xointerp::ModelBuildingInterpreter ] 1
        my assert [ $builder hasclass ::xointerp::ClassModelBuildingInterpreter ] 2
    }

    TestClassModelBuildingInterpreter instproc testTestCase { } {

        my instvar builder

        set object [ $builder tclEval {

            ::xounit::TestCase {
                a 5
                b 6
                c 7
            }
        } ]

        my assertObject $object

        my assertEquals [ $object set a ] 5
        my assertEquals [ $object set b ] 6
        my assertEquals [ $object set c ] 7

        my assert [ $object hasclass ::xounit::TestCase ]
    }

    TestClassModelBuildingInterpreter instproc testSubTestCase { } {

        my instvar builder

        set object [ $builder tclEval {

            ::xounit::TestCase {
                a 5
                b 6
                c 7

                ::xounit::TestCase {

                    x 1
                    y 2
                    z 3
                }
            }
        } ]

        my assertObject $object

        my assertEquals [ $object set a ] 5
        my assertEquals [ $object set b ] 6
        my assertEquals [ $object set c ] 7
        my assertFalse [ $object exists ::xounit::TestCase ] "no TC variable"

        my assert [ $object hasclass ::xounit::TestCase ]

        set sub [ $object info children ]

        my assertObject $sub

        my assertEquals [ $sub set x ] 1
        my assertEquals [ $sub set y ] 2
        my assertEquals [ $sub set z ] 3

        my assert [ $sub hasclass ::xounit::TestCase ]
    }


    TestClassModelBuildingInterpreter instproc testBuildModel { } {

        my instvar builder

        set object [ ::xointerp::buildModel {

            ::xounit::TestCase {
                a 5
                b 6
                c 7
            }
        } ]

        my assertObject $object

        my assertEquals [ $object set a ] 5
        my assertEquals [ $object set b ] 6
        my assertEquals [ $object set c ] 7

        my assert [ $object hasclass ::xounit::TestCase ]
    }
}


