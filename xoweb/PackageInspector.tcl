# Created at Sat Oct 25 17:39:48 EDT 2008 by ben

namespace eval ::xoweb {

    ::xoweb::ApplicationClass create PackageInspector -superclass ::xoweb::Application

    PackageInspector @doc PackageInspector {

        Please describe the class PackageInspector here.
    }

    PackageInspector parameter {

    }

    PackageInspector instproc initialLoad { -package } {

        my instvar root url

        #::xoweb reload

        if { ! [ info exists package ] } {

            return [ ::xoweb::makePage { } { 
                html {
                    new XowebCSS
                    div -class object {
                        h1 ' Package Inspector
                        form -action "" -method GET {
                            input -name "package" -type text -value ""
                            input -value "Type a Package" -type submit
                        }

                        hr 

                        h3 ' Select a Package

                        ul foreach package [ lsort -dictionary [ package names ] ] {

                            li a -href "?package=[ cleanUpLink $package ]" ' $package
                        }
                    }
                }
            } ]
        }

        if [ catch { package present $package } ] {

            return [ ::xoweb::makePage { } {

                html {
                    new XowebCSS -width 80% 
                    div -class object {

                        h1 ' Package not loaded: $package
                        a -href "$url" '  Return
                    }
                }
            } ]
        }

        return [ ::xoweb::makePage { } {

            html {
                new XowebCSS -width 80% 
                div -class object {

                    set namespace ::${package}

                    if [ my isobject $namespace ] {

                        h1 ' XOTcl Package: $package

                        h2 ' Variables

                        ul foreach var [ $namespace info vars ] {
                            li { 
                                b ' $var 
                                catch {
                                    ' " = {[$namespace set $var]}"
                                }
                            }
                        }

                        h2 ' Procedures

                        ul foreach proc [ $namespace info procs ] {
                            li b ' $proc
                        }

                        h2 ' Classes

                        ul foreach class [ ::xox::ObjectGraph findAllInstances ::xotcl::Class $namespace ] {
                            li a -href "$root/classinspector?object=$class" ' $class 
                        }

                        h2 ' Objects

                        ul foreach object [ ::xox::ObjectGraph findAllInstances ::xotcl::Object $namespace ] {
                            if [ $object hasclass ::xotcl::Class ] { continue }
                            if [ $object hasclass ::xotcl::Attribute ] { continue }
                            if [ string match *slot $object ] { continue }
                            if [ string match ::xotcl::__* $object ] { continue }
                            li a -href "$root/objectinspector?object=$object" ' $object
                        }

                    } else {

                        h1 ' Tcl Package: $package

                        h2 ' Variables

                        ul foreach var [ ::info vars ${namespace}::* ] {
                            li { 
                                b ' $var 
                                catch {
                                    ' " = {[$namespace set $var]}"
                                }
                            }
                        }

                        h2 ' Procedures

                        ul foreach proc [ info procs ${namespace}::* ] {
                            li b ' $proc
                        }

                        h2 ' Classes

                        ul foreach class [ ::xox::ObjectGraph findAllInstances ::xotcl::Class $namespace ] {
                            li a -href "$root/classinspector?object=$class" ' $class 
                        }

                        h2 ' Objects

                        ul foreach object [ ::xox::ObjectGraph findAllInstances ::xotcl::Object $namespace ] {
                            if [ $object hasclass ::xotcl::Class ] { continue }
                            if [ $object hasclass ::xotcl::Attribute ] { continue }
                            if [ string match *slot $object ] { continue }
                            if [ string match ::xotcl::__* $object ] { continue }
                            li a -href "$root/objectinspector?object=$object" ' $object
                        }

                    }
                }
            }
        } ]
    }
}


