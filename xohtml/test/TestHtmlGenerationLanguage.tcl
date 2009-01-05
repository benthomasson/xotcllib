# Created at Mon Jul 21 19:51:36 EDT 2008 by bthomass

namespace eval ::xohtml::test {

    Class TestHtmlGenerationLanguage -superclass ::xounit::TestCase

    TestHtmlGenerationLanguage parameter {

    }

    TestHtmlGenerationLanguage instproc setUp { } {

        #add set up code here
    }

    TestHtmlGenerationLanguage instproc testBuildOptions { } {

        set hgl [ ::xohtml::HtmlGenerationLanguage new ]

        set bgcolor red

        my assertEquals [ $hgl buildAttributes bgcolor textcolor ] { bgcolor="red" }
    }

    TestHtmlGenerationLanguage instproc testBuildEmpty { } {

        my assertEqualsByLine [ ::xohtml::build [ Object new ] {
        } ]  ""
    }

    TestHtmlGenerationLanguage instproc testBuildSimple { } {

        my assertEqualsByLine [ ::xohtml::build [ Object new ] {
            html
        } ]  "<html></html>"
    }

    TestHtmlGenerationLanguage instproc testBuildVariable { } {

        set env [ Object new ]
        $env set title "A Title"

        my assertEquals [ $env set title ] "A Title"

        my assertEqualsByLine [ ::xohtml::build $env {
            html head title ' $title 
        } ] "<html><head><title>A Title</title></head></html>"
    }

    TestHtmlGenerationLanguage instproc testBuildWithModel2 { } {

        my assertEqualsByLine [ ::xohtml::buildWithModel { 
            - title "A title"
        } {

            html head title ' $title 

        } ] "<html><head><title>A title</title></head></html>"
    }

    TestHtmlGenerationLanguage instproc testArguments { } {

        my assertEqualsByLine [ ::xohtml::build [ Object new ] {
            html { 
                head 
                body 
            }
        } ]  "<html><head></head><body></body></html>"
    }

    TestHtmlGenerationLanguage instproc testArguments2 { } {

        my assertEqualsByLine [ ::xohtml::build [ Object new ] {
            html { 
                head 
                body { h1 ' "Hi there" }
            } 
        } ] "<html><head></head><body><h1>Hi there</h1></body></html>"
    }

    TestHtmlGenerationLanguage instproc testArguments3 { } {

        my assertEqualsByLine [ ::xohtml::build [ Object new ] {
            html { 
                head 
                body 
            }
        } ]  "<html><head></head><body></body></html>"
    }

    TestHtmlGenerationLanguage instproc testFixArgs { } {

        set hgl [ ::xohtml::HtmlGenerationLanguage new ]

        my assertEquals [ $hgl fixArgs {} ] {}
        my assertEquals [ $hgl fixArgs {} ] {}

    }

    TestHtmlGenerationLanguage instproc testA { } {
        my assertEqualsByLine [ ::xohtml::build [ Object new ] {
            a
        } ]  "<a></a>"
        my assertEqualsByLine [ ::xohtml::build [ Object new ] {
            a ' b
        } ]  "<a>b</a>"
    }

    TestHtmlGenerationLanguage instproc testAHref { } {
        my assertEqualsByLine [ ::xohtml::build [ Object new ] {
            a -href "x"
        } ]  "<a href=\"x\" ></a>"
        my assertEqualsByLine [ ::xohtml::build [ Object new ] {
            a -href "x" ' b
        } ]  "<a href=\"x\" >b</a>"
        my assertEqualsByLine [ ::xohtml::build [ Object new ] {
            a -href [ cleanUpLink "x:x" ] ' b
        } ]  "<a href=\"x%3Ax\" >b</a>"
        my assertEqualsByLine [ ::xohtml::build [ Object new ] {
            a -href [ cleanUpLink "x#x" ] ' b
        } ]  "<a href=\"x%23x\" >b</a>"
    }

    TestHtmlGenerationLanguage instproc testAName { } {
        my assertEqualsByLine [ ::xohtml::build [ Object new ] {
            a -name "x"
        } ]  "<a name=\"x\" ></a>"
        my assertEqualsByLine [ ::xohtml::build [ Object new ] {
            a -name "x" ' b
        } ]  "<a name=\"x\" >b</a>"
    }

    TestHtmlGenerationLanguage instproc testMixinAdd { } {

        set class [ Class new ]

        $class instproc abc { } {
            my ' abc123
        }

        my assertEqualsByLine [ ::xohtml::build [ Object new -set mixin $class ] {
            ' $mixin
            add $mixin
            abc
        } ] "${class}abc123"
    }

    TestHtmlGenerationLanguage instproc tearDown { } {

        #add tear down code here
    }
}


