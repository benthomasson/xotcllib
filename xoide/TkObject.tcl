# Created at Thu Sep 25 23:13:44 EDT 2008 by bthomass

namespace eval ::xoide {

    Class TkObject -superclass ::xotcl::Object

    TkObject @doc TkObject {

        Please describe the class TkObject here.
    }

    TkObject parameter {
        name
    }

    TkObject instproc widgetCommand { args } {

        my instvar name
        return [ eval $name $args ]
    }

    TkObject instproc getChildName { childName } {

        my instvar name

        if { "." == "$name" } {

            return "${name}${childName}"

        }  else {

            return "${name}.${childName}"
        }
    }

    TkObject instproc destroyChildren { } {

        my instvar name

        foreach child [ winfo children $name ] {

            destroy $child 
        }
    }

    TkObject instproc destroy { } {

        my instvar name

        my destroyChildren 

        if { "." != "$name" } {
            destroy $name
        }

        next
    }
}


