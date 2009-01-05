# Created at Mon Jan 28 21:04:21 EST 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestModelBuildingInterpreter -superclass ::xounit::TestCase

    TestModelBuildingInterpreter parameter {

    }

    TestModelBuildingInterpreter instproc setUp { } {

        my instvar builder

        set builder [ ::xointerp::ModelBuildingInterpreter new ]
    }

    TestModelBuildingInterpreter instproc test { } {

        my instvar builder

        set object [ $builder tclEval {

            Object {
                a 5
                b 6
                c 7
            }
        } ]

        my assertObject $object
        my assertEquals [ $builder objects ] $object

        my assertEquals [ $object set a ] 5
        my assertEquals [ $object set b ] 6
        my assertEquals [ $object set c ] 7
    }

    TestModelBuildingInterpreter instproc testMultipleObjects { } {

        my instvar builder

        set objects [ $builder tclEval {

            Object {
                a 1
            }

            Object {
                b 2
            }

            Object {
                c 3
            }

            Object {
                d 4
            }
        } ]

        my assertEquals [ llength $objects ] 4

        foreach object $objects {

            my assertObject $object
        }
        
        set a [ lindex $objects 0 ]
        set b [ lindex $objects 1 ]
        set c [ lindex $objects 2 ]
        set d [ lindex $objects 3 ]

        my assertEquals [ $a set a ] 1
        my assertEquals [ $b set b ] 2 
        my assertEquals [ $c set c ] 3
        my assertEquals [ $d set d ] 4

        my assertFalse [ $b exists a ]
        my assertFalse [ $c exists a ]
        my assertFalse [ $d exists a ]

        my assertFalse [ $a exists b ]
        my assertFalse [ $c exists b ]
        my assertFalse [ $d exists b ]

        my assertFalse [ $a exists c ]
        my assertFalse [ $b exists c ]
        my assertFalse [ $d exists c ]

        my assertFalse [ $a exists d ]
        my assertFalse [ $b exists d ]
        my assertFalse [ $c exists d ]
    }

    TestModelBuildingInterpreter instproc testMethod { } {

        my instvar builder

        set object [ $builder tclEval {

            Object {

                set d 6
            }
        } ]

        my assertEquals [ $object set d ] 6
    }

    TestModelBuildingInterpreter instproc testChild { } {

        my instvar builder

        set object [ $builder tclEval {

            Object {

                Object {

                }
            }
        } ]

        my assertObject $object
        my assertObject [ $object info children ]
    }

    TestModelBuildingInterpreter instproc testNamedObject { } {

        my instvar builder

        set object [ $builder tclEval {

            Object ::TestObjectXYZABC {

            }
        } ]

        my assertObject $object
        my assertEquals $object ::TestObjectXYZABC
    }

    TestModelBuildingInterpreter instproc testNamedObjectChild { } {

        my instvar builder

        set object [ $builder tclEval {

            Object ::TestObjectXYZABC {

                Object ChildA {

                }
            }
        } ]

        my assertObject $object
        my assertEquals $object ::TestObjectXYZABC
        my assertObject ${object}::ChildA
        my assertEquals [ $object info children ] ::TestObjectXYZABC::ChildA
    }

    TestModelBuildingInterpreter instproc testOnlyClassNameFails { } {

        my instvar builder

        my assertError {

        set object [ $builder tclEval {

            Object
        } ]

        }
    }

    TestModelBuildingInterpreter instproc testObjectReEntry { } {

        my instvar builder

        catch { ::A destroy }

        set object [ $builder tclEval {

            Object ::A {
                a 5
            }

            Object ::A {
                b 6
            }

            Object ::A {
                c 7
            }
        } ]

        my assertEquals $object ::A

        my assertObject $object object

        my assertEquals [ $object set a ] 5
        my assertEquals [ $object set b ] 6
        my assertEquals [ $object set c ] 7
    }

    TestModelBuildingInterpreter instproc testVariable { } {

        my instvar builder

        catch { ::A destroy }

        set object [ Object new -set a 5 ]

        $builder environment $object

        puts "[ info level ]"

        my assertObject [ $builder environment ] object
        my assertEquals [ $builder environment ] $object
        my assertEquals [ $object set a ] 5 object-a

        set anotherObject [ $builder tclEval {

            Object ::A {
                a $a
            }
        } ]

        my assertEquals $anotherObject ::A

        my assertObject $anotherObject anotherObject

        my assertEquals [ $anotherObject set a ] 5 anotherObject-a
    }

    TestModelBuildingInterpreter instproc testAddToModel { } {

        my instvar builder

        set model [ Object new ]

        set model2 [ $builder addToModel $model {
                title "A Title"
        } ]

        my assertObject $model model
        my assertObject $model2 model2
        my assertEquals $model $model2
    }

    TestModelBuildingInterpreter instproc testAddToModel2 { } {

        my instvar builder

        set model [ Object new ]

        set model2 [ $builder addToModel $model {
                title "A Title"
                Object A {
                    name abc

                }
        } ]

        my assertObject $model model
        my assertObject $model2 model2
        my assertEquals $model $model2

        my assertObjectTreeValues $model {
            title "A Title"
            A {
                name abc
            }
        }
    }

    TestModelBuildingInterpreter instproc testCallInit { } {

        set builder [ ::xointerp::NamespaceModelBuildingInterpreter new -namespaces ::xointerp::test ]

        $builder callInit 1

        Class create ::xointerp::test::TestCallInit

        ::xointerp::test::TestCallInit instproc init { } {
            my set a 5
        }

        my assertTrue [ my isclass ::xointerp::test::TestCallInit ] isclass

        set object [ $builder tclEval {

            TestCallInit {
                a 4
                b 6
                c 7
            }
        } ]

        my assertObject $object object
        my assertTrue [ $object hasclass ::xointerp::test::TestCallInit ] hasclass

        my assertObjectValues $object {
            a 5
            b 6 
            c 7 
        }
    }

    TestModelBuildingInterpreter instproc testCallInit2 { } {

        set builder [ ::xointerp::ClassModelBuildingInterpreter new ]

        $builder callInit 1

        Class create ::xointerp::test::TestCallInit -superclass ::xox::Node

        ::xointerp::test::TestCallInit instproc init { } {
            my set a 5
        }

        my assertTrue [ my isclass ::xointerp::test::TestCallInit ] isclass

        set object [ $builder tclEval {

            ::xointerp::test::TestCallInit {
                a 4
                b 6
                c 7
                ::xointerp::test::TestCallInit Inner {
                    a 4
                    x 1
                    y 0
                    z -1
                }
            }
        } ]

        my assertObject $object object
        my assertTrue [ $object hasclass ::xointerp::test::TestCallInit ] hasclass

        my assertObjectTreeValues $object {
            a 5
            b 6 
            c 7 
            Inner {
                a 5
                x 1
                y 0
                z -1
            }
        }
    }
}


