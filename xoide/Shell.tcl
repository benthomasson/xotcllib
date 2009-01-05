# Created at Fri Sep 26 01:31:28 EDT 2008 by bthomass

namespace eval ::xoide {

    Class Shell -superclass ::xoide::TkObject

    Shell @doc Shell {

        Please describe the class Shell here.
    }

    Shell parameter {
        text
        currentCommand
        { history 0 }
        scrolledText
    }

    Shell instproc init {  } {

        my instvar text name scrolledText
        frame $name -background gray
        set scrolledText [ ScrolledText new ${name}.eval -width 40 -height 50 -name Shell ]
        puts $scrolledText
        set text [ $scrolledText text ]
        puts $text

        pack $name.eval -fill both -expand true -side left

        $text tag configure prompt -underline true
        $text tag configure result -foreground purple
        $text tag configure error -foreground red
        $text tag configure object -foreground orange
        $text tag configure class -foreground orange -underline true

        #$text insert insert [ my prompt ] prompt
        my insertPrompt

        $text mark set limit insert
        $text mark gravity limit left
        focus $text

        bind $text <Control-Return> "[ self ] executeScript; break"
        bind $text <Return> "[ self ] evalTypeIn; break "
        bind $text <Delete> {
            if {[ %W tag nextrange sel 1.0 end ] != "" } {
                %W delete sel.first sel.last
            } elseif {[%W compare insert > limit]} {
                %W delete insert-1c
                %W see insert
            }
            break
        }
        bind $text <Key> {
            if [%W compare insert < limit ] {
                %W mark set insert end
            }
        }

    }

    Shell instproc prompt { } {

        my instvar history
        return "xotcl [ llength $history ]>"
    }

    Shell instproc insertPrompt { } {

        my instvar text
        $text insert insert [ my prompt ] prompt
        $text see insert
        $text mark set limit insert
    }

    Shell instproc evalTypeIn { } {

        my instvar text 

        $text insert insert \n
        set command [ $text get limit end ]
        $text mark set limit insert

        my runACommand $command
        my insertPrompt
        return
    }

    Shell instproc runACommand { command } {

        my instvar currentCommand

        my lappend history [ string trimright $command ]
        my updateScript
        my append currentCommand "[ string trimright $command ]\n"
        
        if [ info complete $currentCommand ] {
            #my Eval $currentCommand
            catch { my unset currentCommand }
        } 
    }

    Shell instproc updateScript { } {

    }
}


