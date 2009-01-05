# Created at Thu Jun 07 13:16:38 EDT 2007 by bthomass

namespace eval ::xox {

    namespace import -force ::xotcl::*

    Class GarbageCollector -superclass ::xotcl::Object

    GarbageCollector # GarbageCollector {

        A very naive and very primitive garbage collector for XOTcl.
    }

    GarbageCollector proc destroyAllObjects { } {

        set all [ ::xox::ObjectGraph findAllInstances ::xotcl::Object ]

        set all [ ::xox::removeIf {
            expr {  [ string match "::xotcl*" $object ] ||
                    [ string match "::xox*" $object ] || 
                    [ string match "::xoexception*" $object ] || 
                    [ string match "::xounit*" $object ] } 
        } object $all ]

        foreach object $all {

            catch { $object garbageCollect }
        }

        my destroyAllTemporaryObjects
    }

    GarbageCollector proc destroyAllTemporaryObjects { } {

        set all [ ::xox::ObjectGraph findAllInstances ::xotcl::Object ]

        set all [ ::xox::removeIfNot {
            string match "::xotcl::__#*" $object } object $all ]

        foreach object $all {

            catch { $object garbageCollect }
        }

    }
}


