# Created at Thu Sep 25 23:09:32 EDT 2008 by bthomass

namespace eval ::xoide {

    Class TopLevel -superclass ::xoide::TkObject

    TopLevel @doc TopLevel {

        Please describe the class TopLevel here.
    }

    TopLevel parameter {
        { name . }
    }

    TopLevel instproc init { } {

        my instvar name

        package require Tk

        catch { toplevel $name }
        my destroyChildren
    }

    TopLevel instproc destroyChildren { } {

        my instvar name

        foreach child [ winfo children $name ] {

            destroy $child 
        }
    }

    TopLevel instproc destroy { } {

        my instvar name

        my destroyChildren 

        if { "." != "$name" } {
            destroy $name
        }

        next
    }
}


