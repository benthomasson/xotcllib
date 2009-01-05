# Created at Sat Jan 05 11:05:46 EST 2008 by bthomass

namespace eval ::xointerp {

    Class Interpretable -superclass ::xotcl::Object

    Interpretable # Interpretable {

        Interpretable is a mixin that provides interpretable versions of Tcl procedures.
    }

    Interpretable parameter {
        { interpretableProcs {if while for foreach time catch} }
    }

    Interpretable instproc iEval { interpreter script } {

        return [ $interpreter tclEvalLevel [ $interpreter currentLevel ] $script ]
    }

    Interpretable instproc iEvalExpr { interpreter condition } {

        set result [ $interpreter evalSubCommands [ $interpreter currentLevel ] $condition 1 ]
        set return [ $interpreter tclEvalLevel [ $interpreter currentLevel ] "expr {$result}" ]
        return $return
    }

    Interpretable @doc if {

        Branch execution depending on a boolean condition.
    }

    Interpretable instproc if { interpreter args } {

        foreach { keyword condition script } [ concat if $args ] {

            if { "$keyword" == "else" } {

                set script $condition
                my iEval $interpreter $script
                return
            }

            if { "$keyword" == "elseif" } {

                if [ my iEvalExpr $interpreter $condition ] {
                    my iEval $interpreter $script
                    return
                }
            }

            if { "$keyword" == "if" } {

                if [ my iEvalExpr $interpreter $condition ] {
                    my iEval $interpreter $script
                    return
                }
            }
        }
    }

    Interpretable @doc while {

        Loop execution depending on a boolean condition.
    }

    Interpretable instproc while { interpreter condition body } {

        ::xoexception::try {

            while { [ my iEvalExpr $interpreter $condition ] } {
                ::xoexception::try {
                    my iEval $interpreter $body
                } catch { ::xointerp::ContinueSignal cs } { }
            }

        } catch { ::xointerp::BreakSignal bs } { }
    }

    Interpretable @doc for {
        
        Loop execution depending on a boolean condition and a starting and next block.
    }

    Interpretable instproc for { interpreter start condition next body } {

        ::xoexception::try {

        for { my iEval $interpreter $start } { [ my iEvalExpr $interpreter $condition ] } { my iEval $interpreter $next } {

            ::xoexception::try {
                my iEval $interpreter $body
            } catch { ::xointerp::ContinueSignal cs } { }
        }

        } catch { ::xointerp::BreakSignal bs } { }
    }

    Interpretable @doc foreach {

        Loop execution for each item in a list.
    }

    Interpretable instproc foreach { _interpreter args } {

        set _body [ lindex $args end ]
        set _varLists  [ lrange $args 0 end-1 ]

        ::xoexception::try {

            eval foreach $_varLists [ list {
                ::xoexception::try {
                    foreach {_varname _list } $_varLists {
                        foreach _var $_varname {
                            my iEval $_interpreter "set $_var [ set $_var ]"
                        }
                    }
                    my iEval $_interpreter $_body
                } catch { ::xointerp::ContinueSignal cs } { }
            } ]

        } catch { ::xointerp::BreakSignal bs } { }
    }

    Interpretable instproc oproc { name args body } {

        my lappend interpretableProcs $name

        set setargs ""

        foreach arg $args {

            append setargs "my set $arg \$$arg\n"
        }

        my proc $name [ concat interpreter $args ] [ subst {

            $setargs

            return \[ \$interpreter tclEval { $body } \]
        } ]
    }

    Interpretable instproc iproc { name args body } {

        my lappend interpretableProcs $name

        set setargs ""

        foreach arg $args {

            append setargs "\$environment set $arg \$$arg\n"
        }

        my proc $name [ concat interpreter $args ] [ subst {

            set child ::xointerp::temp
            \$interpreter copy \$child
            set environment \[ ::xointerp::ProcedureEnvironment new \]
            
            \$child environment \$environment

            $setargs

            set return \[ \$child tclEval { $body } \]

            \$child destroy
            \$environment destroy

            return \$return

        } ]
    }

    Interpretable instproc break { } {

        error [ ::xointerp::BreakSignal new ]
    }

    Interpretable instproc continue { } {

        error [ ::xointerp::ContinueSignal new ]
    }

    Interpretable instproc upvar { args } {

        error "Unsupported command: upvar"
    }

    Interpretable instproc uplevel { args } {

        error "Unsupported command: uplevel"
    }

    Interpretable instproc time { interpreter script count } {

        return [ time {

            my iEval $interpreter $script

        } $count ]
    }

    Interpretable instproc catch { interpreter script { resultName "" } } {

        set return [ catch {
            set result [ my iEval $interpreter $script ]
        } result ]

        if $return {
            set result [ ::xoexception::Throwable extractMessage $result ]
        }

        if { "" != "$resultName" } {
            my iEval $interpreter "set $resultName $result"
        }
        return $return
    }
}


