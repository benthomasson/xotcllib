# Created at Fri Sep 26 00:57:36 EDT 2008 by bthomass

namespace eval ::xoide {

    Class MethodInspector -superclass ::xoide::Inspector

    MethodInspector @doc MethodInspector {

        Please describe the class MethodInspector here.
    }

    MethodInspector parameter {
        inspectClass
        method
    }

    MethodInspector instproc init { } {

        my instvar name inspectClass method application

        next
        wm title $name "MethodInspector: $inspectClass $method"

        set pane [ panedwindow $name.p -orient vertical -showhandle 1 ]

        label $name.package -text "Package: [ namespace qualifiers $inspectClass ]"
        label $name.class -text "Class: $inspectClass"
        label $name.method -text "Method: $method"
        set stDoc [ ::xoide::ScrolledText new $pane.doc -width 100 -height 20 -name Doc ]
        set stCode [ ::xoide::ScrolledText new $pane.code -width 100 -height 10 -name Code ]
        bind $name.package <1> "$application inspectPackage [ namespace qualifiers $inspectClass ]"
        bind $name.class <1> "$application inspectClass $inspectClass"

        set doc [ $stDoc text ]
        set code [ $stCode text ]

        $doc insert insert [ $inspectClass get# $method ]
        $code insert insert "\n\n$inspectClass instproc $method \{ [ $inspectClass info instargs $method  ] \} \{\n"
        $code insert insert [ $inspectClass info instbody $method ]
        $code insert insert "\n\}"

        set list [ list $name.package $name.class $name.method ]
        eval pack $list -side top -anchor w
        pack $pane -expand yes -fill both
        $pane add $pane.doc $pane.code
        raise $name
    }
}


