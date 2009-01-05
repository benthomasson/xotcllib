# Created at Mon Jul 21 19:48:33 EDT 2008 by bthomass

package require xotcllib

::xox::Package create ::xohtml

::xohtml loadFirst {
    ::xohtml::SingletonClass
}

proc ::xohtml::build { environment template } {

        set language [ ::xohtml::HtmlGenerationLanguage new ]
        $language set environment $environment
        ::xohtml::HtmlGenerationLanguage updateEnvironment $language
        set builder [ ::xodsl::StringBuilder new -language $language -environment $environment ]
        set return [ $builder buildString $template ]
        return $return
}

proc ::xohtml::buildWithModel { modelTemplate pageTemplate } {

    set builder [ ::xohtml::PageBuilder newLanguage ]
    set model [ $builder addToModel [ Object new ] $modelTemplate ]
    $builder destroy
    return [ ::xohtml::build $model $pageTemplate ]
}

proc ::xohtml::buildPage { environment modelTemplate } {

    set builder [ ::xohtml::PageBuilder newLanguage ]
    $builder set environment $environment 
    ::xohtml::PageBuilder updateEnvironment $builder
    set html [ ::xohtml::Page new ]
    $builder addToModel $html $modelTemplate
    return [ $html formatPage ]
}

proc ::xohtml::formatPage { environment modelTemplate } {

    set builder [ ::xohtml::PageBuilder newLanguage ]
    $builder set environment $environment 
    ::xohtml::PageBuilder updateEnvironment $builder
    return [ $builder formatPage $modelTemplate ]
}

proc ::xohtml::formatPageWithScopeVariables { modelTemplate } {

    set environment [ Object new ]
    uplevel ::xox::ObjectGraph copyScopeVariables $environment
    set builder [ ::xohtml::PageBuilder newLanguage ]
    $builder set environment $environment 
    ::xohtml::PageBuilder updateEnvironment $builder
    return [ $builder formatPage $modelTemplate ]
}

proc ::xohtml::widgets { script } {

    ::xohtml loadClass ::xohtml::WidgetLibraryLanguage 
    ::xohtml loadClass ::xohtml::WidgetClass 

    namespace eval ::xohtml::widget { }

    set language [ ::xohtml::WidgetLibraryLanguage newLanguage ]
    [ $language set environment ] eval $script
    $language destroy 
}

::xohtml loadAll

