# Created at Tue Jul 22 09:45:12 EDT 2008 by bthomass

namespace eval ::xohtml {

    ::xodsl::ModelBuildingLanguageClass create PageBuilder -superclass ::xodsl::NamespaceObjectBuildingLanguage

    PageBuilder @doc PageBuilder {

        Please describe the class PageBuilder here.
    }

    PageBuilder parameter {
        { packages {xohtml xohtml::widget} }
    }

    PageBuilder instproc defineWidget { name parameters modelCode htmlWidgetCode } {

        ::xohtml::WidgetClass defineWidget $name $parameters $modelCode $htmlWidgetCode
        return 
    }

    PageBuilder instproc model { script } {

        my instvar object environment

        set newEnv [ Object new ]

        puts [ $environment info vars ]

        ::xox::ObjectGraph copyObjectVariables $environment $newEnv

        puts [ $newEnv info vars ]

        set builder [ ::xohtml::WidgetBuilder new ]
        $builder set environment $newEnv
        ::xohtml::WidgetBuilder updateEnvironment $builder
        $builder useObject ${object}::contentWidget
        $newEnv eval $script
        catch { $builder destroy }
        catch { $newEnv destroy }
    }

    PageBuilder instproc content { script } {

        my instvar object environment

        set newEnv [ Object new ]

        ::xox::ObjectGraph copyObjectVariables $environment $newEnv

        ${object}::contentWidget configure -set environment $newEnv  -htmlWidgetCode $script 
    }

    PageBuilder @tag buildPage hidden

    PageBuilder instproc buildPage { script } {

        my instvar environment object

        my useObject [ ::xohtml::Page new ]

        $environment eval $script 

        return $object
    }

    PageBuilder @tag formatPage hidden

    PageBuilder instproc formatPage { script } {

        return [ [ my buildPage $script ] formatPage ]
    }

    PageBuilder @tag writePage hidden

    PageBuilder instproc writePage { script { fileName "" } } {

        set page [ my buildPage $script ]
        if { "" != "$fileName" } {
            $page fileName $fileName
        }
        $page writePage 

        return $page
    }

    PageBuilder @tag addToModel hidden

    PageBuilder instproc addToModel { model script } {

        my instvar environment

        my useObject $model
        $environment eval $script 
        return $model
    }

    PageBuilder @tag newBuilder hidden

    PageBuilder instproc newBuilder { child } {

        my instvar environment packages

        set childBuilder [ [ my info class ] newLanguage -packages $packages -set object $child]

        set newEnv [ $childBuilder set environment ]

        ::xox::ObjectGraph copyObjectVariables $environment $newEnv

        ::xodsl::ObjectBuildingLanguage updateObjectEnvironment $childBuilder
        return $childBuilder
    }
}


