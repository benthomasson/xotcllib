# Created at Fri Sep 26 11:00:44 EDT 2008 by bthomass

namespace eval ::xox {

    Class NullObject -superclass ::xotcl::Object

    NullObject @doc NullObject {

        Please describe the class NullObject here.
    }

    NullObject parameter {

    }

    NullObject instproc unknown { args } {
        puts "Called [ self ] $args"
    }
}


