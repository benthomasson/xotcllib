
namespace eval ::xoserialize { 

Class create Serializer -superclass { ::xotcl::Object }
  
Serializer @doc Serializer {
Please describe Serializer here.
}
       
Serializer parameter {

} 
  
Serializer parametercmd singleton
    

Serializer @doc getInstance { 
getInstance does ...
}

Serializer proc getInstance {  } {
        if { ! [ my exists singleton ] } {

            my singleton [ my new ]
        }

        return [ my singleton ]
    
}
  

Serializer @doc cleanUpVars { 
cleanUpVars does ...
            object -
}

Serializer instproc cleanUpVars { object } {
        foreach var [ $object info vars ] {

            if [ $object array exists $var ] {

                #?

            } else {

                $object set $var [ my unEscapeBrackets [ $object set $var ] ]
            }
        }
    
}


Serializer @doc deserialize { 
deserialize does ...
            serial -
}

Serializer instproc deserialize { serial } {
        uplevel #0 eval "namespace import -force ::xotcl::*"
        uplevel #0 eval $serial
    
}


Serializer @doc deserializeListToNew { 
deserializeListToNew does ...
            serialList -
}

Serializer instproc deserializeListToNew { serialList } {
        set object [ lindex "$serialList" 0 ]
        set associatesList [ lindex "$serialList" 1 ]
        set serial [ lindex "$serialList" 2 ]
        set newObject ""

        foreach associate $associatesList {

            set aNewObject [ Object new ]

            if { "$object" == "$associate" } {

                set newObject $aNewObject
            }

            set serial [ string map "\{$associate\} \{$aNewObject\}" $serial ]
        }

        my deserialize $serial

        my cleanUpVars $newObject

        return $newObject
    
}


Serializer @doc escapeBrackets { 
escapeBrackets does ...
            data -
}

Serializer instproc escapeBrackets { data } {
        regsub -all {\\} $data {\\\\} data
        regsub -all {\\} $data {\\\\} data

        regsub -all {\{} $data "\\\{" data
        regsub -all {\}} $data "\\\}" data

        return $data
    
}


Serializer @doc findObjectsInList { 
findObjectsInList does ...
            objectListName - 
            aList -
}

Serializer instproc findObjectsInList { objectListName aList } {
        upvar $objectListName objects

        foreach element [ split $aList " " ] {

            if { "" == "$element" } { continue }

            #puts "Element: $element Element"
            #puts [ string first "::" $element ]
            #puts [  Object isobject $element ]

            if [ Object isobject $element ] {

                if [ $element isclass ] {

                    continue
                }


                if { [ string first "::" $element ] != 0 } {

                    continue
                }
                
                if { [ lsearch $objects $element ] != -1  } {

                    continue
                }

                lappend objects $element
            } 
        }
    
}


Serializer @doc flattenList { 
flattenList does ...
            aList -
}

Serializer instproc flattenList { aList } {
        regsub -all {\{} $aList "" aList
        regsub -all {\}} $aList "" aList

        return $aList
    
}


Serializer @doc getAllAssociates { 
getAllAssociates does ...
            object -
}

Serializer instproc getAllAssociates { object } {
        set toFindAssociates $object
        set foundAssociates ""

        while { [ llength $toFindAssociates ] != 0 } {

            set current [ lindex $toFindAssociates 0 ]

            set toFindAssociates [ lreplace $toFindAssociates 0 0 ]

            if { [ lsearch -sorted -increasing $foundAssociates $current ] == -1 } {

                lappend foundAssociates $current
                set foundAssociates [ lsort $foundAssociates ]
            }

            set currentAssociates [ my getAssociates $current ]

            foreach associate $currentAssociates {

                if { [ lsearch -sorted -increasing $foundAssociates $associate ] != -1 } {

                    continue
                }

                if { [ lsearch -sorted -increasing $toFindAssociates $associate ] != -1 } {

                    continue
                }

                lappend toFindAssociates $associate
                set toFindAssociates [ lsort $toFindAssociates ]
            }

        }

        return $foundAssociates
    
}


Serializer @doc getAssociates { 
getAssociates does ...
            object -
}

Serializer instproc getAssociates { object } {
        set associates $object

        foreach var [ $object info vars ] {

            if [ $object array exists $var ] {

                foreach name [ $object array names $var ] {

                    set values [my flattenList [ $object array get $var ]]

                    my findObjectsInList associates $values
                }

            } else {

                set values [my flattenList [ $object set $var ]]
                my findObjectsInList associates $values

            }
        }

        return $associates
    
}


Serializer @doc nextName { 
nextName does ...
}

Serializer instproc nextName {  } {
        return "::xoserialize::[ my autoname serial ]"
    
}


Serializer @doc serialize { 
serialize does ...
            object -
}

Serializer instproc serialize { object } {
        if [ Object isclass $object ] {

            return [ my serializeClass $object ]
        }

        return [ my serializeObject $object ]
    
}


Serializer @doc serializeAssociates { 
serializeAssociates does ...
            object -
}

Serializer instproc serializeAssociates { object } {
        set serial ""

        foreach associate [ my getAllAssociates $object ] {

            append serial [ my serializeObject $associate ]
            append serial "\n"
        }

        return $serial

    
}


Serializer @doc serializeAssociatesList { 
serializeAssociatesList does ...
            object -
}

Serializer instproc serializeAssociatesList { object } {
        set serial ""
        set associatesList [ my getAllAssociates $object ]
        set newAssociatesList {}

        foreach associate $associatesList {

            append serial [ my serializeObject $associate ]
            append serial "\n"
        }

        foreach associate $associatesList {

            set aNewObject [ my nextName ]

            if { "$object" == "$associate" } {

                set newObject $aNewObject
            }

            set serial [ string map "\{$associate\} \{$aNewObject\}" $serial ]

            lappend newAssociatesList $aNewObject
        }

        return "\{$newObject\}\n\{$newAssociatesList\}\n\{$serial\}" 
    
}


Serializer @doc serializeClass { 
serializeClass does ...
            class -
}

Serializer instproc serializeClass { class } {
        
        set serial ""

        set superclass [ $class info superclass ]
        
        append serial "Class create \{$class\} \\\n"
        append serial "-superclass \{$superclass\} \\\n"
        append serial [ my serializeNamespace $class ]
        append serial "\n"

        append serial [ my serializeVars $class ]
        append serial [ my serializeProcs $class ]
        append serial [ my serializeMixins $class ]
        append serial [ my serializeFilters $class ]
        append serial [ my serializeInvars $class ]

        append serial [ my serializeParameter $class ]
        append serial [ my serializeInstProcs $class ]
        append serial [ my serializeInstMixins $class ]
        append serial [ my serializeInstFilters $class ]
        append serial [ my serializeInstInvars $class ]

        return $serial
    
}


Serializer @doc serializeFilter { 
serializeFilter does ...
            object - 
            aFilter -
}

Serializer instproc serializeFilter { object aFilter } {
        set serial ""

        set guard [ $object info filterguard $aFilter ]

        append serial "\{$object\} filter \{$aFilter\}\n"
        append serial "\{$object\} filterguard \{$aFilter\} \{$guard\} \n"
        return $serial
    
}


Serializer @doc serializeFilters { 
serializeFilters does ...
            object -
}

Serializer instproc serializeFilters { object } {
        set serial ""

        foreach aFilter [ $object info filter ] {

            append serial [ my serializeFilter $object $aFilter ]
        }

        return $serial
    
}


Serializer @doc serializeInstFilter { 
serializeInstFilter does ...
            class - 
            aFilter -
}

Serializer instproc serializeInstFilter { class aFilter } {
        set serial ""

        set guard [ $class info instfilterguard $aFilter ]

        append serial "\{$class\} instfilter \{$aFilter\}\n"
        append serial "\{$class\} instfilterguard \{$aFilter\} \{$guard\} \n"
        return $serial
    
}


Serializer @doc serializeInstFilters { 
serializeInstFilters does ...
            class -
}

Serializer instproc serializeInstFilters { class } {
        set serial ""

        foreach aFilter [ $class info instfilter ] {

            append serial [ my serializeInstFilter $class $aFilter ]
        }

        return $serial
    
}


Serializer @doc serializeInstInvars { 
serializeInstInvars does ...
            class -
}

Serializer instproc serializeInstInvars { class } {
        set serial ""

        set invars [ $class info instinvar ]

        append serial "\{$class\} instinvar \{$invars\} \n"

        return $serial
    
}


Serializer @doc serializeInstMixin { 
serializeInstMixin does ...
            class - 
            aMixin -
}

Serializer instproc serializeInstMixin { class aMixin } {
        set serial ""
        append serial "\{$class\} instmixin add \{$aMixin\}\n"
        return $serial
    
}


Serializer @doc serializeInstMixins { 
serializeInstMixins does ...
            class -
}

Serializer instproc serializeInstMixins { class } {
        set serial ""

        foreach aMixin [ $class info instmixin ] {

            append serial [ my serializeInstMixin $class $aMixin ]
        }

        return $serial
    
}


Serializer @doc serializeInstProc { 
serializeInstProc does ...
            class - 
            aProc -
}

Serializer instproc serializeInstProc { class aProc } {
        set serial ""

        set args [ $class info instargs $aProc ]
        set body [ $class info instbody $aProc ]
        set nonposargs [ $class info instnonposargs $aProc ]
        set pre [ $class info instpre $aProc ]
        set post [ $class info instpost $aProc ]

        append serial "\{$class\} instproc \{$aProc\} "
        if { "$nonposargs" != "" } {
            append serial "\{$nonposargs\} "
        }
        append serial "\{$args\} "
        append serial "\{$body\} "
        if { "$pre" != "" || "$post" != "" } {
            append serial "\{$pre\} "
            append serial "\{$post\} "
        }
        append serial "\n"
        return $serial
    
}


Serializer @doc serializeInstProcs { 
serializeInstProcs does ...
            class -
}

Serializer instproc serializeInstProcs { class } {
        set serial ""

        foreach aProc [ $class info instprocs ] {

            append serial [ my serializeInstProc $class $aProc ]
        }

        return $serial
    
}


Serializer @doc serializeInvars { 
serializeInvars does ...
            object -
}

Serializer instproc serializeInvars { object } {
        set serial ""

        set invars [ $object info invar ]

        append serial "\{$object\} invar \{$invars\} \n"

        return $serial
    
}


Serializer @doc serializeMixin { 
serializeMixin does ...
            object - 
            aMixin -
}

Serializer instproc serializeMixin { object aMixin } {
        set serial ""
        append serial "\{$object\} mixin add \{$aMixin\}\n"
        return $serial
    
}


Serializer @doc serializeMixins { 
serializeMixins does ...
            object -
}

Serializer instproc serializeMixins { object } {
        set serial ""

        foreach aMixin [ $object info mixin ] {

            append serial [ my serializeMixin $object $aMixin ]
        }

        return $serial
    
}


Serializer @doc serializeNamespace { 
serializeNamespace does ...
            object -
}

Serializer instproc serializeNamespace { object } {
        if { [ $object info hasNamespace ] } {

            return "-requireNamespace \\\n"
        }

        return ""
    
}


Serializer @doc serializeObject { 
serializeObject does ...
            object -
}

Serializer instproc serializeObject { object } {
        set serial ""
        set class [ $object info class ]
        
        append serial "Object create \{$object\} -noinit \\\n"
        append serial "-class \{$class\} \\\n"
        append serial [ my serializeNamespace $object ]
        append serial "\n"
        append serial [ my serializeVars $object ]
        append serial [ my serializeProcs $object ]
        append serial [ my serializeMixins $object ]
        append serial [ my serializeFilters $object ]
        append serial [ my serializeInvars $object ]

        return $serial
    
}


Serializer @doc serializeParameter { 
serializeParameter does ...
            class -
}

Serializer instproc serializeParameter { class } {
        set serial ""

        set parameter [ $class info parameter ]

        append serial "\{$class\} parameter \{$parameter\} \n"

        return $serial
    
}


Serializer @doc serializeProc { 
serializeProc does ...
            object - 
            aProc -
}

Serializer instproc serializeProc { object aProc } {
        set serial ""

        set args [ $object info args $aProc ]
        set body [ $object info body $aProc ]
        set nonposargs [ $object info nonposargs $aProc ]
        set pre [ $object info pre $aProc ]
        set post [ $object info post $aProc ]

        append serial "\{$object\} proc \{$aProc\} "
        if { "$nonposargs" != "" } {
            append serial "\{$nonposargs\} "
        }
        append serial "\{$args\} "
        append serial "\{$body\} "
        if { "$pre" != "" || "$post" != "" } {
            append serial "\{$pre\} "
            append serial "\{$post\} "
        }
        append serial "\n"
        return $serial
    
}


Serializer @doc serializeProcs { 
serializeProcs does ...
            object -
}

Serializer instproc serializeProcs { object } {
        set serial ""

        foreach aProc [ $object info procs ] {

            append serial [ my serializeProc $object $aProc ]
        }

        return $serial
    
}


Serializer @doc serializeSingle { 
serializeSingle does ...
            object -
}

Serializer instproc serializeSingle { object } {
        set serial ""
        set associatesList $object
        set newAssociatesList {}

        foreach associate $associatesList {

            append serial [ my serializeObject $associate ]
            append serial "\n"
        }

        foreach associate $associatesList {

            set aNewObject [ my nextName ]

            if { "$object" == "$associate" } {

                set newObject $aNewObject
            }

            set serial [ string map "\{$associate\} \{$aNewObject\}" $serial ]

            lappend newAssociatesList $aNewObject
        }

        return "\{$newObject\}\n\{$newAssociatesList\}\n\{$serial\}" 
    
}


Serializer @doc serializeVar { 
serializeVar does ...
            object - 
            aVar -
}

Serializer instproc serializeVar { object aVar } {
        set serial ""

        if [ $object array exists $aVar ] {

            set value [ $object array get $aVar ]

            append serial "array set \{$aVar\} \{$value\}\n"

        } else {

            set value [ $object set $aVar ]

            #set value [ my escapeBrackets $value ]

            append serial "set \{$aVar\} \{$value\}\n"
        }

        return $serial
    
}


Serializer @doc serializeVars { 
serializeVars does ...
            object -
}

Serializer instproc serializeVars { object } {
        set serial ""

        append serial "\{$object\} eval \{\n"
        foreach aVar [ $object info vars ] {

            append serial [ my serializeVar $object $aVar ]
        }
        append serial "\}\n"
        return $serial
    
}


Serializer @doc unEscapeBrackets { 
unEscapeBrackets does ...
            data -
}

Serializer instproc unEscapeBrackets { data } {
        regsub -all {\\\\} $data {\\} data
        regsub -all {\\\\} $data {\\} data

        regsub -all {\\\{} $data "\{" data
        regsub -all {\\\}} $data "\}" data

        return $data
    
}
}


