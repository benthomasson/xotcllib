# Created at Thu Jun 21 14:07:00 EDT 2007 by bthomass


namespace eval ::xox {

    namespace import -force ::xotcl::*

    Class Eval -superclass ::xox::Node

    Eval # Eval {

        Evaluates a script when loaded in an XML file.
    }

    Eval parameter {
        { script "" }
    }

    Eval instproc configureNode { } {

        uplevel #0 "set ::xox::evalObject [ self ]"
        uplevel #0 [ my script ]
        uplevel #0 "catch {unset ::xox::evalObject}"
    }
}


