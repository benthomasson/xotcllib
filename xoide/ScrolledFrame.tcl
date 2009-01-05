# Created at Mon Sep 29 21:47:56 EDT 2008 by ben

namespace eval ::xoide {

    Class ScrolledFrame -superclass ::xoide::TkObject

    ScrolledFrame @doc ScrolledFrame {

        Please describe the class ScrolledFrame here.
    }

    ScrolledFrame parameter {
        name
        frame
        window
        sframe
    }

    ScrolledFrame instproc init { } {

        my instvar name frame window sframe

        package require BWidget 

        set window [ ScrolledWindow $name -relief solid -auto none]

        set sframe [ ScrollableFrame $window.frame ]
        pack $sframe -fill both -expand yes

        $window setwidget $sframe

        set frame [$sframe getframe]
        #$frame configure -relief solid -bd 10
    }

    ScrolledFrame instproc destroyFrameChildren { } {

        my instvar frame

        foreach child [ winfo children $frame ] {

            destroy $child 
        }
    }

    ScrolledFrame instproc see { args } {

        my instvar sframe

        eval $sframe see $args
    }
}


