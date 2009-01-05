# Created at Thu Jul 17 10:00:39 PM EDT 2008 by bthomass

namespace eval ::xox {

    Class XmlObjectReader -superclass ::xox::XmlReader

    XmlObjectReader @doc XmlObjectReader {

        Please describe the class XmlObjectReader here.
    }

    XmlObjectReader parameter {

    }

   XmlObjectReader instproc buildNewTree { xml } {

       set rootObject [ Object new ]

       if { "" != "[ string trim $xml ]" } {

           package require tdom

           set document [dom parse $xml]
           set root     [$document documentElement]
           my buildObject $root $rootObject 
       }

       return $rootObject
   }

   XmlObjectReader instproc buildNewTreeFromNode { node } {

       set rootObject [ Object new ]

       my buildObject $node $rootObject 

       return $rootObject
   }

   XmlObjectReader instproc buildObject { node object } {

       foreach child [ $node childNodes ] {

           if { "[ $child nodeType ]" != "ELEMENT_NODE" } { continue }
           if [ my isEmptyNode $child ] { 
               my setFlagTrue $object [ $child nodeName ]
               continue
           }
           if [ my hasTextNode $child ] {
               my setTextValue $child $object
               continue
           }

           my createNewObject $child $object
       }
   }

   XmlObjectReader instproc setFlagTrue { object name } {

       $object set $name 1
       $object parametercmd $name
   }

   XmlObjectReader instproc hasTextNode { node } {

       set childNodes [ $node childNodes ]

       if [ my isEmptyNode $node ] { return 0 }

       if { [ llength $childNodes ] == 1 } {
       
           return [ expr { "TEXT_NODE" ==  "[ $childNodes nodeType ]" } ]
       } 

       return 0
   }

   XmlObjectReader instproc setTextValue { node object } {

       $object lappend [ $node nodeName ] [ my extractValue $node ]
       $object parametercmd [ $node nodeName ]
   }

   XmlObjectReader instproc createNewObject { node parentObject } {

       if [ my isobject ${parentObject}::[ $node nodeName ] ] {
           set object [ Object create ${parentObject}::[ $parentObject autoname [ $node nodeName ] ] ]
       } else {
           set object [ Object create ${parentObject}::[ $node nodeName ] ]
       }

       my buildObject $node $object
   }
}


