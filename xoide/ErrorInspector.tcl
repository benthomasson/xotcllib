# Created at Fri Sep 26 00:56:51 EDT 2008 by bthomass

namespace eval ::xoide {

    Class ErrorInspector -superclass ::xoide::Inspector

    ErrorInspector @doc ErrorInspector {

        Please describe the class ErrorInspector here.
    }

    ErrorInspector parameter {
        index
        result
    }

    ErrorInspector instproc init { } {

        my instvar name index result

        next
        wm title $name "ErrorInspector #$index"

        set st [ ::xoide::ScrolledText new ${name}.error -width 80 -height 20 -name Error ]
        pack ${name}.error -fill both -expand true -side left
        raise $name

        set text [ $st text ]
        $text delete 1.0 end
        $text insert insert "[ ::xoexception::Throwable::extractMessage $result ]\n"
        $text insert insert "----------------------------------------------------\n"
        catch {
            $text insert insert "[ $result trace ]"
            $text insert insert "----------------------------------------------------\n"
        }
        #$text insert insert [ my set errors($index) ]
    }
}


