# Created at Sun Feb 10 11:26:02 EST 2008 by bthomass

namespace eval ::xointerp {

    Class StringBuildingEvaluate -superclass ::xointerp::StringBuilding

    StringBuildingEvaluate instproc if { interpreter args } {

        foreach { keyword condition script } [ concat if $args ] {

            if { "$keyword" == "else" } {

                return [ my iEval $interpreter $condition ]
            }

            if { "$keyword" == "elseif" } {

                if [ my iEvalExpr $interpreter $condition ] {
                   return [ my iEval $interpreter $script ]
                }
            }

            if { "$keyword" == "if" } {

                if [ my iEvalExpr $interpreter $condition ] {
                  return [ my iEval $interpreter $script ]
                }
            }
        }
    }

    StringBuildingEvaluate instproc while { interpreter condition body } {

        set return ""

        ::xoexception::try {
            while { [ my iEvalExpr $interpreter $condition ] } {
                ::xoexception::try {

                    append return [ my iEval $interpreter $body ]
                } catch { ::xointerp::ContinueSignal cs } { }
            }
        } catch { ::xointerp::BreakSignal bs } { }

        return $return
    }

    StringBuildingEvaluate instproc for { interpreter start condition next body } {
        
        set return ""

        ::xoexception::try {
            for { my iEval $interpreter $start } { [ my iEvalExpr $interpreter $condition ] } { my iEval $interpreter $next } {
                ::xoexception::try {
                    append return [ my iEval $interpreter $body ]
                } catch { ::xointerp::ContinueSignal cs } { }
            }
        } catch { ::xointerp::BreakSignal bs } { }
        
        return $return
    }

    StringBuildingEvaluate instproc foreach { __interpreter __varname __list __body } {

        set __return ""

        ::xoexception::try {
            foreach $__varname $__list {
                ::xoexception::try {
                    foreach __var $__varname {
                        my iEval $__interpreter "set $__var [ set $__var ]"
                    }
                    append __return [  my iEval $__interpreter $__body ]
                } catch { ::xointerp::ContinueSignal cs } { }
            }
        } catch { ::xointerp::BreakSignal bs } { }

        return $__return
    }
}

