# Created at Tue Jul 22 09:45:09 EDT 2008 by bthomass

namespace eval ::xohtml {

    Class Page -superclass ::xox::Node

    Page @doc Page {

        Please describe the class Page here.
    }

    Page parameter {
        { fileName }
    }

    Page instproc init { } {

        next

        ::xohtml::HtmlWidget create [ self ]::contentWidget -htmlWidgetCode {}
    }

    Page instproc formatPage { } {

        set collector [ Object new -set string "" ]

        foreach child [ my info children ] {

            #::xox::ObjectGraph copyObjectVariables $environment $newEnv

            $child formatWidgetWithCollector $collector
        }

        set return [ $collector set string ]
        $collector destroy
        return $return
    }

    Page instproc writePage { } {

        my instvar fileName

        if { ! [ my exists fileName ] } { return }

        if { ! [ file exists [ file dirname $fileName ] ] } {
            file mkdir [ file dirname $fileName ]
        }

        puts "Writing [ my fileName ]" 
        flush stdout
        ::xox::writeFile [ my fileName ] [ my formatPage ]
    }
}


