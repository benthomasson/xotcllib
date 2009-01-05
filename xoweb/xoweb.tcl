# Created at Thu Oct 23 19:33:58 EDT 2008 by ben

package require xotcllib

::xox::Package create ::xoweb
::xoweb requires {
    xohtml
}
::xoweb loadAll

::xoweb proc installFiles { location } {

    file mkdir [ file join $location htdocs files ]
    file copy -force [ file join [ my packagePath ] prototype.js ] [ file join $location htdocs files ] 
    file copy -force [ file join [ my packagePath ] xopro.js ] [ file join $location htdocs files ]
    file copy -force [ file join [ my packagePath ] xoweb.custom ] [ file join $location custom xoweb.tcl ]
}


proc ::xoweb::makePage { modelCode htmlWidgetCode } {

    set environment [ Object new ]
    uplevel ::xox::ObjectGraph copyScopeVariables $environment
    set builder [ ::xohtml::PageBuilder newLanguage ]
    $builder set environment $environment 
    $builder useObject [ ::xohtml::Page new ]
    ::xohtml::PageBuilder updateEnvironment $builder
    $builder model $modelCode
    $builder content $htmlWidgetCode 
    return [ [ $builder set object ] formatPage ]
}

::xoweb @doc xoweb {

    Xoweb is a package for building web applications.
}

::xoweb @example xoweb {

    XYZ ABC

}

