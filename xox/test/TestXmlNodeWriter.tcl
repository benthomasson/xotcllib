
namespace eval ::xox::test {

     namespace import -force ::xotcl::*

     Class TestXmlNodeWriter -superclass ::xounit::TestCase

     TestXmlNodeWriter instproc testGenerateXml {} {

        set writer [ ::xox::XmlNodeWriter new ]
        set node [ ::xox::Node new ]

        set xml [ $writer generateXml $node ]

        #my debug $xml

        return
     }

     TestXmlNodeWriter instproc testNode {} {

        set writer [ ::xox::XmlNodeWriter new ]
        set node [ ::xox::Node new ]

        $node set a(1) 1

        set xml [ $writer generateXml $node ] 
        #my debug $xml

        return
     }

     TestXmlNodeWriter instproc testNodeArrayObject {} {

        set writer [ ::xox::XmlNodeWriter new ]
        set node [ ::xox::Node new ]

        $node set a($node) 1

        set xml [ $writer generateXml $node ] 
        #my debug $xml
        return
     }
 
     TestXmlNodeWriter instproc testSubNodes {} {

        set writer [ ::xox::XmlNodeWriter new ]
        set node [ ::xox::Node new ]
        my assertEquals [ $node getNodeName ] Node 

        set sub1 [ $node addAutoNameNode [ ::xox::Node new ] ]
        set sub2 [ $node addAutoNameNode [ ::xox::Node new ] ]
        set sub3 [ $node addAutoNameNode [ ::xox::Node new ] ]

        my assertEquals [ $sub1 getNodeName ] Node 
        my assertEquals [ $sub2 getNodeName ] Node1
        my assertEquals [ $sub3 getNodeName ] Node2

        my assertError { $sub1 name }
        my assertError { $sub2 name }
        my assertError { $sub3 name }

        set xml [ $writer generateXml $node ] 

        #my debug $xml
        return
     }
 
     TestXmlNodeWriter instproc testExternalRoot {} {

        set externalRoot [ ::xox::Node create ::xox::test::er -nodeName External ]

        set writer [ ::xox::XmlNodeWriter new ]
        set node [ ::xox::Node new -nodeName Normal ]

        $node set externalRoot $externalRoot
        my assertEquals [ $node set externalRoot ] $externalRoot 1

        set xml [ $writer generateXml $node ] 

        set newRoot [ ::xox::Node new ]

        set reader [ ::xox::XmlNodeReader new ]

        $reader buildNodes $newRoot $xml

        my assertEquals [ $node getNodeName ] Normal 1.9
        my assertEquals [ $node set externalRoot ] $externalRoot 2
        my assertEquals [ $newRoot getNodeName ] Normal 2.1
        set newExternalRoot [ $newRoot set externalRoot ]
        my assertNotEquals $newExternalRoot $newRoot 3
        my assertEquals [ $newExternalRoot getNodeName ] External
        my assertEquals $newExternalRoot $externalRoot 4
     }

     TestXmlNodeWriter instproc testWriteRead {} {

         set root [ ::xox::Node new ]

         set ed [ $root addNode [ ::xox::Node new -nodeName Ed ] ]
         $ed addNode [ ::xox::Node new -nodeName E0 ] 

         set writer [ ::xox::XmlNodeWriter new ]
         set xml [ $writer generateXml $root ] 

         #my debug $xml
         
         $root destroy

         set root [ ::xox::Node new ]

         set reader [ ::xox::XmlNodeReader new ]

         $reader buildNodes $root $xml

         $root Ed
         $root Ed E0
     }

     TestXmlNodeWriter instproc testMixins {} {

         set root [ ::xox::Node new ]

         set ed [ $root addNode [ ::xox::Node new -nodeName Ed ] ]
         $ed mixin add ::xox::Logging

         my assert [ $ed hasclass ::xox::Logging ]

         set writer [ ::xox::XmlNodeWriter new ]
         set xml [ $writer generateXml $root ] 
         
         $root destroy

         set root [ ::xox::Node new ]

         set reader [ ::xox::XmlNodeReader new ]

         $reader buildNodes $root $xml

         $root Ed
         my assert [ $root Ed hasclass ::xox::Logging ]
     }

     TestXmlNodeWriter instproc testMixedList {} {

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

        set writer [ ::xox::XmlNodeWriter new ]
        set xml [ $writer generateXml $root ] 

        #my debug $xml
        return
     }

     TestXmlNodeWriter instproc testClassVariableValues {} {

         set xml {\
<testbed>
    <nodeName>ESTBBA</nodeName>
    <::xox::Node>
    <name>::xox::Node</name>
    </::xox::Node>
</testbed>}

        set factory [ ::xox::XmlNodeReader new ]
        set root [ ::xox::Node new ]

        $factory buildNodes $root $xml

        my assertEquals [ $root Node set name ] ::xox::Node

        set writer [ ::xox::XmlNodeWriter new ]
        set xml [ $writer generateXml $root ] 

        #my debug $xml

        set new [ ::xox::Node new ]

        $factory buildNodes $new $xml

        $new Node 

        my assertEquals [ $new Node set name ] ::xox::Node

        return
     }

     TestXmlNodeWriter instproc testClassArrayVariableValues {} {

         set root [ ::xox::Node new ]
         set factory [ ::xox::XmlNodeReader new ]
         set writer [ ::xox::XmlNodeWriter new ]

         $root set a(1) ::xox::Node

         my assertEquals [ $root set a(1) ] ::xox::Node
         set xml [ $writer generateXml $root ] 

         set new [ ::xox::Node new ]

         $factory buildNodes $new $xml

         my assertEquals [ $root set a(1) ] ::xox::Node
         my assertEquals [ $new set a(1) ] ::xox::Node
     }

     TestXmlNodeWriter instproc testEmptyValue {} {

         set root [ ::xox::Node new ]
         set factory [ ::xox::XmlNodeReader new ]
         set writer [ ::xox::XmlNodeWriter new ]

         $root set empty ""

         my assertEquals [ $root set empty ] ""
         set xml [ $writer generateXml $root ] 

         #my debug $xml

         set new [ ::xox::Node new ]

         $factory buildNodes $new $xml
         
         my assertEquals [ $root set empty ] ""
         my assertEquals [ $new set empty ] ""
     }

     TestXmlNodeWriter instproc testEmptyArrayValue {} {

         set root [ ::xox::Node new ]
         set factory [ ::xox::XmlNodeReader new ]
         set writer [ ::xox::XmlNodeWriter new ]

         $root set empty(1) ""

         my assertEquals [ $root set empty(1) ] ""
         set xml [ $writer generateXml $root ] 

         #my debug $xml

         set new [ ::xox::Node new ]

         $factory buildNodes $new $xml
         
         my assertEquals [ $root set empty(1) ] ""
         my assertEquals [ $new set empty(1) ] ""
     }

     TestXmlNodeWriter instproc testNonNode {} {

        set writer [ ::xox::XmlNodeWriter new ]
        set node [ ::xox::Node new ]
        Object create ${node}::a

        set xml [ $writer generateXml $node ]

        my debug $xml

        return
     }

     TestXmlNodeWriter instproc testGetTagFromClass {} {

        set writer [ ::xox::XmlNodeWriter new ]

        my assertEquals [ $writer getTagFromClass ::xox::Package ] \
                        xox:Package

        my assertEquals [ $writer getTagFromClass xox::Package ] \
                        xox:Package
     }

     TestXmlNodeWriter instproc test@Doc {} {

        set writer [ ::xox::SimpleXmlNodeWriter new ]
        set reader [ ::xox::XmlNodeReader new ]

        set node [ ::xox::Node new ]

        $node @doc stuff { stuff }

        my assertEqualsTrim [ $node get# stuff ] stuff 1

        set new [ ::xox::Node new ]

        set xml [ $writer generateXml $node ]

        $reader buildNodes $new $xml

        my assertEqualsTrim [ $new get# stuff ] "" 2
     }

     TestXmlNodeWriter instproc testIsTemporary {} {

        set writer [ ::xox::XmlNodeWriter new ]

        my assert [ $writer isTemporary [ Object new ] ]
        my assertFalse [ $writer isTemporary [ Object create ::xox::test::a ] ]
     }
}

package provide xox::test::TestXmlNodeWriter 1.0


