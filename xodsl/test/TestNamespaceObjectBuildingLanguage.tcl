# Created at Sun Oct 19 17:29:49 EDT 2008 by ben

namespace eval ::xodsl::test {

    Class TestNamespaceObjectBuildingLanguage -superclass ::xounit::TestCase

    TestNamespaceObjectBuildingLanguage parameter {

    }

    TestNamespaceObjectBuildingLanguage instproc setUp { } {

        my instvar language environment

        set language [ ::xodsl::NamespaceObjectBuildingLanguage newLanguage -packages xox ]
        set environment [ $language set environment ]

        #add set up code here
    }

    TestNamespaceObjectBuildingLanguage instproc testSetup { } {

        my instvar language environment

        my assertObject $language
        my assertObject $environment

        my assertEquals [ $language set environment ] $environment
    }

    TestNamespaceObjectBuildingLanguage instproc testBuildNewObject { } {

        my instvar language environment

        $language buildNewObject ::xox::Node

        my assertObject [ $language set object ]
    }

    TestNamespaceObjectBuildingLanguage instproc testSetValues { } {

        my instvar language environment

        $language buildNewObject ::xox::Node

        $environment eval {
            - a 5
            - b 6
            - c 7
        }

        my assertObjectValues [ $language set object ] {
            a 5
            b 6
            c 7
        }
    }

    TestNamespaceObjectBuildingLanguage instproc testChildNode { } {

        my instvar language environment

        $language buildNewObject ::xox::Node

        $environment eval {
            - a 1
            - b 2
            - c 3
            Node {
                - a 5
                - b 6
                - c 7
                nodeOrder 9
            }
            - a a
            - b b
            - c c
            nodeOrder 8
        }

        set object [ $language set object ]
 
        my assertObjectValues $object {
            a a
            b b
            c c
            nodeOrder 8
        }

        set child [ $object info children ]

        my assertObjectValues $child {
            a 5
            b 6
            c 7
            nodeOrder 9
        }
    }

    TestNamespaceObjectBuildingLanguage instproc testVariables { } {

        my instvar language environment

        $language buildNewObject ::xox::Node

        $environment set b 5

        $environment eval {
            - b 7
            - a $b
        }

        set object [ $language set object ]
 
        my assertObjectValues $object {
            a 5
            b 7
        }
    }

    TestNamespaceObjectBuildingLanguage instproc testChildVariables { } {

        my instvar language environment

        $language buildNewObject ::xox::Node

        $environment set b 5

        $environment eval {
            Object o {
                - b 7
                - a $b
            }
        }

        set object [ $language set object ]
 
        my assertObjectTreeValues $object {
            o {
                a 5
                b 7
            }
        }
    }

    TestNamespaceObjectBuildingLanguage instproc tearDown { } {

        #add tear down code here
    }
}


