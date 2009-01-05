# Created at Fri Sep 26 00:56:33 EDT 2008 by bthomass

namespace eval ::xoide {

    Class PackageInspector -superclass ::xoide::Inspector

    PackageInspector @doc PackageInspector {

        Please describe the class PackageInspector here.
    }

    PackageInspector parameter {
        package
    }

    PackageInspector instproc init { } {

        my instvar name package application

        next

        wm title $name "PackageInspector: $package"

        set sframe [ ::xoide::ScrolledFrame new -name $name.frame ]
        set frame [ $sframe frame ]
        pack [ $sframe window ]

        label $frame.lname -text "Name: $package"

        set list [ list $frame.lname ]

        if [ Object isobject $package ] {

            foreach class [ lsort -dictionary [ $package info children ] ] {

                if { ![ Object isclass $class ] } { continue }

                catch {
                    label $frame.c$class -text "$class"
                    bind $frame.c$class <1> "$application inspectClass $class"
                    lappend list $frame.c$class 
                }
            }
        }

        eval pack $list -side top -anchor w
        raise $name
    }
}


