# Created at Tue Oct 21 22:48:50 EDT 2008 by ben

namespace eval ::xohtml {

    Class Site -superclass ::xox::Node

    Site @doc Site {

        Please describe the class Site here.
    }

    Site parameter {
        { deleteOnWrite 1}
    }

    Site instproc writePages { } {

        my instvar deleteOnWrite

        foreach child [ my info children ] {

            if [ $child hasclass ::xohtml::Page ] {

                $child writePage 

                if $deleteOnWrite { $child destroy }
            }
        }
    }
}


