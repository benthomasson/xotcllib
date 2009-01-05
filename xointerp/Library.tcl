# Created at Sun May 11 13:45:15 EDT 2008 by bthomass

namespace eval ::xointerp {

    Class Library -superclass ::xointerp::Interpretable

    Library @doc Library {

        Please describe the class Library here.
    }

    Library parameter {

    }

    Library instproc getCommands { } {

        return [ my info methods ]
    }
}


