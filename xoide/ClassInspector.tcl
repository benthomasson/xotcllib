# Created at Fri Sep 26 00:56:43 EDT 2008 by bthomass

namespace eval ::xoide {

    Class ClassInspector -superclass ::xoide::Inspector

    ClassInspector @doc ClassInspector {

        Please describe the class ClassInspector here.
    }

    ClassInspector parameter {
        inspectClass
    }

    ClassInspector instproc init { } {

        my instvar inspectClass name application

        if { ! [ ::xotcl::Object isclass $inspectClass ] } {

            next
            wm title $name "ClassInspector: $inspectClass"
            label $name.lclass -text "$inspectClass is not a class"
            pack $name.lclass
            return
        }

        next
        wm title $name "ClassInspector: $inspectClass"

        set superclass [ lindex [ $inspectClass info superclass ] 0 ]

        set sframe [ ::xoide::ScrolledFrame new -name $name.frame ]
        set frame [ $sframe frame ]

        pack [ $sframe window ] -fill both -expand yes

        label $frame.lpackage -text "Package: [ namespace qualifiers $inspectClass ]"
        bind $frame.lpackage <1> "$application inspectPackage [ namespace qualifiers $inspectClass ]"
        label $frame.lclass -text "Class: $inspectClass"
        label $frame.lsuper -text "Superclass: $superclass"
        bind $frame.lsuper <1> "$application inspectClass $superclass"

        set list [ list $frame.lpackage $frame.lclass $frame.lsuper]

        foreach instproc [ lsort -dictionary [ $inspectClass info instprocs ] ] {

            if { "" == "$instproc" } { continue }

            catch {

                label $frame.l$instproc -text "instproc $instproc [ $inspectClass info instargs $instproc ]" 
                bind $frame.l$instproc <1> "$application inspectMethod $inspectClass $instproc"
                lappend list $frame.l$instproc 
            }
        }

        eval pack $list -side top -anchor w
        raise $name
    }
}


