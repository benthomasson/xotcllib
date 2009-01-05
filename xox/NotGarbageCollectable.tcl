# Created at Thu Jun 07 13:56:32 EDT 2007 by bthomass

namespace eval ::xox {

    namespace import -force ::xotcl::*

    Class NotGarbageCollectable -superclass ::xotcl::Object

    NotGarbageCollectable instproc garbageCollect { } {

        #Do not garbage collect me
    }
}


