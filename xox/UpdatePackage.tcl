# Created at Thu Jul 12 13:58:16 EDT 2007 by bthomass

package require xotcl

namespace eval ::xox {

    namespace import -force ::xotcl::*

    Class UpdatePackage -superclass ::xotcl::Object

    UpdatePackage # UpdatePackage {

        Please describe the class UpdatePackage here.
    }

    UpdatePackage parameter {
        { doTests 1 }
    }

    UpdatePackage instproc notests { } {
        my doTests 0
    }

    UpdatePackage instproc init { package } {

        set template [ ::xox::Template new ]

        package require $package 

        if { ! [ ::xotcl::Object isobject ::${package} ] } {
            error "Could not find package object $package"
        }

        $template writePackageFile ::${package}

        ::${package} buildPkgIndex
    }
}


