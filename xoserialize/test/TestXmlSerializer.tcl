
namespace eval ::xoserialize::test { 

Class create TestXmlSerializer -superclass { ::xounit::TestCase }
  
TestXmlSerializer @doc TestXmlSerializer {
Please describe TestXmlSerializer here.
}
       
TestXmlSerializer parameter {

} 
        

TestXmlSerializer @doc test { 
test does ...
}

TestXmlSerializer instproc test {  } {
        set serializer [ ::xoserialize::XmlSerializer new ]

        puts [ $serializer serialize [ Object new  -set a 1  -set b(1) 1  -requireNamespace ] ]
    
}


TestXmlSerializer @doc testDeserialize { 
testDeserialize does ...
}

TestXmlSerializer instproc testDeserialize {  } {
        set serializer [ ::xoserialize::XmlSerializer new ]

        set xml [ $serializer serialize [ Object new  -set a 1  -set b(1) 1  -requireNamespace ] ]

        set object [ $serializer deserialize $xml ]

        my assertEquals [ $object set a ] 1
        my assertEquals [ $object set b(1) ] 1
        my assert [ $object info hasNamespace ]
    
}
}


