# Created at Thu Aug 14 14:21:00 EDT 2008 by bthomass

namespace eval ::xohtml::test {

    Class TestWidgetClass -superclass ::xounit::TestCase

    TestWidgetClass parameter {

    }

    TestWidgetClass instproc setUp { } {

        #add set up code here
    }

    TestWidgetClass instproc testDefineClass { } {

        my assertEquals [ ::xohtml::WidgetClass defineWidget MyWidget { } { } {
            html
        } ] ::xohtml::widget::MyWidget

        my assertObject [ ::xohtml::widget::MyWidget ] object
        my assertObject [ ::xohtml::widget::MyWidget::prototype ] prototype
        my assertTrue [ my isclass [ ::xohtml::widget::MyWidget ] ] isclass
        my assertEquals [ ::xohtml::widget::MyWidget info superclass ] ::xohtml::SimpleWidget
        my assertEquals [ ::xohtml::widget::MyWidget info class ] ::xohtml::WidgetClass
        my assertEquals [ ::xohtml::widget::MyWidget::prototype info class ] ::xohtml::widget::MyWidget

        set instance [ ::xohtml::widget::MyWidget new ]

        my assertObject $instance instance

        my assertEqualsByLine [ $instance htmlWidgetCode ] {
           html
        }

        my assertEqualsByLine [ $instance formatWidget ] {
            <html></html>
        }

        my assertEqualsByLine [ ::xohtml::widget::MyWidget formatTempWidget { 
        } ] {
            <html></html>
        }
    }

    TestWidgetClass instproc tearDown { } {

        #add tear down code here
    }
}


