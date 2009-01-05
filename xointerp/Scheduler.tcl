# Created at Sun Jan 06 22:10:21 EST 2008 by bthomass

namespace eval ::xointerp {

    Class Scheduler -superclass ::xotcl::Object

    Scheduler # Scheduler {

        Please describe the class Scheduler here.
    }

    Scheduler parameter {
        interpreters
        { done 0 }
    }

    Scheduler instproc callBack { interpreter } {

        my schedule
    }

    Scheduler instproc addInterpreter { interpreter } {

        my lappend interpreters $interpreter
    }

    Scheduler instproc schedule { } {

        my instvar interpreters

        set newInterpreters ""

        foreach interpreter $interpreters {

            if [ my isobject $interpreter ] {
                $interpreter evalOneCommand
                lappend newInterpreters $interpreter
            } 
        }

        set interpreter $newInterpreters
    }

    Scheduler instproc loop { } {

        my instvar done

        while { !$done } {

            my schedule

            update
            after 1
        }
    }
}


