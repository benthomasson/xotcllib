# Created at Mon Sep 29 14:30:37 EDT 2008 by ben

namespace eval ::xoide {

    Class TestRunner -superclass ::xoide::TopLevel

    TestRunner @doc TestRunner {

        Please describe the class TestRunner here.
    }

    TestRunner parameter {
        name
        packageFrame
        classFrame
        methodFrame
        formatter
        console 
    }

    TestRunner instproc init { } {

        my instvar name packageFrame classFrame methodFrame console

        my formatter [ ::xounit::TestResultsTextFormatter new ]

        tk_setPalette gray

        next

        wm minsize $name 30 5
        wm title $name "Test Runner"

        set menubar [ menu ${name}.menubar -tearoff 0 ]
        $name configure -menu $menubar
        foreach m { File Exec Doc } {
            set $m [ menu $menubar.m$m -tearoff 0 ]
            $menubar add cascade -label $m -menu $menubar.m$m
        }

        set selectors [ frame [ my getChildName selectors ] ]
        set console [ ::xoide::ScrolledText new [ my getChildName console ] -width 40 -height 20 -name Console ]

        pack $selectors [ $console frame ] -fill both -expand yes

        set packageFrame [ ::xoide::ScrolledFrame new -name $selectors.package ]
        set classFrame [ ::xoide::ScrolledFrame new -name $selectors.class ]
        set methodFrame [ ::xoide::ScrolledFrame new -name $selectors.method ]

        set plist ""

        foreach package [ ::xox::Package getAllPackageNames ] {

            lappend plist [ label [ $packageFrame frame ].$package -text $package ]
            bind [ $packageFrame frame ].$package <1> "[ self ] updateClassList $package"
        }
        eval pack $plist -side top -anchor w

        pack [ $packageFrame window ] [ $classFrame window ] [ $methodFrame window ] -side left -fill both -expand yes

    }

    TestRunner instproc updateClassList { package } {

        my instvar packageFrame classFrame methodFrame

        $classFrame destroyFrameChildren
        $methodFrame destroyFrameChildren

        set namespace ::${package}
        set clist ""

        foreach class [ ::xox::ObjectGraph findAllSubClasses ::xounit::TestCase ] {

            if { [ string first $namespace $class ] != 0 } { continue }

            lappend clist [ label [ $classFrame frame ].$class -text $class ]
            bind [ $classFrame frame ].$class <1> "[ self ] updateMethodList $class"
        }

        if { "$clist" != "" } {
            eval pack $clist -side top -anchor w
            $classFrame see [ lindex $clist 0 ]
        }

        #eval pack $flist -side top -fill both -expand yes
    }

    TestRunner instproc updateMethodList { class } {

        my instvar packageFrame classFrame methodFrame

        $methodFrame destroyFrameChildren

        set flist ""

        foreach method [ $class info instprocs test* ] {

            lappend flist [ label [ $methodFrame frame ].$method -text $method ]
            bind [ $methodFrame frame ].$method <1> "[ self ] runTest $class $method"
        }

        if { "$flist" != "" } {
            eval pack $flist -side top -anchor w
            $methodFrame see [ lindex $flist 0 ]
        }
    }
    
    TestRunner instproc runTest { class method } {

        my instvar formatter console

        set text [ $console text ]

        $text delete 1.0 end 
        $text insert insert "Running $class $method..."

        rename ::puts ::oldputs

        proc ::puts { args } [ subst {
            eval [ self ] puts \$args
        } ]

        set instance [ $class new ]

        set result [ $instance newResult ]

        cd [ [ ::xox::Package getPackageObject $class ] packagePath ]

        $instance runTest $result $method

        $formatter printResults $result

        rename ::puts {}
        rename ::oldputs ::puts
    }

    TestRunner instproc puts { args } {

        my instvar console

        if { [ llength $args ] == 1 } {

            set args [ lindex $args 0 ]
        } else {
            set args [ lindex $args 1 ]
        }

        set text [ $console text ]
        $text insert insert $args
    }
}


