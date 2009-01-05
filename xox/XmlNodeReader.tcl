

namespace eval xox {

   ::xotcl::Class XmlNodeReader -superclass ::xox::XmlReader

   XmlNodeReader # XmlNodeReader {

       XmlNodeReader is a library of methods that will convert
       specially built XML into a tree of ::xox::Node objects.
       The schema for the XML is defined by the operations of
       the ::xox::XmlNodeWriter class.  Thus XML written by
       ::xox::XmlNodeWriter from a ::xox::Node tree can be
       read back into a ::xox::Node tree using this class.


       The primary methods in this class are buildTree and buildNodes.
   }

   XmlNodeReader # rootNode { ACCESSOR, The rootNode to build the ::xox::Node tree upon. }
   XmlNodeReader # externalRootNodes { OPTIONAL, Other root nodes that may be found in the XML }

   XmlNodeReader parameter {
       { callInit 0 }
       rootNode
       externalRootNodes
   }

   XmlNodeReader instproc buildNewTree { xml } {

       package require tdom

       set document [dom parse $xml]
       set root     [$document documentElement]

       if [ $root hasAttribute package ] {

           package require [ $root getAttribute package ]
       }

       set class [ my getClassFromTag [ $root nodeName ] ]

       set rootNode [ $class new ]

       my rootNode $rootNode

       #puts $xml

       my buildNodesFromTdom $rootNode $root

       if [ my callInit ] {

           $rootNode init
       }

       $rootNode configureNode

       #my debug [ $rootNode dumpTreeData ]

       return $rootNode
   }

   XmlNodeReader # buildTree {

       Adds a tree of ::xox::Nodes to rootNode from set of tree files that
       are the format created by ::xox::XmlNodeWriter.

       Arguments:

       rootNode - The rootNode to add the tree of nodes created from on
           of the tree files in treeFiles. This node must have the same name
           as the root node written to the tree files.

       treeFiles - A list of files to read in and convert to ::xox::Node instances.
   }

   XmlNodeReader instproc buildTree { rootNode treeFiles } {

       package require tdom

        foreach treeFile $treeFiles {

            if [ catch {

            set xml [ read [ open $treeFile ] ]
            my buildNodes $rootNode $xml

            } result ] {

                global errorInfo

                error "XmlNodeReader buildTree $treeFile\n$errorInfo"
            }
        }

        return $rootNode
    }

   XmlNodeReader # buildNodes {

       Build a tree of ::xox::Nodes and add them to the node, rootNode, from the
       given xml.

       Arguments:

       rootNode - The root node to add the tree of Nodes to.
       xml - The XML that will be converted to the tree of Nodes.
   }

   XmlNodeReader instproc buildNodes { rootNode xml } {

       package require tdom

       my rootNode $rootNode

       set document [dom parse $xml]
       set root     [$document documentElement]

       if [ $root hasAttribute package ] {

           package require [ $root getAttribute package ]
       }

       #puts $xml

       my buildNodesFromTdom $rootNode $root

       if [ my callInit ] {

           $rootNode init
       }

       $rootNode configureNode

       #my debug [ $rootNode dumpTreeData ]
   }

   XmlNodeReader # buildNode {

       Recurisvley build a subtree of ::xox::Nodes from a corresponding DOM subtree.

       Arguments:

       parentNode - The parent ::xox::Node to add the new ::xox::Node subtree to.
       subTdomNode - The DOM subtree that holds the information for the new subtree of Nodes.
   }

   XmlNodeReader instproc buildNode { parentNode subTdomNode } {

       set class [ my getClassFromTag [ $subTdomNode nodeName ] ]

       #my debug $class

       set childName ""

       foreach subSubNode [ $subTdomNode childNodes ] {

           set name [ $subSubNode nodeName ]
           if [ my isclassAndLoad $name ] { continue }
           set value ""
           catch { set value [ my extractValue $subSubNode ] }
           set childParameters($name) $value
           
           if { "$name" == "nodeName" } { 
               set childName $value
           }
       }

       if { ""  == "$childName" } {

           set node [ $parentNode createAutoNamedChild $class -noinit ]
           my buildNodesFromTdom $node $subTdomNode

       } elseif [ $parentNode hasNode $childName ] {

           set node [ $parentNode getNode $childName ]
           my buildNodesFromTdom $node $subTdomNode

       } else {

           set node [ $parentNode createChild $childName $class -noinit ]
           my buildNodesFromTdom $node $subTdomNode
       }

       if [ my callInit ] {

           $node init
       }

       $node configureNode
   }

   XmlNodeReader # addMixin {

       Adds a mixin given in the value of subTdomNode to parentNode.

       Arguments:

       parentNode - the ::xox::Node instance to add the mixin to.
       subTdomNode - the subTdomNode that holds the class name of the mixin
   }

   XmlNodeReader instproc addMixin { parentNode subTdomNode } {

       set mixin [ my extractValue $subTdomNode ]
       $parentNode mixin add $mixin
   }

   XmlNodeReader # setArrayIndexValue {

       Sets the value of the array variable given as the name of the subTdomNode
       on the parentNode.
   }

   XmlNodeReader instproc setArrayIndexValue { parentNode valueNode name index } {

       #my debug "$parentNode $valueNode $name $index"

       set value [ my extractValue $valueNode ]
       set variableName "${name}\($index\)"
       if [ $valueNode hasAttribute type ] {
           set type [ $valueNode getAttribute type ]
           switch $type {
               default { error "Unsupported type $type" }
           }
           return

       } else {
           
           #my debug "$parentNode set $variableName $value"
           $parentNode set $variableName $value
       }
   }

   XmlNodeReader # setArrayValue {

       Sets the value of the array variable given as the name of the subTdomNode
       on the parentNode.
   }

   XmlNodeReader instproc setArrayValue { parentNode subTdomNode } {

       set name [ $subTdomNode nodeName ]

       if {[expr {[llength [$subTdomNode childNodes]] % 2}] != 0} {
          error "Uneven key value pairs found in array [$parentNode nodeName]"
       }

       foreach {indexNode valueNode} [$subTdomNode childNodes] {
          if {[$indexNode nodeName] == "index" && \
              [$valueNode nodeName] == "value" } {

              set index [ my extractValue $indexNode ]
              my setArrayIndexValue $parentNode $valueNode $name $index
              
          } else {
              error "Unsupported tag found in array [$parentNode nodeName]"
          }
       }
   }

   XmlNodeReader # setListValue {

       Sets the value of the list variable given as the name of the subTdomNode
       on the parentNode.
   }

   XmlNodeReader instproc setListValue { parentNode subTdomNode } {

       set name [ $subTdomNode nodeName ]
       $parentNode set $name {}

       foreach child [$subTdomNode childNodes] {
           if {[$child nodeName] == "value"} {
               $parentNode lappend $name [my extractValue $child]
           } else {
               error "Unsupported tag [$child nodeName] found in list [$parentNode nodeName]"
           }
       }
   }

   XmlNodeReader # setKeyValue {

       Sets the value of the array variable given as the name of the subTdomNode
       on the parentNode.
   }

   XmlNodeReader instproc setKeyValue { parentNode subTdomNode } {

       set name [ $subTdomNode nodeName ]

       foreach childNode [$subTdomNode childNodes] {
           if {[$childNode nodeName] == "value" && [$childNode hasAttribute key]} {
               set index [$childNode getAttribute key]
               my setArrayIndexValue $parentNode $childNode $name $index
           } else {
               error "Unsupported tag or attribute found in keyvalue [$parentNode nodeName]"
           }
       }
   }

   XmlNodeReader # setXmlValue {

       Sets the value of the array variable given as the name of the subTdomNode
       on the parentNode.
   }

   XmlNodeReader instproc setXmlValue { parentNode subTdomNode } {

       set reader [ ::xox::XmlObjectReader new ]

       $parentNode set [ $subTdomNode nodeName ] [ $reader buildNewTreeFromNode $subTdomNode ]
   }


   XmlNodeReader # setValues {

       Sets the value of the variable given as the name of the subTdomNode
       on the parentNode.
   }

   XmlNodeReader instproc setValues { parentNode subTdomNode } {

       set name [ $subTdomNode nodeName ]

       #my debug "name: $name"
       #my debug "[ $subTdomNode asXML ]"

       if { [ $subTdomNode nodeType ] == "COMMENT_NODE" } { return }

       if [ $subTdomNode hasAttribute type ] {

           set variableName $name 

           set type [ $subTdomNode getAttribute type ]
           #my debug "type: $type"
           switch $type {

               mixin { my addMixin $parentNode $subTdomNode }
               array { my setArrayValue $parentNode $subTdomNode }
               list { my setListValue $parentNode $subTdomNode }
               keyvalue { my setKeyValue $parentNode $subTdomNode }
               xml { my setXmlValue $parentNode $subTdomNode }
               default { error "[ my info class ] Unsupported type $type" }
           }

           return
       }

       my setNodeValue $parentNode $subTdomNode $name
   }

   XmlNodeReader # buildNodesFromTdom {

       Builds the subnodes of the tdomNode into ::xox::Nodes.

       If the name of the subnode is a class name then it will
       create a new object from that class name otherwise it
       If the name of the subnode is not a class name then it
       assumes the name is a variable.  The value of the variable
       is extracted from the subnode and set on the parentNode
   }

   XmlNodeReader instproc buildNodesFromTdom { parentNode tdomNode } {

       set subTdomNodes [ $tdomNode childNodes ]
       set parameterList ""

       foreach subTdomNode $subTdomNodes {

           #my debug "node: [ $subTdomNode nodeName ]"

           set classOrParameter [ $subTdomNode nodeName ]

           if { ![ my isclassAndLoad $classOrParameter ] } {

               my setValues $parentNode $subTdomNode

           } else { 

               my buildNode $parentNode $subTdomNode 
           }
       }
   }

   XmlNodeReader # setNodeValue {

       Sets the value of the variable, variableName, on node to the
       value found in the DOM node, tdomNode.

       Arguments:

       node - The ::xox::Node instance to set value of variableName on.
       tdomNode - The DOM node to extract the value of variableName from.
       variableName - The variable name to set the value on node.
   }

   XmlNodeReader instproc setNodeValue { node tdomNode variableName } {

       set value [ my extractValue $tdomNode ]
       $node set $variableName $value
   }

   XmlNodeReader instproc isclassAndLoad { name } {

        set name [ my getClassFromTag $name ]

        #my debug "name: $name"

        if [ Object isclass $name ] {

            return 1
        }

        set current [ ::xox::Package getPackageFromClass $name ]

        #my debug "current: $current"

        while { "" != "$current" } {

            catch { package require $current }

            if [ Object isclass $name ] { 

                return 1
            }

            set current [ ::xox::Package getPackageFromClass $current ]
        }

        return 0
   }

   XmlNodeReader instproc getClassFromTag { tag } {

       set class ""

       set pieces [ split $tag : ]

       set pieces [ ::xox::removeIf {

           expr { "" == "$piece" }

       } piece $pieces ]

       return "::[ join $pieces :: ]"
   }
}


