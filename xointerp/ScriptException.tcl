# Created at Tue Mar 11 19:33:12 EDT 2008 by bthomass

namespace eval ::xointerp {

    Class ScriptException -superclass ::xoexception::Exception

    ScriptException @doc ScriptException {

        Please describe the class ScriptException here.
    }

    ScriptException parameter {
        { scriptStackTrace { } }
        { command "" }
        { lineNumber }
        { script }
    }

    ScriptException instproc getScriptErrorMessage { } {

        my instvar message command script

        if { ! [ my exists script ] } { my script "" }

        return "$message\n
while executing
\"$command\"
in script {
$script
}"
    }
}


