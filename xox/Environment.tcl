# Created at Wed Jun 20 09:11:04 EDT 2007 by bthomass

namespace eval ::xox {

    namespace import -force ::xotcl::*

    Class Environment -superclass ::xox::Node

    Environment # Environment {

        Environment deals with the TCLLIBPATH so you do not 
        have to.
    }

    Environment parameter {
        { tclLibPath "" }
        { packages "" }
    }

    Environment instproc loadPackages { } {

        foreach package [ my packages ] {

            my debug "loading package: $package"

            package require $package
        }
    }

    Environment instproc loadPaths { } {

        foreach path [ my tclLibPath ] {

            my debug "adding path: $path"

            my addTclLibPath $path
        }

        #my debug $::env(TCLLIBPATH)
        #my debug $::auto_path
    }

    Environment instproc addTclLibPath { path } {

        if [ info exists ::env(TCLLIBPATH) ] {
            lappend ::env(TCLLIBPATH) $path
        } else {
            set ::env(TCLLIBPATH) $path
        }


        lappend ::auto_path $path
    }

    Environment instproc captureTclLibPath { } {

        if [ info exists ::env(TCLLIBPATH) ] {
            my tclLibPath $::env(TCLLIBPATH)
        }

        set packages [ ::xox::removeIf {
            string match *::* $package
        } package [ package names ] ]

        set packages [ ::xox::removeIf {
            catch { package present $package }
        } package $packages ]

        my packages $packages
    }

    Environment instproc configureNode { } {

        #my debug "paths: [ my tclLibPath ]"
        #my debug "packages: [ my packages ]"

        my loadPaths
        my loadPackages
    }
}


