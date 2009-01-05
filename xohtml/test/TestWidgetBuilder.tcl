# Created at Sun Oct 26 21:19:46 EDT 2008 by ben

namespace eval ::xohtml::test {

    Class TestWidgetBuilder -superclass ::xounit::TestCase

    TestWidgetBuilder parameter {

    }

    TestWidgetBuilder instproc setUp { } {

        my instvar builder  widget

        set builder [ ::xohtml::WidgetBuilder newLanguage ]
        set widget [ ::xohtml::HtmlWidget new ]
    }

    TestWidgetBuilder instproc testEmpty { } {

        my instvar builder widget

        my assertEquals [ $widget info children ] "" 1
        $builder buildWidgetModel $widget { }
        my assertEquals [ $widget info children ] "" 2
    }

    TestWidgetBuilder instproc testSimpleWidget { } {

        my instvar builder widget

        $builder buildWidgetModel $widget {
            SimpleWidget simple {
                aTitle hi
            }
        }
        my assertEquals [ $widget info children ] ${widget}::simple
        my assertEquals [ $widget simple ] ${widget}::simple
        my assertEquals [ $widget simple aTitle ] hi
    }

    TestWidgetBuilder instproc testBuildModel { } {

        my instvar builder widget

        $widget buildModel {
            SimpleWidget simple {
                aTitle hi
            }
        }
        my assertEquals [ $widget info children ] ${widget}::simple
        my assertEquals [ $widget simple ] ${widget}::simple
        my assertEquals [ $widget simple aTitle ] hi
    }

    TestWidgetBuilder instproc tearDown { } {

        #add tear down code here
    }
}


