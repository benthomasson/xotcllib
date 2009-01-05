

namespace eval ::xox::test {

     namespace import -force ::xotcl::*

     Class TestNode -superclass ::xounit::TestCase

     TestNode instproc testName {} {

         set fe [ ::xox::Node new ]
         my assertEquals [ $fe getNodeName ] Node
         my assertFalse [ $fe exists name ]
         my assertError { $fe name }
     }

     TestNode instproc testName2 {} {

         set root [ ::xox::Node new ]
         my assertError { $root name } 1
         set sub [ $root addNode [ ::xox::Node new ] ] 
         set sub [ $sub addNode [ ::xox::Node new ] ] 
         set sub [ $sub addNode [ ::xox::Node new ] ] 
         set sub [ $sub addNode [ ::xox::Node new ] ] 
         set sub [ $sub addNode [ ::xox::Node new ] ] 
         my assertError { $sub name } 2
         set subRoot [ $root findRoot ]
         my assertError { $subRoot name } 3
         my assertEquals $root $subRoot 4
         set subRoot [ $sub findRoot ]
         my assertEquals $root $subRoot 5
     }

     TestNode instproc testHasNode {} {

         set fe [ ::xox::Node new ]
         $fe addNode [ ::xox::Node new ]
         my assert [ $fe hasNode Node ]
         $fe Node
     }

     TestNode instproc testGetNode {} {

         set fe [ ::xox::Node new ]
         set sub [ ::xox::Node new ]
         set sub [ $fe addNode $sub ]
         my assert [ $fe hasNode Node ]
         $fe Node

         my assertEquals $sub [ $fe getNode Node ]
     }

     TestNode instproc testGetNode2 {} {

         set fe [ ::xox::Node new ]
         set sub [ ::xox::Node new ]
         set sub [ $fe addNode $sub ]
         my assert [ $fe hasNode Node ]
         $fe Node

         my assertEquals $sub [ $fe getNode Node ]
     }

     TestNode instproc testNextName {} {

         set fe [ ::xox::Node new -nodeName Node ]
         set sfe0 [ ::xox::Node new -nodeName Node ]
         set sfe1 [ ::xox::Node new -nodeName Node_0 ]
         set number [ ::xox::Node new -nodeName Node9 ]
         set sfe0 [ $fe addNode $sfe0 ]
         my assertEquals [ $fe getNodeName ] Node 1
         my assertEquals [ $sfe0 getNodeName ] Node 2
         my assertEquals [ $sfe1 getNodeName ] Node_0 3
         my assertEquals [ $number getNodeName ] Node9 4

         my assertError { $fe name }
         my assertError { $sfe0 name }
         my assertError { $sfe1 name }
         my assertError { $number name }

         my assertEquals [ $fe nextName Node ] "Node1"
         set sfe1 [ $fe addNode $sfe1 ]
         my assertEquals [ $fe nextName Node ] "Node2"
         set number [ $fe addNode $number ]
         my assertEquals [ $fe nextName Node ] "Node3"
     }

     TestNode instproc testAutoNaming {} {

         set fe [ ::xox::Node new -nodeName Node ]
         set sfe0 [ ::xox::Node new -nodeName Node ]
         set sfe1 [ ::xox::Node new -nodeName Node ]
         set sfe2 [ ::xox::Node new -nodeName Node ]
         my assertEquals [ $fe getNodeName ] Node
         my assertEquals [ $sfe0 getNodeName ] Node
         my assertEquals [ $sfe1 getNodeName ] Node
         my assertEquals [ $sfe2 getNodeName ] Node

         set sfe0 [ $fe addAutoNameNode $sfe0 ]
         set sfe1 [ $fe addAutoNameNode $sfe1 ]
         set sfe2 [ $fe addAutoNameNode $sfe2 ]

         my assertEquals [ $fe getNodeName ] Node
         my assertEquals [ $sfe0 getNodeName ] Node
         my assertEquals [ $sfe1 getNodeName ] Node1
         my assertEquals [ $sfe2 getNodeName ] Node2

         $fe Node
         $fe Node1
         $fe Node2

         my assertEquals $sfe0 [ $fe getNode Node ]
         my assertEquals $sfe1 [ $fe getNode Node1 ]
         my assertEquals $sfe2 [ $fe getNode Node2 ]
     }

     TestNode instproc testAddNode {} {

         set fe [ ::xox::Node new -nodeName Node0 ]
         set sfe0 [ ::xox::Node new -nodeName Node1 ]
         set sfe1 [ ::xox::Node new -nodeName Node2 ]
         set sfe2 [ ::xox::Node new -nodeName Node3 ]

         my assertEquals [ $fe getNodeName ] Node0
         my assertEquals [ $sfe0 getNodeName ] Node1
         my assertEquals [ $sfe1 getNodeName ] Node2
         my assertEquals [ $sfe2 getNodeName ] Node3

         set sfe0 [ $fe addNode $sfe0 ]
         set sfe1 [ $fe addNode $sfe1 ]
         set sfe2 [ $fe addNode $sfe2 ]

         my assertEquals [ $fe getNodeName ] Node0
         my assertEquals [ $sfe0 getNodeName ] Node1
         my assertEquals [ $sfe1 getNodeName ] Node2
         my assertEquals [ $sfe2 getNodeName ] Node3

         $fe Node1
         $fe Node2
         $fe Node3

         my assertEquals [ $fe getNode Node1 ] $sfe0
         my assertEquals [ $fe getNode Node2 ] $sfe1
         my assertEquals [ $fe getNode Node3 ] $sfe2
     }

     TestNode instproc notestRemoveNode {} {

         set fe [ ::xox::Node new ]
         set sfe0 [ ::xox::Node new ]
         set sfe1 [ ::xox::Node new ]

         $fe addNode $sfe0

         $fe Node
         $fe getNode Node

         my assert [ $sfe0 exists parentNode ] "No parent element"
         my assertEquals [ $sfe0 parentNode ] $fe 2
         my assertEquals [ $fe Node ] $sfe0 3

         $fe removeNode $sfe0

         my assertFalse [ $sfe0 exists parentNode ] 4
         ::xoexception::try {
             my assertEquals [ $fe Node ] "" 5
         } catch { onlyerror result } { }
     }

     TestNode instproc testSlash {} {

         set fe [ ::xox::Node new -nodeName Node0 ]
         set sfe0 [ ::xox::Node new -nodeName Node1 ]
         set sfe1 [ ::xox::Node new -nodeName Node2 ]
         set sfe2 [ ::xox::Node new -nodeName Node3 ]
         set sfe3 [ ::xox::Node new -nodeName Node4 ]

         set sfe0 [ $fe addNode $sfe0 ]
         set sfe1 [ $fe addNode $sfe1 ]
         set sfe2 [ $fe addNode $sfe2 ]
         set sfe3 [ $fe addNode $sfe3 ]

         my assertEquals [ $fe Node1 ] $sfe0
         my assertEquals [ $fe Node2 ] $sfe1
         my assertEquals [ $fe Node3 ] $sfe2
         my assertEquals [ $fe Node4 ] $sfe3
     }

     TestNode instproc testSlashLevels {} {

         set fe [ ::xox::Node new ]
         set sfe0 [ ::xox::Node new ]
         set sfe1 [ ::xox::Node new ]
         set sfe2 [ ::xox::Node new ]
         set sfe3 [ ::xox::Node new ]

         set sfe0 [ $fe addNode $sfe0 ]
         set sfe1 [ $sfe0 addNode $sfe1 ]
         set sfe2 [ $sfe1 addNode $sfe2 ]
         set sfe3 [ $sfe2 addNode $sfe3 ]

         my assertEquals [ $fe Node ] $sfe0 1
         my assertEquals [ $fe Node Node ] $sfe1 2
         my assertEquals [ $fe Node Node Node] $sfe2 3
         my assertEquals [ $fe Node Node Node Node ] $sfe3 4
     }

     TestNode instproc testGetAllSubNodes {} {

         set root [ ::xox::Node new ]
         set sub [ ::xox::Node new ]
         set subsub [ ::xox::Node new ]

         $root getAllSubNodes
     }
     
     TestNode instproc testCreateNamespace {} {

         set root [ ::xox::Node create ::testNode ]

         my assertEquals $root ::testNode 1

         set ::testNode::a 1
         my assertEquals [ $root set a ] 1 
         my assertEquals [ subst $${root}::a ] 1 
         my assertEquals [ set ${root}::a ] 1 
         my assertEquals $::testNode::a 1 

         ::testNode destroy
     }
     
     TestNode instproc testNewNamespace {} {

         set root [ ::xox::Node new ]

         set ${root}::a 1
         my assertEquals [ $root set a ] 1 
         my assertError {  my assertEquals [ subst $${root}::a ] 1  } "This seems to not be valid"
         my assertEquals [ set ${root}::a ] 1 
     }
     
     TestNode instproc testSubNodes {} {

         set root [ ::xox::Node create ::testNode ]
         set child [ ::xox::Node create ::testNode::subNode ]

         my assertEquals $root ::testNode
         my assertEquals $child ::testNode::subNode
         my assertEquals [ $root info children ] $child

         set ::testNode::subNode::a 1
         my assertEquals [ $child set a ] 1 
         my assertEquals [ set ${root}::subNode::a ] 1 
         my assertEquals [ set ${child}::a ] 1 
     }
     
     TestNode instproc testMove1 {} {

         set root [ ::xox::Node create ::testNode ]
         set child [ ::xox::Node new ]
         my assertEquals [ $root info children ] ""

         $child move ::testNode::subNode
         my assertFalse [ Object isobject $child ]
         set child ::testNode::subNode
         my assertObject $child
         my assertEquals [ $root info children ] $child

         my assertEquals $root ::testNode
         my assertEquals $child ::testNode::subNode

         set ::testNode::subNode::a 1
         my assertEquals [ $child set a ] 1 
         my assertEquals [ set ${root}::subNode::a ] 1 
         my assertEquals [ set ${child}::a ] 1 
     }

     TestNode instproc testMove2 {} {

         #Move will not work for using xotcl composition because
         #the object reference is changed.

         #The only option left is to create the objects under a parent.

         set parent [ ::xox::Node new ]
         set child [ ::xox::Node new ]

         my assertObject $parent
         my assertObject $child

         $child move ${parent}::child

         my assertObject $parent
         #Old object reference is useless, perhaps this old reference could
         #be a proxy object, a reference object. Thats too complex.
         my assertFailure { my assertObject $child }

         set newChild [ $parent info children ]

         my assertObject $newChild
     }

     TestNode instproc testNewChildOf {} {

         set parent [ ::xox::Node new ]
         set child [ ::xox::Node new -childof $parent ]

         set newChild [ $parent info children ]
         my assertObject $newChild
     }

     TestNode instproc testCreateChildOf {} {

         set parent [ ::xox::Node new ]
         set child [ ::xox::Node create ${parent}::a ]

         set newChild [ $parent info children ]
         my assertObject $newChild
     }

     TestNode instproc testChildFactory {} {

         set parent [ ::xox::Node new ]

         set child [ $parent createChild child ::xox::Node ]

         my assertObject $child
         my assertEquals [ $child info class ] ::xox::Node

         my assertEquals $child ${parent}::child
         my assertEquals [ $child getNodeName ] child

         $parent child
     }

     TestNode instproc testChildFactoryArgs {} {

         set parent [ ::xox::Node new ]

         set child [ $parent createChild child ::xox::Node \
                    -set a 5 \
                    -set b 6 ]

         my assertObject $child
         my assertEquals [ $child info class ] ::xox::Node

         my assertEquals $child ${parent}::child
         my assertEquals [ $child getNodeName ] child
         my assertEquals [ $child set a ] 5
         my assertEquals [ $child set b ] 6
     }

     TestNode instproc testChildFactoryFail {} {

         set parent [ ::xox::Node new ]

         set child [ $parent createChild child ::xox::Node ]

         my assertError { $parent createChild child }
     }

     TestNode instproc testChildNameWithSpace {} {

         set parent [ ::xox::Node new ]

         set child [ $parent createChild "start end" ::xox::Node ]

         my assertEquals $child "${parent}::start_end"
     }

     TestNode instproc testAutoName { } {

         set o [ Object new ]

         my assertEquals [ $o autoname a ] a1
         my assertEquals [ $o autoname a ] a2
         my assertEquals [ $o autoname a ] a3
         my assertEquals [ $o autoname a ] a4
     }

     TestNode instproc testCreateAutoNamedChild { } {

         Class ::xox::test::XXXTestAutoName -superclass ::xox::Node 

         set root [ ::xox::Node new ]

         set child [ $root createAutoNamedChild ::xox::test::XXXTestAutoName ]
         my assertEquals $child ${root}::XXXTestAutoName

         $root XXXTestAutoName

         set child [ $root createAutoNamedChild ::xox::test::XXXTestAutoName ]
         my assertEquals $child ${root}::XXXTestAutoName1

         $root XXXTestAutoName1

         set child [ $root createAutoNamedChild ::xox::test::XXXTestAutoName ]
         my assertEquals $child ${root}::XXXTestAutoName2

         $root XXXTestAutoName2

         set root2 [ ::xox::Node new ]

         set child [ $root2 createAutoNamedChild ::xox::test::XXXTestAutoName ]
         my assertEquals $child ${root2}::XXXTestAutoName

         $root2 XXXTestAutoName

         set child [ $root2 createAutoNamedChild ::xox::test::XXXTestAutoName ]
         my assertEquals $child ${root2}::XXXTestAutoName1

         $root2 XXXTestAutoName1

         set child [ $root2 createAutoNamedChild ::xox::test::XXXTestAutoName ]
         my assertEquals $child ${root2}::XXXTestAutoName2

         $root2 XXXTestAutoName2
     }


     TestNode instproc testXOTclCompatibleChildren {} {

         set parent [ ::xox::Node new ]

         set child [ $parent createChild child ::xox::Node ]

         my assertObject $child
         my assertEquals [ $child info class ] ::xox::Node

         my assertEquals $child ${parent}::child
         my assertEquals [ $child getNodeName ] child

         $parent child
     }

     TestNode instproc testMove3 { } {

         catch { ::xox::test::a destroy }
         catch { ::xox::test::b destroy }

         #Rethinking the xotcl move 

         set node [ ::xox::Node create ::xox::test::a ]
         set newNode ::xox::test::b

         $node set a 5

         my assertObject $node
         my assertFailure { my assertObject $newNode }
         my assertEquals [ $node set a ] 5

         $node move $newNode

         my assertFailure { my assertObject $node }
         my assertObject $newNode
         my assertEquals [ $newNode set a ] 5
     }

     TestNode instproc testMove4 { } {

         catch { ::xox::test::a destroy }
         catch { ::xox::test::b destroy }

         #Rethinking the xotcl move 

         set node [ ::xox::Node create ::xox::test::a ]
         ::xox::Node create ::xox::test::a::sub
         set newNode ::xox::test::b

         $node set a 5

         my assertObject $node
         my assertFailure { my assertObject $newNode }
         my assertEquals [ $node set a ] 5

         $node move $newNode

         my assertFailure { my assertObject $node }
         my assertFailure { my assertObject ${node}::sub }
         my assertObject $newNode
         my assertEquals [ $newNode set a ] 5
         my assertObject ${newNode}::sub
     }

     TestNode instproc testCreateNewChild {} {

         set node [ ::xox::Node new ]

         set child [ $node createNewChild ::xox::Node ]

         my assertEquals [ $node nodes ] $child

         my assertEquals [ $node childName Node ] $child
         my assertEquals [ $node getChild Node ] $child
         my assertEquals [ $node getChild NotANode ] ""
     }

     TestNode instproc testConfigureNode {} {

         set node [ ::xox::Node new ]

         $node configureNode
     }

     TestNode instproc testPath {} {

         set node [ ::xox::Node create ::xox::test::node ]

         my assertEquals [ $node path ] $node 0

         set one [ ::xox::Node create ${node}::one ]
         set two [ ::xox::Node create ${node}::one::two ]
         set three [ ::xox::Node create ${node}::one::two::three ]

         my assertEquals [ $one path ] "$node one" 1
         my assertEquals [ $two path ] "$node one two" 2
         my assertEquals [ $three path ] "$node one two three" 3

         my assertEquals [ eval [ $node path ] ] $node
         my assertEquals [ eval [ $one path ] ] $one
         my assertEquals [ eval [ $two path ] ] $two
         my assertEquals [ eval [ $three path ] ] $three
     }

     TestNode instproc testOrderCreateChild { } {

         set parent [ ::xox::Node create ::xox::test::node ]

         set a [ $parent createNewChild ::xox::Node ]
         set b [ $parent createNewChild ::xox::Node ]
         set c [ $parent createNewChild ::xox::Node ]
         set d [ $parent createNewChild ::xox::Node ]
         set e [ $parent createNewChild ::xox::Node ]
         set f [ $parent createNewChild ::xox::Node ]
         set g [ $parent createNewChild ::xox::Node ]
         set h [ $parent createNewChild ::xox::Node ]

         my assertEquals [ ::xox::Node compareOrder $a $b ] -1
         my assertEquals [ ::xox::Node compareOrder $b $a ] 1
         my assertEquals [ ::xox::Node compareOrder $a $a ] 0

         my assertEquals [ $parent nodeOrder ] 0
         my assertEquals [ $a nodeOrder ] 1
         my assertEquals [ $b nodeOrder ] 2
         my assertEquals [ $c nodeOrder ] 3
         my assertEquals [ $d nodeOrder ] 4
         my assertEquals [ $e nodeOrder ] 5
         my assertEquals [ $f nodeOrder ] 6
         my assertEquals [ $g nodeOrder ] 7
         my assertEquals [ $h nodeOrder ] 8

         my assertEquals [ lindex [ $parent nodes ] 0 ] $a
         my assertEquals [ lindex [ $parent nodes ] 1 ] $b
         my assertEquals [ lindex [ $parent nodes ] 2 ] $c
         my assertEquals [ lindex [ $parent nodes ] 3 ] $d
         my assertEquals [ lindex [ $parent nodes ] 4 ] $e
         my assertEquals [ lindex [ $parent nodes ] 5 ] $f
         my assertEquals [ lindex [ $parent nodes ] 6 ] $g
         my assertEquals [ lindex [ $parent nodes ] 7 ] $h
     }
     TestNode instproc testOrderCreateChild { } {

         set parent [ ::xox::Node create ::xox::test::node ]

         set a [ ::xox::Node new ]

         my assertEquals [ $parent nodeOrder ] 0
         my assertEquals [ $parent nextChildNodeOrder ] 0
         my assertEquals [ $a nodeOrder ] 0

         set a [ $parent addNode $a ]

         my assertEquals [ $parent nodeOrder ] 0
         my assertEquals [ $parent nextChildNodeOrder ] 1
         my assertEquals [ $a nodeOrder ] 1
     }
}

package provide xox::test::TestNode 1.0

