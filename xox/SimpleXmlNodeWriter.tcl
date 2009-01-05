# Created at Fri Jun 15 07:47:43 EDT 2007 by bthomass

namespace eval ::xox {

    namespace import -force ::xotcl::*

    Class SimpleXmlNodeWriter -superclass ::xox::XmlNodeWriter

    SimpleXmlNodeWriter # SimpleXmlNodeWriter {

        SimpleXmlNodeWriter writes a simpler form of XML than
        does XmlNodeWriter
    }

   SimpleXmlNodeWriter instproc buildXml { parentDomNode node } {

       my instvar dom

       foreach var [ lsort [ $node info vars ] ] {

           if { "$var" == "nodeName" } { continue }
           if { "$var" == "__autonames" } { continue }

           if [ $node array exists $var ] {

               my buildArrayVariable $parentDomNode $node $var

           } else {

               my buildVariable $parentDomNode $node $var
          }
       }

       foreach subElement [ $node nodes ] {

           if [ $subElement hasclass ::xox::Node ] {

               my buildNodeXml $parentDomNode $subElement
           }
       }
    }

   SimpleXmlNodeWriter instproc buildVariableXml { parentDomNode variable value { valueType "" } } {

       my instvar dom

       set variableNode [ $dom createElement $variable  ]
       if [ catch { 
           set valueText [ $dom createTextNode $value ]
       } ] {
           if [ catch {
               set valueText [ $dom createCDATASection $value ]
           } ] {
               return
           }
       }

       if { "$valueType" != "" } {
           $variableNode setAttribute type $valueType
       }

       $variableNode appendChild $valueText
       $parentDomNode appendChild $variableNode
   }


   SimpleXmlNodeWriter instproc buildVariable { parentDomNode node variable } {

        my instvar dom

        set value [ $node set $variable ]

        regsub -all {&} $value { } value

        if { "" == "$value" } {

           return 
        }

        if [ my isTemp $value ] {

            return
        }

        my buildVariableXml $parentDomNode ${variable} $value
   }

   SimpleXmlNodeWriter instproc isTemp { x } {

      return [ string match ::xotcl::__* $x ]
   }

   SimpleXmlNodeWriter instproc buildDTD { rootNode } {

      return ""
   }
}


