
package require tdom

namespace eval ::xox {

    Class XmlReader 

    XmlReader # XmlReader {

        A library of methods that are useful when working with tDOM.  
    }

    XmlReader # getFirstChildValueNamed {

        Extracts the text of the first sub-node named name.

        Example:

            <node>
                <subnode>
                value
                </subnode>
            </node>

        $reader getFirstChildValueNamed $node subnode

        Will return: value
    }

    XmlReader instproc getFirstChildValueNamed { node name } {

        return [ my extractValue [ my getFirstChildNamed $node $name ] ]
    }

    XmlReader # hasChildNamed {

        Returns 1 if node has a child node named name. Returns 0 otherwise.
    }
    
    XmlReader instproc hasChildNamed { node name } {

        foreach child [ $node childNodes ] {

            if { "[ $child nodeName ]" == "$name" } {

                return 1
            }
        }

        return 0
    }

    XmlReader # getFirstChildNamed {

        Returns the dom node named name that is a child of node.
    }
    
    XmlReader instproc getFirstChildNamed { node name } {

        foreach child [ $node childNodes ] {

            if { "[ $child nodeName ]" == "$name" } {

                return $child
            }
        }

        error "Did not find a child of $node [ $node nodeName ] with name $name\n\
                [ join [ lrange [ split [ $node asXML ] "\n" ] 0 10 ] "\n" ]"
    }

    XmlReader # extractValue {

        Extracts the text value of node.
    }

    XmlReader instproc extractValue { node } {

       set childNodes [ $node childNodes ]

       if [ my isEmptyNode $node ] {

           return ""
       }

       if { [ llength $childNodes ] == 1 } {
       
           set value [ string trim [ $childNodes nodeValue ] ]

       } else {

           error "Bad node: [ $node nodeName ]"
       }

       return $value
    }

    XmlReader instproc isEmptyNode { node } {

        return [ expr { [ llength [ $node childNodes ] ]  == 0 } ]
    }


    XmlReader instproc getTagFromClass { tag } {

    }
}

