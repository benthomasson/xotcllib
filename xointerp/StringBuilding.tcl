# Created at Sun Feb 10 11:26:02 EST 2008 by bthomass

namespace eval ::xointerp {

    Class StringBuilding -superclass ::xointerp::Interpretable

    StringBuilding # StringBuilding {

        Please describe the class StringBuilding here.
    }

    StringBuilding parameter {

        { interpretableProcs {if while for foreach quiet} }
    }

    StringBuilding instproc iEval { interpreter script } {

        return [  $interpreter tclEvalLevel [ $interpreter currentLevel ] $script ]
    }

    StringBuilding instproc iEvalSub { interpreter script } {

        return [ $interpreter evalSubstLevel [ $interpreter currentLevel ] $script ]
    }

    StringBuilding instproc if { interpreter args } {

        foreach { keyword condition script } [ concat if $args ] {

            if { "$keyword" == "else" } {

                return [ my iEvalSub $interpreter $condition ]
            }

            if { "$keyword" == "elseif" } {

                if [ my iEvalExpr $interpreter $condition ] {
                   return [ my iEvalSub $interpreter $script ]
                }
            }

            if { "$keyword" == "if" } {

                if [ my iEvalExpr $interpreter $condition ] {
                  return [ my iEvalSub $interpreter $script ]
                }
            }
        }
    }

    StringBuilding instproc while { interpreter condition body } {

        set return ""

        ::xoexception::try {
            while { [ my iEvalExpr $interpreter $condition ] } {
                ::xoexception::try {

                    append return [ my iEvalSub $interpreter $body ]
                } catch { ::xointerp::ContinueSignal cs } { }
            }
        } catch { ::xointerp::BreakSignal bs } { }

        return $return
    }

    StringBuilding instproc for { interpreter start condition next body } {
        
        set return ""

        ::xoexception::try {
            for { my iEval $interpreter $start } { [ my iEvalExpr $interpreter $condition ] } { my iEval $interpreter $next } {
                ::xoexception::try {
                    append return [ my iEvalSub $interpreter $body ]
                } catch { ::xointerp::ContinueSignal cs } { }
            }
        } catch { ::xointerp::BreakSignal bs } { }
        
        return $return
    }

    StringBuilding instproc foreach { __interpreter __varname __list __body } {

        set __return ""

        ::xoexception::try {
            foreach $__varname $__list {
                ::xoexception::try {
                    foreach __var $__varname {
                        my iEval $__interpreter "set $__var [ set $__var ]"
                    }
                    append __return [  my iEvalSub $__interpreter $__body ]
                } catch { ::xointerp::ContinueSignal cs } { }
            }
        } catch { ::xointerp::BreakSignal bs } { }

        return $__return
    }

    StringBuilding instproc identity { value } {

        return $value;
    }

    StringBuilding instproc quiet { interpreter script } {

        my iEval $interpreter $script

        return
    }

    StringBuilding instproc quote { args } {

        if { [ llength $args ] == 1 } {
            set args [ lindex $args 0 ]
        }

        return $args
    }

    StringBuilding instproc ' { args } {

        if { [ llength $args ] == 1 } {
            set args [ lindex $args 0 ]
        }

        return $args
    }

    StringBuilding instproc continue { } {

        error "continue unsupported in StringBuilding"
    }
}


