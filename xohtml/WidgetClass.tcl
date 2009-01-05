# Created at Thu Aug 14 14:21:00 EDT 2008 by bthomass

namespace eval ::xohtml {

    Class WidgetClass -superclass ::xodsl::LanguageClass

    WidgetClass @doc WidgetClass {

        Please describe the class WidgetClass here.
    }

    WidgetClass parameter {

    }

    WidgetClass proc defineWidget { name parameters modelCode htmlWidgetCode } {

        if { ! [ string match ::* $name ] } {

            set name ::xohtml::widget::${name}
        }

        if { ! [ my isclass $name ] } { 
            my create $name -superclass ::xohtml::SimpleWidget 
        }
        
        $name parameter $parameters

        $name set modelCode $modelCode
        $name set htmlWidgetCode $htmlWidgetCode

        $name instproc init { } [ subst {
            next
            my buildModel {$modelCode}
            my htmlWidgetCode \[ $name set htmlWidgetCode \]
        } ]

        $name getPrototype

        return $name
    }

    WidgetClass instproc formatTempWidget { script } {

        set builder [ ::xohtml::PageBuilder newLanguage ]
        set instance [ eval my new -noinit ]
        $builder addToModel $instance $script
        $instance init
        set return [ $instance formatWidget ] 
        $instance destroy
        return $return
    }

    WidgetClass instproc getPrototype { } {

        set prototype [ self ]::prototype

        if { ! [ my isobject $prototype ] } {
            my create $prototype
        }

        return $prototype
    }

    WidgetClass instproc configurePrototype { args } {

        [ my getPrototype ] configure $args
        return [ my getPrototype ]
    }
}


