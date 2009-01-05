# Created at Mon Jul 21 19:52:06 EDT 2008 by bthomass

namespace eval ::xohtml::test {

    Class TestHtmlWidget -superclass ::xounit::TestCase

    TestHtmlWidget parameter {

    }

    TestHtmlWidget instproc setUp { } {

        #add set up code here
    }

    TestHtmlWidget instproc testString { } {

        set widget [ ::xohtml::HtmlWidget new -htmlWidgetCode { ' Hello World! } ]
        my assertEqualsByLine [ $widget formatWidget ] {
            Hello World!
        }
    }

    TestHtmlWidget instproc testSimpleHtml { } {

        set widget [ ::xohtml::HtmlWidget new -htmlWidgetCode {
            html {
                body ' Hello World!
            } 
        } ]
        my assertEqualsByLine [ $widget formatWidget ] {
            <html><body>Hello World!</body></html>
        }
    }

    TestHtmlWidget instproc testSimpleHtmlOptions { } {

        set widget [ ::xohtml::HtmlWidget new -htmlWidgetCode {
            html {
               body -bgcolor red ' Hello World! 
            } 
        } ]
        my assertEqualsByLine [ $widget formatWidget ] {
            <html><body bgcolor="red" >Hello World!</body></html>
        }
    }

    TestHtmlWidget instproc testList { } {

        set widget [ ::xohtml::HtmlWidget new -htmlWidgetCode {
         html {
             body {
                ul {
                     li ' 1 
                     li ' 2 
                     li ' 3 
                     li ' 4 
                }  
            } 
        }  
        } ]
        my assertEqualsByLine [ $widget formatWidget ] {
        <html><body><ul><li>1</li><li>2</li><li>3</li><li>4</li></ul></body></html> 
        }
    }

    TestHtmlWidget instproc testVariable { } {

        set widget [ ::xohtml::HtmlWidget new -set a 5 -htmlWidgetCode { ' $a } ]
        my assertEquals [ $widget formatWidget ] { 5 }
    }

    TestHtmlWidget instproc testVariableAsArgument { } {

        set widget [ ::xohtml::HtmlWidget new -set a 5 -htmlWidgetCode { evalWrite set b $a } ]
        my assertEquals [ $widget formatWidget ] { 5 }
    }

    TestHtmlWidget instproc testNew { } {

        set widget [ ::xohtml::HtmlWidget new -htmlWidgetCode {
            new ::xohtml::HtmlWidget -set you $::env(USER) -htmlWidgetCode { ' Hi $you } 
        } ]
        my assertEqualsTrim [ $widget formatWidget ] "Hi $::env(USER)"
    }

    TestHtmlWidget instproc testUse { } {

        set widget [ ::xohtml::HtmlWidget new -htmlWidgetCode { use hello } ]
        set other [ ::xohtml::HtmlWidget create ${widget}::hello -htmlWidgetCode { ' Hi $you } -set you $::env(USER) ]
        my assertEqualsTrim [ $widget formatWidget ] "Hi $::env(USER)"
        $other set you foobar
        my assertEqualsTrim [ $widget formatWidget ] "Hi foobar"
    }

    TestHtmlWidget instproc testUseConfigure { } {

        set widget [ ::xohtml::HtmlWidget new -htmlWidgetCode { 
            use hello -set you me 
            use hello
        } ]
        set other [ ::xohtml::HtmlWidget create ${widget}::hello -htmlWidgetCode { ' Hi $you } -set you $::env(USER) ]
        my assertEqualsTrim [ $widget formatWidget ] "Hi meHi $::env(USER)"
    }

    TestHtmlWidget instproc testChildWidgets { } {

        set widget [ ::xohtml::HtmlWidget new -htmlWidgetCode { formatChildWidgets } ]
        set other [ ::xohtml::HtmlWidget create ${widget}::child1 -htmlWidgetCode { ' Hi $you } -set you $::env(USER) ]
        my assertEqualsTrim [ $widget formatWidget ] "Hi $::env(USER)"
        $other set you foobar
        my assertEqualsTrim [ $widget formatWidget ] "Hi foobar"
    }

    TestHtmlWidget instproc testGetOptions { } {

        set widget [ ::xohtml::HtmlWidget new -set class ABC -set id DEF ]
        my assertEquals [ $widget getOptions class id ] { class="ABC" id="DEF"}

        set widget [ ::xohtml::HtmlWidget new -set class "A B C" -set id "D E F" ]
        my assertEquals [ $widget getOptions class id ] { class="A B C" id="D E F"}
    }

    TestHtmlWidget instproc tearDown { } {

        #add tear down code here
    }
}


