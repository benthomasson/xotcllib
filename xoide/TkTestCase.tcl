
namespace eval ::xoide {

    Class TkTestCase -superclass ::xounit::TestCase

    TkTestCase parameter {

    }

    TkTestCase instproc setUp { } {

        my instvar root

        package require Tk

        foreach w [winfo children .] {
            destroy $w
        }

        set root [ my newRoot ]
    }

    TkTestCase instproc newRoot { } {

        return .[ my autoname window ]
    }

    TkTestCase instproc interact { { time 0 } } {
        my instvar pause
        if { $time > 0 } {
            after $time {set ::pause 1}
            puts "Continuing test in $time milliseconds..."
        } else {
            set frame [ my newRoot ]
            ::xoide::TopLevel new -name $frame
            button $frame.button -command "set ::pause 1" -text "Continue Test"
            pack $frame.button
            raise $frame
            puts "Press button to continue test..."
        }
        vwait ::pause
    }
}
