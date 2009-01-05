# Created at Mon Oct 27 18:25:35 EDT 2008 by ben

namespace eval ::xoweb {

    Class User -superclass ::xotcl::Object

    User @doc User {
        Describes the user and can hold state for that user.
    }

    User parameter {
        id
        { name Guest }
    }

    User proc getXowebUser { } {

        set id [ ::Doc_GetCookie XOWEBUSER ]

        if { "" == "$id" || ! [ my exists users($id) ] } {
            set id [ my generateUserId ]
        }

        ::Doc_SetCookie -name XOWEBUSER -value $id

        return $id
    }

    User proc generateUserId { } {

        set id [ my autoname USER ]-[ expr round( 10000 * rand() ) ]
        my set users($id) [ my new -id $id ]

        return $id
    }

    User proc getUser { id } {

        if { ! [ my exists users($id) ] } {

            set id [ my generateUserId ]
        }

        return [ my set users($id) ]
    }
}


