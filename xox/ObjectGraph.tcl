


namespace eval ::xox {
    
    namespace import -force ::xotcl::*

    Class ObjectGraph 

    ObjectGraph # ObjectGraph {

        ObjectGraph is a library of utility procedures that assist 
        in working with object-graphs and class-trees. 

        To use these procedures you do not need to make a new
        instance of ObjectGraph.  Just call them directly from
        the class.

        Example:

        ::xox::ObjectGraph findAllInstances ::xotcl::Object

        This returns a list of all objects in the process.
    }

    ObjectGraph # findAllInstances {

        Finds all instances of a class and any of its subclasses. This
        optionally can find the instances that are in a certain namespace.  
    }

    ObjectGraph proc findAllInstances { class { namespace "" } } {

        set instances ""

        foreach subclass [ my findAllSubClasses $class ] {

            eval "lappend instances [ $subclass info instances "$namespace*" ]"
        }

        return [ lsort -unique $instances ]
    }

    ObjectGraph # findAllSubClasses {

        Finds all subclasses of a class and the subclasess
        of those subclasses.
    }

    ObjectGraph proc findAllSubClasses { class } {

        set allSubClasses ""

        lappend subClasses $class

        while { [ llength $subClasses ] != 0 } {

            set currentClass [ lindex $subClasses 0 ]

            set subClasses [ lreplace $subClasses 0 0 ]

            if { "$currentClass" == "" } continue

            lappend allSubClasses $currentClass

            eval "lappend subClasses [ $currentClass info subclass ]"
        }

        return [ lsort -unique $allSubClasses ]
    }

    ObjectGraph # findAllMethods {

        Finds all methods on an object except for methods in ::xotcl::Object
    }

    ObjectGraph proc findAllMethods { object } {

        set methods [ $object info methods ]

        set o [ Object new ]

        set removeMethods [ $o info methods ]

        $o destroy

        set methods [ lsort -unique [ ::xox::removeIf {
            expr { [ lsearch $removeMethods $method ] != -1 }
        } method $methods ] ]

        return [ concat $methods {@doc} ]
    }

    ObjectGraph # getCode {

        Generates the xotcl code from an object. This
        code contains all the state of the object and
        all relationship of that object.  Generates
        object specific procs, mixins, filters, forwarders,
        variables, and class relationships.  Also generates
        instprocs, instmixins, instfilters, instforwarders,
        for classes.
    }

    ObjectGraph proc getCode { object } {

        set namespace [ namespace qualifiers $object ]
        set objectName [ namespace tail $object ]

        set code ""

        append code "namespace eval $namespace \{\n\n"

        if [ $object isclass ] {

        append code "[ $object info class ] $objectName -superclass \{[ $object info superclass ]\}\n\n"

        }

        foreach var [ lsort [ $object info vars ] ] {

            if [ $object array exists $var ] {

                foreach arrayName [ $object array names $var ] {

                    set value [ $object set "$var\($arrayName\)" ]
                    append code "$objectName set \{$var\($arrayName\)\} \{$value\}\n"
                }

                continue
            }

            set value [ $object set $var ]
            append code "$objectName set \{$var\} \{$value\} \n"
        }

        foreach proc [ lsort [ $object info procs ] ] {

            append code "$objectName proc $proc "
            if { "" != "[ $object info nonposargs $proc ]" } {
                append code "\{ [ $object info nonposargs $proc ] \} "
            }
            append code "\{ [$object info args $proc] \} \{"
            append code "[$object info body $proc]\n\}\n"
        }

        foreach filter [ $object info filter ] {

            append code "$objectName filter $filter\n"
        }

        foreach mixin [ $object info mixin ] {

            append code "$objectName mixin add $mixin\n"
        }


        if [ $object isclass ] {

        if { "" != "[ $object info parameter ]" } {

        append code "$objectName parameter \{\n"

        foreach parameter [ lsort [ $object info parameter ] ] {

            append code "            \{$parameter\} \n"
        }

        append code "\}\n"

        }

        foreach instmixin [ $object info instmixin ] {

            append code "$objectName instmixin add $instmixin\n"
        }

        append code "\n"

        foreach instproc [ lsort [ $object info instprocs ] ] {

            append code "$objectName instproc $instproc "
            if { "" != "[ $object info instnonposargs $instproc ]" } {
                append code "\{ [ $object info instnonposargs $instproc] \} "
            }
            append code "\{ [$object info instargs $instproc] \} \{"
            append code "[$object info instbody $instproc]"
            append code "\}\n"
            append code "\n"
        }

        if { "" != "[ $object info instfilter ]" } {

        append code "$objectName instfilter \{[ $object info instfilter]\}\n"
        }

        append code "\n"


        }

        append code "\}\n"

        return $code
    }

    ObjectGraph # allClassParameters {

        Finds all the parameters of a class and its
        superclasses.
    }

    ObjectGraph proc allClassParameters { object } {

        set parameters ""

        foreach parameter [ $object info parameter ] {

            set parameter [ lindex $parameter 0 ]
            lappend parameters $parameter
        }

        foreach class [ $object info heritage ] {

            foreach parameter [ $class info parameter ] {

                set parameter [ lindex $parameter 0 ]
                lappend parameters $parameter
            }
        }

        return [ lsort -unique $parameters ]
    }

    ObjectGraph # allParameters {

        Finds all the parameters of an object from
        its class and all superclasses.
    }

    ObjectGraph proc allParameters { object } {

        set parameters ""

        foreach class [ $object info precedence ] {

            foreach parameter [ $class info parameter ] {

                set parameter [ lindex $parameter 0 ]
                lappend parameters $parameter
            }
        }

        return [ lsort -unique $parameters ]
    }

     ObjectGraph # getInstprocs {

         Finds all the instprocs that match a certain pattern 
         from a certain class and all its superclasses. The
         default pattern is * (everything).
     }

     ObjectGraph proc getInstprocs { object { pattern "*" } } {

         set instprocs [ $object info instprocs $pattern ]

         foreach instmixin [ $object info instmixin ] {

             eval "lappend instprocs [ $instmixin info instprocs $pattern ]"
         }

         foreach class [ $object info heritage ] {

             eval "lappend instprocs [ $class info instprocs $pattern ]"

             foreach instmixin [ $class info instmixin ] {

                 eval "lappend instprocs [ $instmixin info instprocs $pattern ]"
             }
         }

         return [ lsort -unique $instprocs ]
     }

     ObjectGraph # getMixins {

         Finds all the mixins of an object,
         the instmixins of its class, and
         all its superclasses.
     }

     ObjectGraph proc getMixins { object } {

         set mixins [ $object info mixin ]

         set classes [ $object info class ]

         eval "lappend classes [ [ $object info class ] info heritage ]"

         foreach class $classes {

             eval "lappend mixins [ $class info instmixin ]"
         }

         return $mixins
     }

     ObjectGraph # getInstMixins {

         Finds all the instmixins of a class and
         all its superclasses.
     }

     ObjectGraph proc getInstMixins { object } {

         set mixins [ $object info instmixin ]

         set classes [ $object info heritage ]

         foreach class $classes {

             eval "lappend mixins [ $class info instmixin ]"
         }

         return $mixins
     }

     ObjectGraph # findFirstComment { 

         Seaches the class heirarchy for the first occurance
         of a comment for a certain method or class name.
     }

     ObjectGraph proc findFirstComment { object key } {

         if [ my isclass $object ] {

             foreach class [ concat $object [ $object info heritage ] ] {
                 if { [ $class exists "#($key)" ] } { 

                     return [ $class get# $key ]
                 }
             }

             return ""
         } else {

             if { [ $object exists "#($key)" ] } { 

                 return [ $object get# $key ]
             }

             foreach class [ $object info precedence ] {

                 if { [ $class exists "#($key)" ] } { 

                     return [ $class get# $key ]
                 }
             }

             return ""
         }
     }

     ObjectGraph # findFirstImplementation {

         Finds the first class that implements a method on an
         object.  If the object is a class this method finds
         the first superclass that implements the method.
     }

     ObjectGraph proc findFirstImplementation { object method } {

         if [ $object isclass ] {

             foreach class [ concat $object [ $object info heritage ] ] {

                 if { [ lsearch -exact [ $class info instcommands ] $method ] != -1 } { 
                     return $class
                 }
             }

             return ""
         } else {

             if { [ lsearch -exact [ $object info commands ] $method ] != -1 } { 

                 return $object
             }

             foreach class [ $object info precedence ] {

                 if { [ lsearch -exact [ $class info instcommands ] $method ] != -1 } { 
                     return $class
                 }
             }

             return ""
         }
     }

     ObjectGraph # findFirstImplementationClass { 

         Finds the first implementation of a method on 
         the class hierarchy for an object.

     }

     ObjectGraph proc findFirstImplementationClass { object method } {

         if [ $object isclass ] {

             foreach class [ concat $object [ $object info heritage ] ] {

                 if { [ lsearch -exact [ $class info instcommands ] $method ] != -1 } { 
                     return $class
                 }
             }

             return ""
         } else {

             foreach class [ $object info precedence ] {

                 if { [ lsearch -exact [ $class info instcommands ] $method ] != -1 } { 
                     return $class
                 }
             }

             return ""
         }
     }

    ObjectGraph # getAllAssociates {

        Finds all objects that are associates of an object in
        an object-graph.
        This finds all objects that are not classes that
        are referenced from a certain object or referenced
        by objects referenced from the first object. An associate
        object-graph is a set of objects that are reachable
        by traversing references from object to object starting
        with one object.
    }

    ObjectGraph proc getAllAssociates { object } {

        set toFindAssociates $object
        set foundAssociates ""

        while { [ llength $toFindAssociates ] != 0 } {

            set current [ lindex $toFindAssociates 0 ]

            set toFindAssociates [ lreplace $toFindAssociates 0 0 ]

            if { [ lsearch -sorted -increasing $foundAssociates $current ] == -1 } {

                lappend foundAssociates $current
                set foundAssociates [ lsort $foundAssociates ]
            }

            set currentAssociates [ ::xotcl::my getAssociates $current ]

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

    ObjectGraph # getAssociates {

        Finds all objects that are associates of an object.
        This finds all objects that are not classes that
        are referenced from a certain object.
    }

    ObjectGraph proc getAssociates { object } {

        set associates $object

        foreach var [ $object info vars ] {

            if [ $object array exists $var ] {

                foreach name [ $object array names $var ] {

                    set values [::xotcl::my flattenList [ $object array get $var ]]

                    ::xotcl::my findObjectsInList associates $values
                }

            } else {

                set values [::xotcl::my flattenList [ $object set $var ]]
                ::xotcl::my findObjectsInList associates $values

            }
        }

        return $associates
    }

    ObjectGraph # findObjectsInList {

        Finds all objects that the list.  This list may
        have inner lists.  All objects will be found in any
        inner list.
    }

    ObjectGraph proc findObjectsInList { objectListName aList } {

        upvar $objectListName objects

        foreach element [ split $aList " " ] {

            if { "" == "$element" } { continue }

            #puts "Element: $element Element"
            #puts [ string first "::" $element ]
            #puts [  ::xotcl::Object isobject $element ]

            if [ ::xotcl::Object isobject $element ] {

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

    ObjectGraph # flattenList {

        Removes all curly brackets from a list.
    }

    ObjectGraph proc flattenList { aList } {

        regsub -all {\{} $aList "" aList
        regsub -all {\}} $aList "" aList

        return $aList
    }

    ObjectGraph # hasSuperclass {

        Predicate that tests whether or not a class has a superclass
        anywhere in its parent hierarchy.
    }

    ObjectGraph proc hasSuperclass { class superclass } {

        if { "$superclass" == "$class" } {

            return 1
        }

        foreach super [ $class info superclass ] {

            if [ my hasSuperclass $super $superclass ] {

                return 1
            }
        }

        return 0
    }

    ObjectGraph proc instanceof { object class } {

        if { ! [ ::xotcl::Object isobject $object ] } { return 0 }

        return [ my hasSuperclass [ $object info class ] $class ]
    }

    ObjectGraph proc hasParentWithClass { object class } {

        set parent [ $object info parent ]

        if { ! [ my isobject $parent ]  } { return 0 }

        if [ $parent hasclass $class ] {

            return 1
        } else {

            my hasParentWithClass $parent $class
        }
    }

    ObjectGraph proc getShortComment { object method } {
        set comment [ ::xox::ObjectGraph findFirstComment $object $method ]
        return [ string trim [ lindex [ split $comment "."  ] 0 ] ]
    }

    ObjectGraph proc copyObjectVariables { from to { except "" } } {

        foreach var [ $from info vars ] {

            if { [ lsearch -exact $except $var ] != -1 }  { continue }

            if [ $from array exists $var ] {
                if { [ $to exists $var ] && ! [ $to array exists $var ] } { catch { $to unset $var } }
                foreach index [ $from array names $var ] {
                    $to set ${var}(${index}) [ $from set ${var}(${index}) ]
                }
            } elseif [ $from exists $var ] {
                if [ $to array exists $var ] { $to unset $var }
                $to set $var [ $from set $var ]
            } else {
                #do nothing for declared variables
            }
        }
    }

    ObjectGraph proc copyUnsetObjectVariables { from to { except "" } } {

        foreach var [ $from info vars ] {

            if { [ lsearch -exact $except $var ] != -1 }  { continue }

            if [ $from array exists $var ] {
                if [ $to exists $var] { continue }
                foreach index [ $from array names $var ] {
                    $to set ${var}(${index}) [ $from set ${var}(${index}) ]
                }
            } else {
                if [ $to array exists $var ] { continue }
                $to set $var [ $from set $var ]
            }
        }
    }

    ObjectGraph proc copyScopeVariables { to { except "" } } {

        foreach var [ uplevel [ list info vars ] ] {

            if { [ lsearch -exact $except $var ] != -1 }  { continue }

            if [ uplevel [ list array exists $var ] ] {
                if { [ $to exists $var ] && ! [ $to array exists $var ] } { catch { $to unset $var } }
                foreach index [ uplevel [ list array names $var ] ] {
                    $to set ${var}(${index}) [ uplevel [ list set ${var}(${index}) ] ]
                }
            } elseif [ uplevel [ list info exists $var ] ] {
                if [ $to array exists $var ] { catch { $to unset $var } }
                $to set $var [ uplevel [ list set $var ] ]
            } else {        
                #do nothing for declared variables that are not set.
            }
        }
    }

    ObjectGraph proc copyObjectVariablesToScope { from { except "" } } {

        foreach var [ $from info vars ] {

            if { [ lsearch -exact $except $var ] != -1 }  { continue }

            if [ $from array exists $var ] {
                if [ uplevel [ list info exists $var ] ] { uplevel [ list unset $var ] }
                foreach index [ $from array names $var ] {
                    uplevel [ list set ${var}(${index}) [ $from set ${var}(${index}) ] ]
                }
            } elseif [ $from exists $var ] {
                if [ uplevel [ list array exists $var ] ] { uplevel [ list unset $var ] }
                uplevel [ list set $var [ $from set $var ] ]
            } else {
                #do nothing for declared variables
            }
        }
    }
}


