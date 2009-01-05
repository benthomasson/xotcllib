
namespace eval ::xox {

   namespace import -force ::xotcl::*

   Class Node 

   Node # create {

       Creates a new node and always creates a namespace for that node.
   }

   Node proc create { args } {

       set created [ next ]
       $created requireNamespace
       return $created
   }

   Node proc compareOrder { a b } {

      return [ expr { [ $a nodeOrder ] - [ $b nodeOrder ] } ]
   }

   Node parameter {
       nodeName
       { nodeOrder 0 }
       { nextChildNodeOrder 0 }
   }

   Node instproc getNodeName { } {

       my instvar nodeName

       if [ my exists nodeName ] {

           return $nodeName
       }

       my nodeNameFromClass 
   }


   Node instproc parentNode { } {

       return [ my info parent ]
   }

   Node # Node {

       Nodes are arranged in a tree structure
   }

   Node # nodeNameFromClass {

       Create a nodeName from the nodes's class.  
       This is used if the nodeName is not yet set.
   }

   Node instproc nodeNameFromClass { } {

        if { ![ my exists nodeName ] } {
            return [ namespace tail [ my info class ] ]
        }
        return [ my nodeName ]
   }

   Node # / {

       Slash method is a recursive method that is used
       to traverse the Node tree.

       Example:

       set node [ ::xox::Node new ]
       $node addNode [ ::xox::Node new ]

       set subNode [ $node / Node ]

       Slash uses the nodeNames of the nodes instead of
       the object handles.  Thus meaningful nodeNames can
       be given to the nodes.

       The slash method will throw an error if it does
       not find a node with the correct nodeName.  
   }

   Node # setParentNode {

       Sets the parent node for this node.
   }

   Node instproc setParentNode { node } {

   }

   Node instproc getChild { name } {

       set child [ my childName $name ]

       if [ Object isobject $child ] {

           return $child
       }

       return ""
   }

   Node # nodes {

       Returns a list of nodes that are children of this node.
   }

   Node instproc nodes { } {

       return [ lsort -command "::xox::Node compareOrder" [ ::xox::removeIfNot {

           $object hasclass ::xox::Node
           
       } object [ my info children ] ] ]
   }

   Node # addAutoNameNode {

       Adds a node as a child of this node and will produce
       a unique name among the children of this node.
   }

   Node instproc addAutoNameNode { node } {

       set nodeName [ $node getNodeName ]

       if { ![ Object isobject [ my childName $nodeName ] ] } {

           return [ my addNode $node ]
       }

       set nodeName [ my nextName [ $node getNodeName ] ]
       $node nodeName $nodeName

       return [ my addNode $node ]
   }

   Node instproc fixedName { name } {

       return [ regsub -all { } $name {_} ]
   }

   Node instproc childName { nodeName } {

       set nodeName [ my fixedName $nodeName ]

       return "[ self ]::${nodeName}"
   }

   Node # nextName {

       Produces the next unique nodeName among the children
       of this node.
   }

   Node instproc nextName { nodeName } {

       set autoname [ my autoname $nodeName ]
       set childName [ my childName $autoname ]

       while { [ Object isobject $childName ] } {

           set autoname [ my autoname $nodeName ]
           set childName [ my childName $autoname ]
       }

       return [ namespace tail $childName ]
   }

   Node # addNode {

       Adds a node as a child of this node.  The name of the
       node to be added must be unique among the children
       of this node.
   }

   Node instproc addNode { node } {

       set node [ my addNodeNoConfigureNode $node ]

       $node configureNode
       return $node
   }

   Node # addAutoNameNodeNoConfigureNode {

       Used internally.
   }

   Node instproc addAutoNameNodeNoConfigureNode { node } {

       set nodeName [ $node getNodeName ]

       if { ![ Object isobject [ my childName $nodeName ] ] } {

           return [ my addNodeNoConfigureNode $node ]
       }

       set nodeName [ my nextName [ $node getNodeName ] ]
       $node nodeName $nodeName

       return [ my addNodeNoConfigureNode $node ]
   }

   Node # addNodeNoConfigureNode {

       Used internally.
   }

   Node instproc addNodeNoConfigureNode { node } {

       set nodeName [ $node getNodeName ]
       set childName [ my childName $nodeName ]

       if { [ Object isobject $childName ] } {

           if { "$node" != "$childName" } {

               error "[ self ] already contains an node named $nodeName\n[my stackTrace ]"
           }
       }

       $node move $childName
       $childName nodeOrder [ my incr nextChildNodeOrder ]
       $childName setParentNode [ self ]
       $childName nodeName $nodeName

       return $childName
   }

   Node instproc copyNodeInternal { name node } {

       set childName [ my childName $name ]

       if { [ Object isobject $childName ] } {

           if { "$node" != "$childName" } {

               error "[ self ] already contains an node named $name\n[my stackTrace ]"
           }
       }

       $node copy $childName
       $childName setParentNode [ self ]
       $childName nodeName $name

       return $childName
   }

   Node instproc copyNewNode { node } {

       set name [ namespace tail [ $node info class ] ]

       set childName [ my childName $name ]

       if { ! [ Object isobject $childName ] } {

           return [ my copyNodeInternal $name $node ]
       }

       return [ my copyNodeInternal [ my nextName $name ] $node ]
   }

   Node instproc copyNode { node } {

       set nodeName [ $node getNodeName ]

       return [ my copyNodeInternal $nodeName $node ]
   }

   Node # getNode {

       Gets a child of this node that has the nodeName given.
       Returns "" if no child is found with nodeName.
   }
   
   Node instproc getNode { nodeName } {

       if { [ Object isobject [ my childName $nodeName ] ] } { 
           return [ my childName $nodeName ]
       }

       return 
   }

   Node # hasNode {

       Checks for a child with nodeName under this node.

       Returns 1 - if found.
       Returns 0 - if not found.
   }

   Node instproc hasNode { nodeName } {

       if { [ Object isobject [ my childName $nodeName ] ] } { 
           return 1
       }

       return 0
   }

   Node # configureNode {

       Allows a node to configure itself when added to the node tree.

       configureNode is called by addNode or addAutoNameNode and
       allows a node to lookup information on the tree or change
       the tree in some way.
   }

   Node instproc configureNode {} {

        #override this to configure the node when 
        #added to the node tree.
   }
   
   Node # cleanUpNode {

       Deprecated. No replacement.
   }


   Node instproc cleanUpNode {} {

   }

   Node # getAllSubNodes {

       Returns a list of all nodes that exist in the sub-tree starting
       with this node.
   }

   Node instproc getAllSubNodes {} {

       set subNodes [ my nodes ]

       foreach node [ my nodes ] {

           set subNodes [ concat $subNodes [ $node getAllSubNodes ] ]

       }

       return $subNodes
   }

   Node # findRoot {

       Finds the root of the node-tree where this node lives.
   }

   Node instproc findRoot { } {

        set current [ self ]

        while { [ Object isobject [ $current info parent ] ] } {

            set current [ $current info parent ]
        }

        return $current
   }

   Node # treeView {

       Returns a formatted string that displays
       the tree node names in this subtree.  This
       is useful for debugging the tree structure.

       See Also: ::xox::Debugging debug
   }
   
   Node instproc treeView { { tabs "" } } {

       set buffer "$tabs[ my name ]\n"
       foreach node [ my nodes ] {
           append buffer [ $node treeView "$tabs\t" ]
       }

       return $buffer
   }

   Node # dumpData {

       Returns a formatted string of all the data
       on this Node. This is used for debugging the data
       on this Node.

       See Also: ::xox::Debugging debug
   }

   Node instproc dumpData { { tabs "" } } {

       set buffer ""

       foreach var [ my info vars ] {

           if [ my array exists $var ] {

           append buffer "$tabs$var: [ my array get $var ]\n"
           } else {
           append buffer "$tabs$var: [ my set $var ]\n"
           }
       }

       return $buffer
   }

   Node # dumpTreeData {

       Returns a formatted string representation of all the data
       held in this sub tree.  This is used for debugging the
       structure and data on the sub tree.

       See Also: ::xox::Debugging debug
   }

   Node instproc dumpTreeData { { tabs "" } } {

       set buffer "\n$tabs[ self ] ([ my info class ])\n"
       append buffer [ my dumpData $tabs ] 
       foreach node [ my nodes ] {
           append buffer [ $node dumpTreeData "$tabs\t" ]
       }

       return $buffer
   }

   Node # createChild {

       Create a new object as a child of this element.
   }

   Node instproc createChild { name class args } {

       return [ my createChildInternal $name $class $args ] 
   }

   Node instproc createChildInternal { name class createArgs } {

       regsub -all { } $name {_} fixedName

       set child [ my childName $fixedName ]

       if [ Object isobject $child ] {
           
           error "$child has already been created."
       }

       #my debug "$name $class $createArgs"

       eval [ list $class create $child ] $createArgs [ list -nodeName $name -nodeOrder [ my incr nextChildNodeOrder ] ]

       $child configureNode

       return $child
   }

   Node # createNewChild {

       Better name for createAutoNamedChild
   }

   Node instproc createNewChild { class args } {

       return [ my createAutoNamedChildInternal $class $args ]
   }

   Node # createAutoNamedChild {

       Creates a new child of this node that is a new
       instance of class using initialization arguments args.
   }

   Node instproc createAutoNamedChild { class args } {

       return [ my createAutoNamedChildInternal $class $args ]
   }

   Node instproc createAutoNamedChildInternal { class createArgs } {

       #my debug $createArgs

       set name [ namespace tail $class ]

       if { ! [ Object isobject [ self ]::${name} ] } {

           return [ my createChildInternal $name $class $createArgs ]
       }

       set autoname [ my autoname $name ]

       while { [ Object isobject [ self ]::${autoname} ] } {

           set autoname [ my autoname $name ]
       }

       return [ my createChildInternal $autoname $class $createArgs ]
   }

   Node instproc path { } {

       set path ""

       set current [ self ]

       while { [ my isobject $current ] } {

           set parent [ $current info parent ]

           if [ my isobject $parent ] {

               set path [ concat [ namespace tail $current ] $path ]

           } else {

               set path [ concat $current $path ]
           }

           set current $parent
       }

       return $path
   }

   Node instproc / { args } {

       return [ eval [ self ] $args ]
   }
}

