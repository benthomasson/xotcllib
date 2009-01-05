package provide xox::test::TestObjectGraph 1.0

package require XOTcl
package require xox

namespace eval ::xox::test {

    ::xotcl::Class TestObjectGraph -superclass ::xounit::TestCase

    TestObjectGraph instproc notestGetInstprocs {} {

        my assertEquals [ ::xox::ObjectGraph getInstprocs ::xotcl::Object ] [ lsort [ ::xotcl::Object info instprocs ] ]
    }

    TestObjectGraph instproc notestGetInstprocsPattern {} {

        my assertEquals [ ::xox::ObjectGraph getInstprocs ::xotcl::Object * ] [ lsort [ ::xotcl::Object info instprocs * ] ]
    }
    
    TestObjectGraph instproc notestGetInstprocsPattern2 {} {

        my assertEquals [ ::xox::ObjectGraph getInstprocs ::xotcl::Object copy ] [ lsort [ ::xotcl::Object info instprocs copy ] ]
    }

    TestObjectGraph instproc testGetInstprocsPattern3 {} {

        my assertEquals [ ::xox::ObjectGraph getInstprocs ::xotcl::Object i* ] [ lsort [ ::xotcl::Object info instprocs i* ] ]
    }

    TestObjectGraph instproc testFindAllInstances {} {

        ::xotcl::Class ::xox::test::TestFindInstances

        lappend list [ ::xox::test::TestFindInstances new ]
        lappend list [ ::xox::test::TestFindInstances new ]
        lappend list [ ::xox::test::TestFindInstances new ]
        lappend list [ ::xox::test::TestFindInstances new ]
        lappend list [ ::xox::test::TestFindInstances new ]
        lappend list [ ::xox::test::TestFindInstances new ]

        set instances [ ::xox::ObjectGraph findAllInstances ::xox::test::TestFindInstances ]

        foreach instance $list {

            my assertObjectInList $instances $instance
        }
    }

    TestObjectGraph instproc testFindFirstComment {} {

        set o [ Object new ]

        set comment [ ::xox::ObjectGraph findFirstComment $o . ]
        my assertNotEquals $comment ""
    }

    TestObjectGraph instproc testHasSuperclass {} {

        my assert [ ::xox::ObjectGraph hasSuperclass ::xotcl::Class ::xotcl::Object ]
        my assert [ ::xox::ObjectGraph hasSuperclass ::xox::Node ::xotcl::Object ]
        my assert [ ::xox::ObjectGraph hasSuperclass ::xounit::TestCase ::xotcl::Object ]
        my assert [ ::xox::ObjectGraph hasSuperclass ::xounit::TestCase ::xounit::Test ]
    }
    
    TestObjectGraph instproc testInstanceOf {} {

        my assertFalse [ ::xox::ObjectGraph instanceof notAObject ::xotcl::Object ] 1
        my assert [ ::xox::ObjectGraph instanceof [ Object new ] ::xotcl::Object ] 2
        my assert [ ::xox::ObjectGraph instanceof [ self ] ::xotcl::Object ] 3
        my assert [ ::xox::ObjectGraph instanceof [ self ] ::xounit::TestCase ] 4
        my assert [ ::xox::ObjectGraph instanceof [ self ] ::xox::test::TestObjectGraph ] 5
    }

    TestObjectGraph instproc testFindAllMethods { } {

        my assertSetEquals [ ::xox::ObjectGraph findAllMethods [ ::xotcl::Object new ] ] "@doc"
        my assertSetEquals [ ::xox::ObjectGraph findAllMethods [ ::xox::Node new ] ] \
{nodeName dumpTreeData parentNode nodeNameFromClass createAutoNamedChildInternal copyNewNode addNodeNoConfigureNode setParentNode createChildInternal createAutoNamedChild copyNodeInternal getNodeName createChild dumpData configureNode nextName nextChildNodeOrder nodeOrder copyNode fixedName addAutoNameNode nodes createNewChild hasNode treeView getAllSubNodes getChild findRoot childName cleanUpNode getNode addAutoNameNodeNoConfigureNode addNode @doc path /} 
    }

    TestObjectGraph instproc testCopyObjectVariables1 { } {

        set o [ Object new -set a 5 ]
        set p [ Object new ]

        ::xox::ObjectGraph copyObjectVariables $o $p 

        my assertEquals [ $o set a ] 5
        my assertEquals [ $p set a ] 5
    }

    TestObjectGraph instproc testCopyObjectVariables2 { } {

        set o [ Object new -set a(1) 5 ]
        set p [ Object new ]

        ::xox::ObjectGraph copyObjectVariables $o $p 

        my assertEquals [ $o set a(1) ] 5
        my assertEquals [ $p set a(1) ] 5
    }

    TestObjectGraph instproc testCopyObjectVariables3 { } {

        set o [ Object new -set a(1) 5 -set b 4 ]
        set p [ Object new ]

        ::xox::ObjectGraph copyObjectVariables $o $p 

        my assertEquals [ $o set b ] 4
        my assertEquals [ $p set b ] 4

        my assertEquals [ $o set a(1) ] 5
        my assertEquals [ $p set a(1) ] 5
    }

    TestObjectGraph instproc testCopyObjectVariables4 { } {

        set o [ Object new -set a(1) 5 -set b 4 ]
        set p [ Object new ]

        ::xox::ObjectGraph copyObjectVariables $o $p {b c d e}

        my assertEquals [ $o set b ] 4
        my assertFalse [ $p exists b ] 4

        my assertEquals [ $o set a(1) ] 5
        my assertEquals [ $p set a(1) ] 5
    }

    TestObjectGraph instproc testCopyObjectVariables5 { } {

        set o [ Object new -set a(1) 5 -set b 4 ]
        set p [ Object new ]

        ::xox::ObjectGraph copyObjectVariables $o $p {a b c d e}

        my assertEquals [ $o set b ] 4
        my assertFalse [ $p exists b ] 

        my assertEquals [ $o set a(1) ] 5
        my assertFalse [ $p array exists a ] 
        my assertFalse [ $p exists a ] 
    }

    TestObjectGraph instproc testCopyObjectVariables6 { } {

        set o [ Object new -set a 5 ]
        set p [ Object new -set a 4 ]

        my assertEquals [ $o set a ] 5 1 
        my assertEquals [ $p set a ] 4 2

        ::xox::ObjectGraph copyObjectVariables $o $p 

        my assertEquals [ $o set a ] 5 3 
        my assertEquals [ $p set a ] 5 4
    }

    TestObjectGraph instproc testCopyObjectVariables7 { } {

        set o [ Object new -set a 5 ]
        set p [ Object new -set a(1) 4 ]

        my assertEquals [ $o set a ] 5 1 
        my assertEquals [ $p set a(1) ] 4 2

        ::xox::ObjectGraph copyObjectVariables $o $p 

        my assertEquals [ $o set a ] 5 3 
        my assertEquals [ $p set a ] 5 4
    }

    TestObjectGraph instproc testCopyObjectVariables8 { } {

        set o [ Object new -set a(1) 5 ]
        set p [ Object new -set a 4 ]

        my assertEquals [ $o set a(1) ] 5 1 
        my assertEquals [ $p set a ] 4 2

        ::xox::ObjectGraph copyObjectVariables $o $p 

        my assertEquals [ $o set a(1) ] 5 3 
        my assertEquals [ $p set a(1) ] 5 4
    }

    TestObjectGraph instproc testCopyScopeVariables { } {

        set object [ Object new ]

        set a 5
        set b 6
        set c 7

        ::xox::ObjectGraph copyScopeVariables $object

        my assertSetEquals [ $object info vars ] {a b c object}
        my assertEquals [ $object set object ] $object
    }

    TestObjectGraph instproc testCopyObjectVariablesToScope { } {

        set object [ Object new ]

        $object set a 5
        $object set b 6
        $object set c 7

        ::xox::ObjectGraph copyObjectVariablesToScope $object

        my assertSetEquals [ $object info vars ] {a b c}
        my assertSetEquals [ info vars ] {a b c object}
        my assertEquals [ set a ] 5
        my assertEquals [ set b ] 6
        my assertEquals [ set c ] 7
    }
}

