# Created at Wed Jan 16 21:12:09 EST 2008 by bthomass

package require XOTcl
package require xox

::xox::Package create ::xointerp
::xointerp requires {
    xox
    xounit
    xoexception
}
::xointerp exports {
    if2
}
namespace eval ::xointerp {

    proc if2 { args } {

        set level #[ expr [ info level ] - 1 ]
        set return ""
        set interpreter [ ::xointerp::TclInterpreter new ]

        foreach { keyword condition script } [ concat if $args ] {

            if { "$keyword" == "else" } {

                set return [ $interpreter tclEvalLevel $level $condition ]
                break
            }

            if { "$keyword" == "elseif" } {

                if [ $interpreter tclEvalLevel $level "expr {$condition}" ] {
                    set return [ $interpreter tclEvalLevel $level $script ]
                    break
                }
            }

            if { "$keyword" == "if" } {

                if [ $interpreter tclEvalLevel $level "expr {$condition}" ] {
                    set return [ $interpreter tclEvalLevel $level $script ]
                    break
                }
            }
        }

        return $return
    }

    proc ::xointerp::buildString { template } {

            set builder [ ::xointerp::LibraryInterpreter new -library [ ::xointerp::StringBuilding new ] ]
            set return [  uplevel [ list $builder evalSubst $template ] ]
            $builder destroy
            return $return
    }

    proc ::xointerp::buildModel { template } {

        set builder [ ::xointerp::ClassModelBuildingInterpreter new ]
        set object [ $builder tclEval $template ]
        $builder destroy
        return $object
    }

    proc ::xointerp::interpretScript { languageClass script } {

        set library [ $languageClass new ]
        set interpreter [ ::xointerp::ObjectInterpreter new -library $library -environment $library ]
        set return [ $interpreter tclEval $script ]
        $library destroy
        $interpreter destroy

        return $return
    }
}
::xointerp loadAll


