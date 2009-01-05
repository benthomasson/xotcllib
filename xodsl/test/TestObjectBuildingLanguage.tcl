# Created at Sun Oct 19 16:44:40 EDT 2008 by bthomass

namespace eval ::xodsl::test {

    Class TestObjectBuildingLanguage -superclass ::xounit::TestCase

    TestObjectBuildingLanguage parameter {

    }

    TestObjectBuildingLanguage instproc setUp { } {

        my instvar language environment object

        set language [ ::xodsl::ObjectBuildingLanguage newLanguage ]
        set environment [ $language set environment ]
        set object [ Object new ]
        $language set object $object
        ::xodsl::ObjectBuildingLanguage updateObjectEnvironment $language

        #add set up code here
    }

    TestObjectBuildingLanguage instproc testBuildNewObject { } {

        my instvar language environment object

        $language buildNewObject 

        my assertNotEquals $object [ $language set object ]
        my assertObject [ $language set object ]
    }

    TestObjectBuildingLanguage instproc testSetValues { } {

        my instvar language environment

        $environment eval {

            - a 5
            - b 6
            - c 7
        }

        my assert [ $language exists object ] object

        my assertObjectValues [ $language set object ] {
            a 5
            b 6 
            c 7
        }
        set object [ $language set object ]
        my assertFalse [ $object exists d ] d

        #implement test here
    }

    TestObjectBuildingLanguage instproc testCreateChildObject { } {

        my instvar language environment

        $environment eval {

            Object { } 

        }

        my assert [ $language exists object ] object
        set object [ $language set object ]
        my assertObject [ $object info children ]
    }

    TestObjectBuildingLanguage instproc testCreateChildObject { } {

        my instvar language environment

        $environment eval {

            Object { 
                - a 5
                - b 6
                - c 7777
            }
        }

        my assert [ $language exists object ] object
        set object [ $language set object ]
        my assertObject [ $object info children ]

        my assertObjectValues [ $object info children ] {
            a 5
            b 6
            c 7777
        }
    }

    TestObjectBuildingLanguage instproc testCreateChildNamedObject { } {

        my instvar language environment

        $environment eval {

            Object One { 
                - a 5
                - b 6
                - c 7777
            }
        }

        my assert [ $language exists object ] object
        set object [ $language set object ]
        my assertObject [ $object info children ]
        my assertEquals ${object}::One [ $object info children ]
        my assertObjectTreeValues $object {
            One {
                a 5
                b 6
                c 7777
            }
        }
    }

    TestObjectBuildingLanguage instproc tearDown { } {

        #add tear down code here
    }
}


