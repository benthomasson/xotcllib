# Created at Fri Oct 17 03:27:05 PM EDT 2008 by bthomass

package require xox

::xox::Package create ::xodsl

::xodsl requires {
    xox
    xounit
    xoexception
}
::xodsl loadAll

proc ::xodsl::buildString { script } {

        set language [ ::xodsl::StringBuildingLanguage newLanguage ]
        set environment [ $language set environment ] 
        uplevel ::xox::ObjectGraph copyScopeVariables $environment
        set builder [ ::xodsl::StringBuilder new -language $language -environment $environment ]
        set return [ $builder buildString $script ]
        return $return
}

