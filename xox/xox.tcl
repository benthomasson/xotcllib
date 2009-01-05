
package require XOTcl 
package provide xotcl 1.0

#Bootstrapping code for xox only
set packagePath [ file dirname [ info script ] ]

namespace eval ::xox {

    namespace import -force ::xotcl::*
}

source [ file join $packagePath Object.tcl ]
source [ file join $packagePath NotGarbageCollectable.tcl ]
source [ file join $packagePath Debugging.tcl ]
source [ file join $packagePath ObjectGraph.tcl ]
source [ file join $packagePath Reload.tcl ]
source [ file join $packagePath MetaData.tcl ]
source [ file join $packagePath Class.tcl ]
source [ file join $packagePath CVS.tcl ]
source [ file join $packagePath Package.tcl ]
::xox::Package create ::xox
::xox id {$Id: xox.tcl,v 1.13 2008/02/25 23:12:51 bthomass Exp $}
::xox loadFirst {
    ::xox::ParseArgs
    ::xox::Trace
    ::xox::Logger
    ::xox::AutoLoadSuperClass
    ::xox::Spy
    ::xox::Profiler
    ::xox::Node
    ::xox::XmlReader
    ::xox::XmlNodeReader
    ::xox::XmlNodeWriter
    ::xox::SimpleXmlNodeWriter
    ::xox::GenerateVariable
    ::xox::HigherOrderTcl
    ::xox::Environment
    ::xox::Eval
    ::xox::Tuple
    ::xox::Template
    ::xox::XmlNodeSchemaWriter
    ::xox::RebuildPackage
    ::xox::UpdatePackage
    ::xox::Script
    ::xox::TclDoc
}


::xox executables {
    makePackage
    makeTest
    makeClass
    makeTcl
    buildPkgIndex
    buildSuperPkgIndex
    xotclshell
    buildTests
    rebuildClass
    rebuildPackage
    updatePackage
}

::xox exports {
    log
}

uplevel #0 namespace import -force ::xotcl::*

::xox load

::xox @doc xox {
    
    xox is a user created library of extensions to XOTcl.
}

::xox @doc UsersGuide {

    xox is a library of extensions to XOTcl.  These extensions
    are summaried by the following classes.

    Template is a XOTcl code generation utility that produces
    files for Classes, Objects, and packages.

    Package is an extension and combination of Tcl namespace
    and Tcl packages.  Package provides an easy way to handle
    the loading and organization of Tcl packages.  Package also
    provides information about the package and its corresponding
    namespace. Package packagePath returns the location of the 
    package in the file system.  We can also query the Package
    object using introspection to find out about variables and
    procedures in the namespace using Package info vars and 
    Package info procs.

    Node, XmlNodeWriter, and XmlNodeReader allow for the serializing
    of Node objects into XML and for the deserialization back
    to Node objects from XML.  Node also provides some helper
    methods that are useful for creating new child objects in a
    node tree. These are Node createNewChild, Node addNode, and
    Node createChild.

    HigherOrderTcl provides some useful Lisp functions to Tcl. It
    has been said that Tcl is a bad implementation of Lisp.  
    HigherOrderTcl tries to improve this a bit. The procedures
    on HigherOrderTcl are callable with an ::xox prefix.  


    Object provides some extenstions to XOTcl objects.  This
    includes the Object @doc procedure to store documentation.

    Class provides some extensions to XOTcl classes. This
    includes the id and version that supports CVS ID and
    versioning.

    Script is an object that supports script generation that
    uses an Object as the scope of the script.  Script parameterize
    allows specific data values to be replaced by variables.
    This facilitates the automatic conversion of a specific script with
    hardcoded data into a general script with parameters.

}

proc ::xox::log { logLevel message } {

    set stackLevel [ info level ]

    incr stackLevel -1

    if { $stackLevel == 0 } {
        set callingProc "script:[ info script ]"
    } else {
        set callingProc [ info level $stackLevel ]
    }

    ::xox::logger log "" "" $callingProc $logLevel $message
}

