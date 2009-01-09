
namespace eval ::xox::test {

     namespace import -force ::xotcl::*

     Class TestXmlNodeReader -superclass ::xounit::TestCase

     TestXmlNodeReader instproc setUp { } {

        my instvar writer reader

        set writer [ ::xox::XmlNodeWriter new ]
        set reader [ ::xox::XmlNodeReader new ]
     }

     TestXmlNodeReader instproc testNode {} {

        my instvar writer reader

        set element [ ::xox::Node new ]

        set xml [ $writer generateXml $element ] 

        set otherNode [ ::xox::Node new ]

        $reader buildNodes $otherNode $xml

        my assertNotEquals $element $otherNode

        my assertEquals [ $element getNodeName ] [ $otherNode getNodeName ]

        my assertEquals [ $element info class ] ::xox::Node
        my assertEquals [ $otherNode info class ] ::xox::Node
     }

     TestXmlNodeReader instproc testNodeValue {} {

        my instvar writer reader

        set element [ ::xox::Node new ]

        $element set someVariable someValue

        set xml [ $writer generateXml $element ] 
        
        set otherNode [ ::xox::Node new ]

        $reader buildNodes $otherNode $xml

        my assertEquals [ $element set someVariable ] someValue
        my assertEquals [ $otherNode set someVariable ] someValue
     }

     TestXmlNodeReader instproc testNodeArray {} {

        my instvar writer reader

        set element [ ::xox::Node new ]

        $element set someVariable(1) someValue

        set xml [ $writer generateXml $element ] 

        #my debug $xml
        
        set otherNode [ ::xox::Node new ]

        $reader buildNodes $otherNode $xml

        my assertEquals [ $element set someVariable(1) ] someValue
        my assertEquals [ $otherNode set someVariable(1) ] someValue
     }

     TestXmlNodeReader instproc testNodes {} {

        my instvar writer reader

        set element [ ::xox::Node new ]

        set subNode [ $element addNode [ ::xox::Node new ] ]

        set xml [ $writer generateXml $element ] 

        set otherNode [ ::xox::Node new ]

        $reader buildNodes $otherNode $xml

        $element Node

        $otherNode Node
     }

     TestXmlNodeReader instproc testNodeLinks {} {

        my instvar writer reader

        set element [ ::xox::Node create ::xox::test::a ]

        set subNode0 [ $element addAutoNameNode [ ::xox::Node new ] ]
        set subNode1 [ $element addAutoNameNode [ ::xox::Node new ] ]

        $subNode0 set neighbor $subNode1
        $subNode1 set neighbor $subNode0

        set xml [ $writer generateXml $element ] 

        my debug $xml

        $element destroy
        
        set otherNode [ ::xox::Node create ::xox::test::a ]

        $reader buildNodes $otherNode $xml

        $element Node
        $element Node1

        my assertEquals [ $subNode0 set neighbor ] $subNode1
        my assertEquals [ $subNode1 set neighbor ] $subNode0

        set otherSubNode0 [ $otherNode Node ]
        set otherSubNode1 [ $otherNode Node1 ]

        my assertEquals [ $otherSubNode0 set neighbor ] $otherSubNode1
        my assertEquals [ $otherSubNode1 set neighbor ] $otherSubNode0
     }

     TestXmlNodeReader instproc testNodesLinks {} {

        my instvar writer reader

        set element [ ::xox::Node create ::xox::test::a ]

        set subNode0 [ $element addAutoNameNode [ ::xox::Node new ] ]
        set subNode1 [ $element addAutoNameNode [ ::xox::Node new ] ]
        set subNode2 [ $element addAutoNameNode [ ::xox::Node new ] ]

        $subNode0 lappend neighbor $subNode1
        $subNode0 lappend neighbor $subNode2
        $subNode1 lappend neighbor $subNode0
        $subNode1 lappend neighbor $subNode2
        $subNode2 lappend neighbor $subNode0
        $subNode2 lappend neighbor $subNode1

        set xml [ $writer generateXml $element ] 

        $element destroy
        
        set otherNode [ ::xox::Node create ::xox::test::a ]

        $reader buildNodes $otherNode $xml

        $element Node
        $element Node1
        $element Node2

        my assertEquals [ $subNode0 set neighbor ] \
            [ list $subNode1 $subNode2 ]
        my assertEquals [ $subNode1 set neighbor ] \
            [ list $subNode0 $subNode2 ]
        my assertEquals [ $subNode2 set neighbor ] \
            [ list $subNode0 $subNode1 ]

        set otherSubNode0 [ $otherNode Node ]
        set otherSubNode1 [ $otherNode Node1 ]
        set otherSubNode2 [ $otherNode Node2 ]

        my assertEquals [ $otherSubNode0 set neighbor ] \
            [ list $otherSubNode1 $otherSubNode2 ]
        my assertEquals [ $otherSubNode1 set neighbor ] \
            [ list $otherSubNode0 $otherSubNode2 ]
        my assertEquals [ $otherSubNode2 set neighbor ] \
            [ list $otherSubNode0 $otherSubNode1 ]

     }

     TestXmlNodeReader instproc testNodesLinksArray {} {

        my instvar writer reader

        set element [ ::xox::Node create ::xox::test::a ]

        set subNode0 [ $element addAutoNameNode [ ::xox::Node new ] ]
        set subNode1 [ $element addAutoNameNode [ ::xox::Node new ] ]
        set subNode2 [ $element addAutoNameNode [ ::xox::Node new ] ]

        $subNode0 lappend neighbor(1) $subNode1
        $subNode0 lappend neighbor(1) $subNode2
        $subNode1 lappend neighbor(1) $subNode0
        $subNode1 lappend neighbor(1) $subNode2
        $subNode2 lappend neighbor(1) $subNode0
        $subNode2 lappend neighbor(1) $subNode1

        set xml [ $writer generateXml $element ] 

        #my debug $xml

        $element destroy
        
        set otherNode [ ::xox::Node create ::xox::test::a ]

        $reader buildNodes $otherNode $xml

        $element Node
        $element Node1
        $element Node2

        my assertEquals [ $subNode0 set neighbor(1) ] \
            [ list $subNode1 $subNode2 ] 1
        my assertEquals [ $subNode1 set neighbor(1) ] \
            [ list $subNode0 $subNode2 ] 2
        my assertEquals [ $subNode2 set neighbor(1) ] \
            [ list $subNode0 $subNode1 ] 3

        set otherSubNode0 [ $otherNode Node ]
        set otherSubNode1 [ $otherNode Node1 ]
        set otherSubNode2 [ $otherNode Node2 ]

        my assertEquals [ $otherSubNode0 set neighbor(1) ] \
            [ list $otherSubNode1 $otherSubNode2 ] 4
        my assertEquals [ $otherSubNode1 set neighbor(1) ] \
            [ list $otherSubNode0 $otherSubNode2 ] 5
        my assertEquals [ $otherSubNode2 set neighbor(1) ] \
            [ list $otherSubNode0 $otherSubNode1 ] 6

     }

     TestXmlNodeReader instproc testNodesArraySpaceBug {} {

        my instvar writer reader

        set element [ ::xox::Node new ]

        $element set "array(name with spaces)" 1

        set xml [ $writer generateXml $element ] 

        my debug $xml

        set otherNode [ ::xox::Node new ]

        $reader buildNodes $otherNode $xml

        set xml [ $writer generateXml $otherNode ] 

        #my debug $xml

        my assertNotEquals $element $otherNode

        my assertEquals [ $element getNodeName ] [ $otherNode getNodeName ]

        my assertEquals [ $element info class ] ::xox::Node
        my assertEquals [ $otherNode info class ] ::xox::Node
        my assertEquals [ $element set "array(name with spaces)" ] 1
        my assertEquals [ $otherNode set "array(name with spaces)" ] 1
     }
     
     TestXmlNodeReader instproc testNodesArrayObjectIndexBug {} {

        my instvar writer reader

        set node [ ::xox::Node create ::xox::test::a ]

        $node set "array($node)" 1

        set xml [ $writer generateXml $node ] 

        my debug $xml

        $node destroy

        set otherNode [ ::xox::Node create ::xox::test::a ]

        $reader buildNodes $otherNode $xml

        set xml [ $writer generateXml $otherNode ] 

        my debug $xml

        my assertEquals [ $node getNodeName ] [ $otherNode getNodeName ] 2

        my assertEquals [ $node info class ] ::xox::Node 3
        my assertEquals [ $otherNode info class ] ::xox::Node 4
        my assert [ $node exists array($node) ] 4.5
        my assertEquals [ $node set "array($node)" ] 1 5
        my assertFalse [ $otherNode exists "array(Node)" ] 5.45
        my assert [ $otherNode exists "array($otherNode)" ] 5.5
        my assertEquals [ $otherNode set "array($otherNode)" ] 1 6
     }

     TestXmlNodeReader instproc testNameNodeNameConfusion {} {

        my instvar writer reader

         set parent [ ::xox::Node new ]

         set nodeA [ ::xox::Node new -set name A -set nodeName A ]
         set nodeB [ ::xox::Node new -set name A -set nodeName B ]

         set nodeA [ $parent addNode $nodeA ]
         set nodeB [ $parent addNode $nodeB ]

         my assertEquals [ $nodeA set name ] A 
         my assertEquals [ $nodeB set name ] A 

         my assertEquals [ $nodeA getNodeName ] A 
         my assertEquals [ $nodeB getNodeName ] B

         $parent A
         $parent B

         set xml [ $writer generateXml $parent ] 

         set otherParent [ ::xox::Node new ]

         $reader buildNodes $otherParent $xml

         set xml [ $writer generateXml $otherParent ] 

         $otherParent A
         $otherParent B
     }

     TestXmlNodeReader instproc testMixedList {} {

         set xml {\
<testbed>
    <nodeName>ESTBBA</nodeName>
    <EnablePassword>lab</EnablePassword>
    <TacacsPassword>lab</TacacsPassword>
    <TacacsUsername>lab</TacacsUsername>
    <topomapFile>estbba-topo.xml</topomapFile>
    <webPath>http://estmpls1.cisco.com/estbba/</webPath>
    <location>/var/www/html/estbba/</location>
    <title>EST BBA Network Verification</title>
    <url>http://www.cisco.com</url>
    <includes>::xox::Interface testPingAllPeerInterfaces</includes>     
    <excludes>::xox::Interface testDescriptionExists</excludes>
    <excludes>::xox::Interface testLayer3Connected</excludes>
</testbed>}

        set factory [ ::xox::XmlNodeReader new ]
        set root [ ::xox::Node new ]

        $factory buildNodes $root $xml

        my assertEquals [ $root set nodeName ] ESTBBA
        my assertEquals [ $root set EnablePassword ] lab
        my assertEquals [ $root set TacacsPassword ] lab
        my assertEquals [ $root set TacacsUsername ] lab
        my assertEquals [ $root set topomapFile ] estbba-topo.xml
        my assertEquals [ $root set webPath ] http://estmpls1.cisco.com/estbba/
        my assertEquals [ $root set location ] /var/www/html/estbba/
        my assertEquals [ $root set title ] "EST BBA Network Verification"
        my assertEquals [ $root set url ] http://www.cisco.com
        my assertEquals [ $root set includes ] "::xox::Interface testPingAllPeerInterfaces"

        
        #Is this the expected behavior?
        #my assertEquals [ $root set excludes ] "::xox::Interface testDescriptionExists"
        my assertEquals [ $root set excludes ] "::xox::Interface testLayer3Connected"
     }

     TestXmlNodeReader instproc testChild {} {

        set xml {
<root>
    <::xox::Node>
    </::xox::Node>
</root>}

        set factory [ ::xox::XmlNodeReader new ]
        set root [ ::xox::Node new ]

        $factory buildNodes $root $xml

        my assertEquals [ $root getNodeName ] Node
        set nodes [ $root nodes ]
        my assertEquals [ llength $nodes ] 1

        my assertEquals [ $root Node info class ] ::xox::Node 
     }

     TestXmlNodeReader instproc testChild2 {} {

        set xml {
<root>
    <::xox::Node/>
</root>}

        set factory [ ::xox::XmlNodeReader new ]
        set root [ ::xox::Node new ]

        $factory buildNodes $root $xml

        my assertEquals [ $root getNodeName ] Node
        set nodes [ $root nodes ]
        my assertEquals [ llength $nodes ] 1

        my assertEquals [ $root Node info class ] ::xox::Node 
     }

     TestXmlNodeReader instproc testChild3 {} {

        set xml {
<testsuite package="xounit::test">
    <::xounit::test::TestTest/>
</testsuite>}

        set factory [ ::xox::XmlNodeReader new ]
        set root [ ::xox::Node new ]

        $factory buildNodes $root $xml

        my assertEquals [ $root getNodeName ] Node
        set nodes [ $root nodes ]
        my assertEquals [ llength $nodes ] 1

        my assertEquals [ $root TestTest info class ] ::xounit::test::TestTest
     }

     TestXmlNodeReader instproc notestIsclassAndLoad {} {

         set factory [ ::xox::XmlNodeReader new ]

         my assert [ $factory isclassAndLoad ::xotcl::Class ]
         my assertFalse [ $factory isclassAndLoad ::xox::NotAClass ]

         my assert [ $factory isclassAndLoad ::abc::ABCD ]
     }

     TestXmlNodeReader instproc testLoadAutomatically {} {

         set xml {
<testsuite>
    <::abc::ABCD/>
</testsuite>}

         set factory [ ::xox::XmlNodeReader new ]
         set root [ ::xox::Node new ]

         $factory buildNodes $root $xml

         $root ABCD
     }

     TestXmlNodeReader instproc testConfigureNode {} {

         set xml {
<node>
    <a>5</a>
</node>}

         set factory [ ::xox::XmlNodeReader new ]
         set root [ ::xox::Node new ]

         $root proc configureNode { } {

             my set a 6
         }

         $factory buildNodes $root $xml

         my assertEquals [ $root set a ] 6
     }

     TestXmlNodeReader instproc testGetClassFromTag { } {

         set reader [ ::xox::XmlNodeReader new ]

         my assertEquals [ $reader getClassFromTag ::xox::Package ] \
                ::xox::Package

         my assertEquals [ $reader getClassFromTag xox::Package ] \
                ::xox::Package
         
         my assertEquals [ $reader getClassFromTag xox:Package ] \
                ::xox::Package
     }

     TestXmlNodeReader instproc testBuildNewTree {} {

         set xml {
<::xox::Node> 
    <a>5</a>
</::xox::Node>
         }

         set factory [ ::xox::XmlNodeReader new ]

         set root [ $factory buildNewTree $xml ]

         my assertObject $root

         my assertEquals [ $root info class ] ::xox::Node
         my assertEquals [ $root set a ] 5
     }

     TestXmlNodeReader instproc testListsSimple {} {

         set xml {
<::xox::Node> 
    <a type="list">
        <value>one</value>
        <value>two</value>
    </a>
</::xox::Node>
         }

         set factory [ ::xox::XmlNodeReader new ]

         set root [ $factory buildNewTree $xml ]

         my assertEquals [ $root info class ] ::xox::Node

         my assertEquals [ $root set a ] {one two}
     }

     TestXmlNodeReader instproc testListsEmpty {} {

         set xml {
<::xox::Node> 
    <a type="list">
    </a>
</::xox::Node>
         }

         set factory [ ::xox::XmlNodeReader new ]

         set root [ $factory buildNewTree $xml ]

         my assertEquals [ $root info class ] ::xox::Node

         my assertEquals [ $root set a ] {}
     }

     TestXmlNodeReader instproc testArraySimple {} {

         set xml {
<::xox::Node> 
    <a type="array">
        <index>min</index>
        <value>1</value>
        <index>max</index>
        <value>10</value>
    </a>
</::xox::Node>
         }

         set factory [ ::xox::XmlNodeReader new ]

         set root [ $factory buildNewTree $xml ]

         my assertEquals [ $root info class ] ::xox::Node

         my assertEquals [ $root set a(min) ] 1
         my assertEquals [ $root set a(max) ] 10
     }

     TestXmlNodeReader instproc testKeyValueSimple {} {

         set xml {
<::xox::Node> 
    <a type="keyvalue">
        <value key="min">1</value>
        <value key="max">10</value>
    </a>
</::xox::Node>
         }

         set factory [ ::xox::XmlNodeReader new ]

         set root [ $factory buildNewTree $xml ]

         my assertEquals [ $root info class ] ::xox::Node

         my assertEquals [ $root set a(min) ] 1
         my assertEquals [ $root set a(max) ] 10
     }

     TestXmlNodeReader instproc testKeyCommaValueSimple {} {

         set xml {
<::xox::Node> 
    <a type="keyvalue">
        <value key="u,v">1</value>
        <value key="x,y">10</value>
    </a>
</::xox::Node>
         }

         set factory [ ::xox::XmlNodeReader new ]

         set root [ $factory buildNewTree $xml ]

         my assertEquals [ $root info class ] ::xox::Node

         my assertEquals [ $root set a(u,v) ] 1
         my assertEquals [ $root set a(x,y) ] 10
     }

     TestXmlNodeReader instproc testKeyValueDoubleColon {} {

         set xml {
<::xox::Node> 
    <a type="keyvalue">
        <value key="u,v">1::6</value>
        <value key="x,y">10::1</value>
    </a>
</::xox::Node>
         }

         set factory [ ::xox::XmlNodeReader new ]

         set root [ $factory buildNewTree $xml ]

         my assertEquals [ $root info class ] ::xox::Node

         my assertEquals [ $root set a(u,v) ] 1::6
         my assertEquals [ $root set a(x,y) ] 10::1
     }

     TestXmlNodeReader instproc testXMLValue {} {

         set xml {
<::xox::Node> 
    <a type="xml">
        <x>5</x>
    </a>
</::xox::Node>
         }

         set factory [ ::xox::XmlNodeReader new ]

         set root [ $factory buildNewTree $xml ]

         my assertEquals [ $root info class ] ::xox::Node

         my assertTrue [ $root exists a ] a
         my assertObject [ $root set a ] 
         my assertEquals [ [ $root set a ] x ] 5
     }

     TestXmlNodeReader instproc testObjectAndEval {} {

         set xml {
<testbed>
    <::xox::Node> 
    <a>5</a>
    </::xox::Node>
</testbed>
         }

         set factory [ ::xox::XmlNodeReader new ]
         set root [ ::xox::Node new ]

         $factory buildNodes $root $xml
         set child [ $root info children ]

         my assertEquals [ $root info class ] ::xox::Node
         my assertEquals [ $child info class ] ::xox::Node

         my assertTrue [ $child exists a ] a
         my assertEquals [ $child set a ] 5

         my assertEquals [ $child eval {
             set a
         } ] 5

         ::xox::ObjectGraph copyObjectVariablesToScope $child

         my assertEquals $a 5
     }
}

package provide xox::test::TestXmlNodeReader 1.0


