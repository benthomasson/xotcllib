# Created at Sun Oct 26 21:19:46 EDT 2008 by ben

namespace eval ::xohtml {

    ::xodsl::ModelBuildingLanguageClass create WidgetBuilder -superclass ::xodsl::NamespaceObjectBuildingLanguage

    WidgetBuilder @doc WidgetBuilder {

        Please describe the class WidgetBuilder here.
    }

    WidgetBuilder parameter {
        { packages {xohtml xohtml::widget} }
    }

    WidgetBuilder @tag buildWidgetModel hidden

    WidgetBuilder instproc buildWidgetModel { widget script } {

        my instvar environment

        my useObject $widget
        $environment eval $script 
        return $widget
    }

    WidgetBuilder instproc destroy { args } {

        my instvar environment
        catch { $environment destroy } 
        next
    }
}


