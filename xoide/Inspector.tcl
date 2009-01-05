# Created at Thu Sep 25 23:47:42 EDT 2008 by bthomass

namespace eval ::xoide {

    Class Inspector -superclass ::xoide::TopLevel

    Inspector @doc Inspector {

        Please describe the class Inspector here.
    }

    Inspector parameter {
        application
    }

    Inspector instproc init { } {

        my instvar name

        next

        wm minsize $name 40 5
        $name configure -borderwidth 10

        menu $name.menubar -tearoff 0
        $name configure -menu $name.menubar
        foreach m { File } {
            set $m [ menu $name.menubar.m$m -tearoff 0]
            $name.menubar add cascade -label $m -menu $name.menubar.m$m
        }

        $File add command -label Close -command "wm withdraw $name"

        wm deiconify $name
    }
}


