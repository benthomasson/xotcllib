# Created at Thu Jul 17 10:00:39 PM EDT 2008 by bthomass

namespace eval ::xox::test {

    Class TestXmlObjectReader -superclass ::xounit::TestCase

    TestXmlObjectReader parameter {

    }

    TestXmlObjectReader instproc setUp { } {

        my instvar reader

        set reader [ ::xox::XmlObjectReader new ]
    }

    TestXmlObjectReader instproc testEmpty { } {
        my instvar reader
        my assertObject [ $reader buildNewTree { } ] 
    }

    TestXmlObjectReader instproc testSimple { } {
        my instvar reader
        my assertObject [ $reader buildNewTree { <root/> } ] 
    }

    TestXmlObjectReader instproc testVar { } {
        my instvar reader
        set o [ $reader buildNewTree { 
            <root> 
                <x>5</x>
            </root>    
        } ] 

        my assertObject $o
        my assertEquals [ $o set x ] 5
        my assertEquals [ $o x ] 5
    }

    TestXmlObjectReader instproc testMultipleVars { } {
        my instvar reader
        set o [ $reader buildNewTree { 
            <root> 
                <x>5</x>
                <x>5</x>
            </root>    
        } ] 

        my assertObject $o
        my assertEquals [ $o set x ] "5 5"
        my assertEquals [ $o x ] "5 5"
    }

    TestXmlObjectReader instproc testFlag { } {
        my instvar reader
        set o [ $reader buildNewTree { 
            <root> 
                <x/>
                <x/>
            </root>    
        } ] 

        my assertObject $o
        my assertEquals [ $o set x ] 1
        my assertEquals [ $o x ] 1
    }

    TestXmlObjectReader instproc testChildFlag { } {
        my instvar reader
        set o [ $reader buildNewTree { 
            <root> 
                <child>
                    <x/>
                    <y>5</y>
                </child>
            </root>    
        } ] 

        my assertObject $o
        my assertEquals [ $o info children ] ${o}::child
        my assertObject [ $o child ]
        my assertEquals [ $o child set x ] 1
        my assertEquals [ $o child x ] 1
        my assertEquals [ $o child set y ] 5
        my assertEquals [ $o child y ] 5
    }

    TestXmlObjectReader instproc testMultipleChildren { } {
        my instvar reader
        set o [ $reader buildNewTree { 
            <root> 
                <child>
                    <x/>
                </child>
                <child>
                    <x/>
                </child>
            </root>    
        } ] 

        my assertObject $o
        my assertEquals [ $o info children ] [ list ${o}::child ${o}::child1 ]
        my assertObject [ $o child ]
        my assertEquals [ $o child set x ] 1
        my assertEquals [ $o child x ] 1
        my assertEquals [ $o child1 set x ] 1
        my assertEquals [ $o child1 x ] 1
    }

    TestXmlObjectReader instproc testMultipleLevelsOfChildren { } {
        my instvar reader
        set o [ $reader buildNewTree { 
            <root> 
                <child>
                    <x/>
                    <child>
                        <x/>
                    </child>
                </child>
            </root>    
        } ] 

        my assertObject $o
        my assertEquals [ $o info children ] ${o}::child
        my assertObject [ $o child ]
        my assertEquals [ $o child set x ] 1
        my assertEquals [ $o child x ] 1
        my assertEquals [ $o child info children ] ${o}::child::child
        my assertEquals [ $o child child set x ] 1
        my assertEquals [ $o child child x ] 1
    }

    TestXmlObjectReader instproc tearDown { } {

        #add tear down code here
    }
}


