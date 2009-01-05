# Created at Mon Jul 21 19:52:06 EDT 2008 by bthomass

namespace eval ::xohtml {

    ::xodsl::LanguageClass create HtmlWidget -superclass { ::xohtml::HtmlGenerationLanguage ::xox::Node }

    HtmlWidget @doc HtmlWidget {

        Please describe the class HtmlWidget here.
    }

    HtmlWidget parameter {
        modelCode
        htmlWidgetCode
    }

    HtmlWidget instproc makeEnvironment { } {

        my instvar environment

        if { ! [ my exists environment ] } {
            set environment [ Object new ]
        }

        ::xox::ObjectGraph copyObjectVariables [ self ] $environment

        ::xohtml::HtmlWidget updateEnvironment [ self ]
    }

    HtmlWidget instproc formatWidget { } {

        my instvar environment htmlWidgetCode

        my makeEnvironment

        set builder [ ::xodsl::StringBuilder new -language [ self ] -environment $environment ]
        set return [ $builder buildString $htmlWidgetCode ]
        $builder destroy 

        return $return
    }

    HtmlWidget instproc formatWidgetWithCollector { collector } {

        my instvar environment htmlWidgetCode

        my makeEnvironment

        set builder [ ::xodsl::StringBuilder new -language [ self ] -environment $environment ]
        set return [ $builder buildStringWithCollector $htmlWidgetCode $collector ]
        $builder destroy 
        return $return
    }

    HtmlWidget instproc formatChildWidgets { } {

        my instvar collector  

        set buffer ""

        foreach child [ my nodes ] {

            $child formatWidgetWithCollector $collector
        }

        return
    }

    HtmlWidget instproc getOptions { args } {

        set options ""

        foreach option $args {

            if [ my exists $option ] {

                append options " ${option}=\"[ my set $option ]\""
            }
        }

        return $options
    }

    HtmlWidget instproc getParameterOptions { } {

        set options ""

        foreach option [ [ my info class ] info parameter ] {

            set option [ lindex $option 0 ]

            if [ my exists $option ] {

                append options " ${option}=\"[ my set $option ]\""
            }
        }

        return $options
    }

    HtmlWidget instproc buildModel { script } {

        set builder [ ::xohtml::WidgetBuilder newLanguage ]
        $builder buildWidgetModel [ self ] $script
        $builder destroy
    }

    HtmlWidget @doc use {

        Uses a child widget to create a block of HTML code.  This widget may be customized using dashed args in the 'args' parameter.
        If args are given the widget is copied to a temporary object and then configured before we extract its HTML.   This
        temporary widget is then destroyed.  Child widgets can be created in the model building phase of the page.
    }

    HtmlWidget @arg use name { The name of a child wiget to use. }
    HtmlWidget @arg use args { Dashed args to configure the child widget before use. }

    HtmlWidget @example use {

            use oLink -object [ $object info class ] 
    }

    HtmlWidget instproc use { name args } {

        my instvar collector

        set widget [ Object new ]
        if { "" == "$args" } {
            [ my $name ] formatWidgetWithCollector $collector
        } else {
            [ my $name ] copy $widget 
            eval $widget configure $args
            $widget formatWidgetWithCollector $collector
            $widget destroy
        }

        return 
    }

    HtmlWidget @doc useExternal {

        Use an external widget to generate HTML.  Calls formatWidgetWithCollector on the widget using the current collector.
    }

    HtmlWidget @arg useExternal widget { The widget to use. }

    HtmlWidget instproc useExternal { widget } {

        my instvar collector
        $widget formatWidgetWithCollector $collector
        return
    }

    HtmlWidget instproc destroy { args } {

        my instvar environment

        catch { $environment destroy }

        next
    }
}


