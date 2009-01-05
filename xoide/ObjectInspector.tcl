# Created at Fri Sep 26 00:56:39 EDT 2008 by bthomass

namespace eval ::xoide {

    Class ObjectInspector -superclass ::xoide::Inspector

    ObjectInspector @doc ObjectInspector {

        Please describe the class ObjectInspector here.
    }

    ObjectInspector parameter {
        object
    }

    ObjectInspector instproc init { } {

        my instvar object name application

        if { ! [ ::xotcl::Object isobject $object ] } {

            next
            wm title $name "ObjectInspector: $object"
            label $name.lname -text "$object is not an object"
            pack $name.lname
            return
        }

        next
        wm title $name "ObjectInspector: $object"

        set sframe [ ::xoide::ScrolledFrame new -name $name.frame ]
        set frame [ $sframe frame ]
        pack [ $sframe window ]

        label $frame.lname -text "Handle: $object"
        label $frame.lclass -text "Class: [ $object info class ]"
        bind $frame.lclass <1> "[self] inspectClass [ $object info class ]"

        set list [ list $frame.lname $frame.lclass ]

        set parent [ $object info parent ]
        if { "::" != "$parent" } {
            label $frame.lparent -text "Parent: $parent" 
            bind $frame.lparent <1> "[self] inspectObject $parent"
            lappend list $frame.lparent
        }

        foreach child [ lsort -dictionary [ $object info children ] ] {

            catch {

            label $frame.lc$child -text "Child: $child"
            bind $frame.lc$child <1> "$application inspectObject $child"
            lappend list $frame.lc$child 

            }
        }

        foreach var [ lsort -dictionary [ $object info vars ] ] {

            catch {

            if {![ $object array exists $var ]} {
                label $frame.lv$var -text "$var: [ $object set $var ]"
                lappend list $frame.lv$var 
            }

            }
        }

        foreach proc [ lsort -dictionary [ $object info procs ] ] {

            catch {

            label $name.lp$proc -text "proc $proc [ $object info args $proc ]"
            lappend list $name.lp$proc 

            }
        }

        eval pack $list -side top -anchor w
        raise $name
    }

    ObjectInspector instproc inspectObject { object } {

    }

    ObjectInspector instproc inspectClass { class } {

    }
}


