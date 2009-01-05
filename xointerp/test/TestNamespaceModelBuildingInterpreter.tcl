# Created at Thu Feb 07 01:48:33 PM EST 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestNamespaceModelBuildingInterpreter -superclass ::xointerp::test::TestClassModelBuildingInterpreter

    TestNamespaceModelBuildingInterpreter parameter {

    }

    TestNamespaceModelBuildingInterpreter instproc setUp { } {

        my instvar builder

        set builder [ ::xointerp::NamespaceModelBuildingInterpreter new -namespaces { ::xounit ::xoexception } ]
    }

    TestNamespaceModelBuildingInterpreter instproc testSetUp { } {

        my instvar builder

        my assert [ $builder hasclass ::xointerp::ModelBuildingInterpreter ] 1
        my assert [ $builder hasclass ::xointerp::ClassModelBuildingInterpreter ] 2
    }

    TestNamespaceModelBuildingInterpreter instproc testTestCase2 { } {

        my instvar builder

        set object [ $builder tclEval {

            TestCase {
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

    TestNamespaceModelBuildingInterpreter instproc testSubTestCase2 { } {

        my instvar builder

        set object [ $builder tclEval {

            TestCase {
                a 5
                b 6
                c 7

                TestCase {

                    x 1
                    y 2
                    z 3
                }
            }
        } ]

        my assertObject $object object

        my assertEquals [ $object set a ] 5
        my assertEquals [ $object set b ] 6
        my assertEquals [ $object set c ] 7
        my assertFalse [ $object exists ::xounit::TestCase ] "no TC variable"

        my assert [ $object hasclass ::xounit::TestCase ]

        set sub [ $object info children ]

        my assertObject $sub sub

        my assertEquals [ $sub set x ] 1
        my assertEquals [ $sub set y ] 2
        my assertEquals [ $sub set z ] 3

        my assert [ $sub hasclass ::xounit::TestCase ]
    }
}


