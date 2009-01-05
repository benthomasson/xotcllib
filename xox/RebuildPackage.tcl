# Created at Thu Jul 12 13:58:16 EDT 2007 by bthomass

package require xotcl

namespace eval ::xox {

    namespace import -force ::xotcl::*

    Class RebuildPackage -superclass ::xotcl::Object

    RebuildPackage # RebuildPackage {

        Please describe the class RebuildPackage here.
    }

    RebuildPackage parameter {
        { doTests 1 }
    }

    RebuildPackage instproc notests { } {
        my doTests 0
    }

    RebuildPackage instproc init { package } {

        set template [ ::xox::Template new ]

        package require $package 

        if { ! [ ::xotcl::Object isobject ::${package} ] } {
            puts "Could not find package object $package"
            $template createPackage ::${package} [ pwd ]
            ::${package} reload
        }

        $template buildPackage ::${package}
        if [ my doTests ] {
            $template buildTests ::${package}
            ::xounit::RunTests new $package
        }
    }
}


