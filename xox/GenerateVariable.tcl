
namespace eval ::xox {

    namespace import -force ::xotcl::*

    Object create ::xox::genvars -requireNamespace

    Class GenerateVariable

    GenerateVariable # GenerateVariable {

        Generates new variables that can be used
        as temporary variables that will not conflict
        with any other variables.
    }

    GenerateVariable # variableCount \
        { A counter used to make unique variable names }

    GenerateVariable parametercmd variableCount

    GenerateVariable # getVariableCount {

        Gets the current variableCount value. This
        will also increment variableCount. Each
        call will return a new value.
    }

    GenerateVariable proc getVariableCount { } {

        if {! [ my exists variableCount ]} {

            my set variableCount 0
        }

        return [ my incr variableCount ]
    }

    GenerateVariable # generateVariable {

        Generates a new variable that will not conflict
        with existing variables.
    }

    GenerateVariable proc generateVariable { {name "" } } {

        if { "" == "$name" } {

            set name temp
        }

        return "::xox::genvars::$name[ my getVariableCount ]"
    }

    GenerateVariable # free {

        Frees the memory associated with a variable created
        by the generateVariable and returns the value held
        by that variable.
    }

    GenerateVariable proc free { variable } {

        set value [ set $variable ]

        catch { 
            ::xox::genvars unset [ namespace tail $variable] 
        }

        return $value
    }
}


