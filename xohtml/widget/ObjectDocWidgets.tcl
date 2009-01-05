
::xohtml::widgets {

    @@doc ObjectLink {

        Purpose: Creates a link to a class or object.

        Parameter: {
            object The object to link to
            root The root of the object documentation.
        }
    }

    defineWidget ObjectLink { object { root . } } { } {
       foreach anObject $object {
           a -href ${root}/[ ::xox::Package getPackageFromClass $anObject ]/[ string map {:: __ } $anObject.docs.html ] ' $anObject
           ' " "
       }
    }

    @@doc SeeLink {

        Purpose: Creates a link to a class or object or URL.

        Parameter: {
            object The object to link to
            root The root of the object documentation.
        }
    }

    defineWidget SeeLink { object link { root . } } { } {
           if [ my isobject $object ] {
               b {
                   ' "See: "
                   a -href ${root}/[ ::xox::Package getPackageFromClass $object ]/[ string map {:: __ } $object.docs.html ] ' $object
               }
           } else {
                if { ![ my exists link ] } {
                    set link $object
                }
               b {
                   ' "See: "
                   a -href $link ' $object
               }
           }
    }

    defineWidget Synopsis { object procName } { } {

            h4 ' Synopsis 
            set nonposargs ""
            foreach nonposarg [ $object info instnonposargs $procName ] {
                append nonposargs "\[[ lindex ${nonposarg} 0 ]\] "
            }
            set posargs ""
            foreach posarg [ $object info instargs $procName ] {
                if { [ llength $posarg ] == 1 }  {
                    append posargs "${posarg} "
                } else {
                    append posargs "\[ [ lindex ${posarg} 0 ] \]"
                }
            }
            pre ' "$procName $nonposargs $posargs"
    }

    defineWidget MetaDoc { object token } { } {
        set doc [ $object getDoc $token ]
        if { "" != "[ string trim $doc ]" } {
            div -class text {
                '' $doc
            }
        }
        set example [ $object getExample $token ] 
        if { "" != "[ string trim $example ]" } {
            div -class procedure {
                h4 ' Example
                pre '' $example
            }
        }
    }

    @@doc ParameterDoc {

        Purpose: Creates a document for a class parameter.

        Parameter: {
            object The class object
            parameter The parameter definition 
        }
    }

    defineWidget ParameterDoc { object parameter } { } {
        set name [ lindex $parameter 0 ]
        if { [ llength $parameter ] > 1 } {
            set default [ lindex $parameter 1 ]
        }
        a -name "$name"
        b ' $name 
        ' " - "
        if [ info exists default ] {
            ' " (optional, defaults to: {$default})"
            ' " - "
        }
        , $object getParameter $name
    }

    @@doc ProcDoc {

        Purpose: Creates a document for an object procedure

        Parameter: {
            object An object
            procName The name of the procedure
        }
    }

    defineWidget ProcDoc { object procName } { } {
        div -class procedure {
            a -name "$procName"
            h3 -class name ' $procName 
            pre '' $object proc $procName [ $object info nonposargs $procName ] [ $object info args $procName ] [ $object info body $procName ]
        }
    }

    @@doc ObjectDoc {

        Purpose: Creates a document for an object including its variables and its procedures.

        Parameter: {
            object The object to document.
        }
    }

    defineWidget ObjectDoc { object } {
        ObjectLink oLink {
            root ..
        }
    } {
        div -class object {
            h1 -class name ' $object
            h3 { ' "Is an instance of "; use oLink -object [ $object info class ] }
            if { [ llength [ $object info vars ] ] != 0 } {
                h2 ' Variables
                ul foreach var [ $object info vars  ] {
                    if { "$var" == "#" } { continue }
                    if { [ string match __* $var ] } { continue }
                    if [ $object array exists $var ] {
                        foreach index [ $object array names $var ] {
                            li  {
                                ' ${var}(${index}) =
                                catch {
                                ' "{[ $object set ${var}(${index})]}"
                                }
                            }
                        }
                    } else {
                        li {
                            ' $var =
                            catch {
                            ' " {[ $object set $var]}"
                            } 
                        }
                    }
                }
            }
            if { [ llength [ $object info procs ] ] != 0 } {
                h2 ' Procedures
                ul foreach procName [ lsort [ $object info procs ] ] {
                    li a -href "#$procName" {
                        '' $procName 
                    }
                }
                foreach procName [ lsort [ $object info procs ] ] {
                    new ProcDoc -object $object -procName $procName
                    br
                }
            }
        }
    }

    @@doc MethodDoc {

        Purpose: Creates a document for a class method.

        Parameter: {
            object The class where the method resides.
            procName The name of the method.
            doCode Flag to turn on and off including the method code.
        }
    }

    defineWidget MethodDoc { object procName { doCode 1 }} {
        SeeLink sLink {
            root ..
        }
        Synopsis aSynopsis {

        }
    } {
        div -class procedure {
            a -name "$procName"
            h3 -class name '' $procName
            new MetaDoc -object $object -token $procName 
            use aSynopsis -object "$object" -procName "$procName"
            if { [ llength [ $object info instnonposargs $procName ] ] != 0 || [ llength [ $object info instargs $procName ] ] != 0 } {
            h4 ' Arguments
                ul {
                    foreach arg [ $object info instnonposargs $procName ] {
                        li { 
                            b ' ${arg} 
                            ' " - [ $object getArgument $procName $arg ]"
                        }
                    }
                    foreach arg [ $object info instargs $procName ] {
                        li { 
                            b ' $arg 
                            ' " - [ $object getArgument $procName $arg ]"
                        }
                    }
                }
            }
            if { "none" != "[ string trim [ $object getReturn $procName ] ]" } {
                h4 ' Returns
                ul foreach return [ $object getReturn $procName ] {
                    li ' $return
                }
            }
            if $doCode {
                h4 ' Code
                pre '' "$object instproc $procName {[ $object info instnonposargs $procName ]} {[ $object info instargs $procName ]} {[ $object info instbody $procName ]}"
            }
            if { "" != "[ $object getExample $procName ]" } {
                h4 ' Example
                pre '' [ $object getExample $procName ]
            }
            foreach see [ $object getSee $procName ] {
               use sLink -object $see 
               br
            }
        }
    }

    @@doc ClassDoc {

        Purpose: Creates a document for a class including its parameters and methods.

        Parameter: {
            object The class to document
        }
    }

    defineWidget ClassDoc { object } {
        ObjectLink oLink {
            root ..
        }
        MethodDoc aMethodDoc {
        }
    } {
        div -class object {
            h1 -class name ' $object
            h3 { 
                ' "Is an instance of "
                use oLink -object [ $object info class ] 
                ' " and is a subclass of "
                use oLink -object [ $object info superclass ] 
            }
            set className [ namespace tail $object ]
            new MetaDoc -object $object -token $className 
            if { "" != "[ $object getExample $className  ]" } {
                div -class procedure {
                    h4 ' Example
                    pre '' [ $object getExample $className ]
                }
            }
            if { [ llength [ $object info parameter ] ] != 0 } {
                h2 ' Parameters
                ul foreach param [ $object info parameter  ] {
                    li new ParameterDoc -object $object -parameter $param
                }
            }
            if { [ llength [ $object info instprocs ] ] != 0 } {
                h2 ' Methods
                ul foreach procName [ lsort [ $object info instprocs ] ] {
                    li a -href "#$procName" {
                        '' $procName 
                    }
                }
                foreach procName [ lsort [ $object info instprocs ] ] {
                    new MethodDoc -object $object -procName $procName
                    br
                }
            }
            if { [ llength [ $object info procs ] ] != 0 } {
                h2 ' Procedures
                ul foreach procName [ lsort [ $object info procs ] ] {
                    li a -href "#$procName" {
                        ' $procName 
                    }
                }
                foreach procName [ lsort [ $object info procs ] ] {
                    new ProcDoc -object $object -procName $procName
                    br
                }
            }
        }
    }

    defineWidget PackageDoc { package } { } {

        h1 -class name { 
            ' Package 
            ' " "
            a -href __$package.docs.html ' $package
        }
        if [ my isobject ::${package} ] {
            new MetaDoc -object ::${package} -token $package 
        }
        h2 ' Classes
        ul foreach class [ ::xox::ObjectGraph findAllInstances ::xotcl::Class ::${package} ] {
           li a -href [ string map {:: __ } $class.docs.html ] ' $class
        }
        h2 ' Objects
        ul foreach object [ ::xox::ObjectGraph findAllInstances ::xotcl::Object ::${package} ] {
           if [ $object hasclass ::xotcl::Class ] { continue }
           if [ $object hasclass ::xotcl::Attribute ] { continue }
           if { "slot" == "[ namespace tail $object ]" } { continue }
           if { [ string match ::xotcl::__* $object ] } { continue }
           li a -href [ string map {:: __ } $object.docs.html ] ' $object
        }
    }

    defineWidget SimpleWidgetDoc { widget } { } {

        set widgetName [ namespace tail $widget ]
        h1 -class name ' "$widgetName"
        h4 ' "$widgetName is a SimpleWidget"
        new MetaDoc -object $widget -token $widgetName
        if { "" != [ $widget info parameter ] } {
            h2 -class name ' Parameters
            ul foreach parameter [ $widget info parameter ] {
                li new ParameterDoc -object $widget -parameter $parameter
            }
        }
        if { "" != "[ string trim [ $widget set modelCode ] ]" } {
            div -class procedure {
                h2 -class name ' Model Code
                pre ,, $widget set modelCode
            }
        }
        if { "" != "[ string trim [ $widget set htmlWidgetCode ] ]" } {
            div -class procedure {
                h2 -class name ' HTML Widget Code
                pre ,, $widget set htmlWidgetCode
            }
        }
    }

        
}
