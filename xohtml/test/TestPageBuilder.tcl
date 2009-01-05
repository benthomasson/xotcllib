# Created at Tue Jul 22 09:45:12 EDT 2008 by bthomass

namespace eval ::xohtml::test {

    Class TestPageBuilder -superclass ::xounit::TestCase

    TestPageBuilder parameter {

    }

    TestPageBuilder instproc setUp { } {

        my instvar builder environment

        set builder [ ::xohtml::PageBuilder newLanguage ]
        set environment [ $builder set environment ]
    }

    TestPageBuilder instproc testBasic { } {

        my instvar builder

        set page [ $builder buildPage { 

        } ]

        my assertObject $page page
        my assert [ $page hasclass ::xohtml::Page ]
    }

    TestPageBuilder instproc testContent { } {

        my instvar builder

        set page [ $builder writePage { 

                content { ' Hi }

        } /tmp/TestPageBuilder.html ]

        my assertObject $page page
        my assert [ $page hasclass ::xohtml::Page ]
        my assertFileExists /tmp/TestPageBuilder.html
        my assertEqualsByLine [ ::xox::readFile /tmp/TestPageBuilder.html ] { Hi }
    }

    TestPageBuilder instproc testModel { } {

        my instvar builder

        set page [ $builder writePage { 
                model {
                    - a 5
                }
                content { ' Hi $a }

        } /tmp/TestPageBuilder.html ]

        my assertObject $page page
        my assert [ $page hasclass ::xohtml::Page ]
        my assertFileExists /tmp/TestPageBuilder.html
        my assertEqualsByLine [ ::xox::readFile /tmp/TestPageBuilder.html ] { Hi 5 }
    }

    TestPageBuilder instproc testWritePage { } {

        my instvar builder

        set page [ $builder writePage { 

                SimpleWidget TestWidget {
                    aTitle TestWidget
                }

        } /tmp/TestPageBuilder.html ]

        my assertObject $page page
        my assert [ $page hasclass ::xohtml::Page ]
        my assertFileExists /tmp/TestPageBuilder.html
        my assertEqualsByLine [ ::xox::readFile /tmp/TestPageBuilder.html ] {
            <html><head><title>TestWidget</title></head><body></body></html>
        }
    }

    TestPageBuilder instproc testSimple { } {

        my instvar builder

        set page [ $builder buildPage { 

                SimpleWidget TestWidget {
                    aTitle TestWidget
                }
        } ]

        my assertObject $page page
        my assert [ $page hasclass ::xohtml::Page ]
        my assertObject [ $page TestWidget ]
        my assertObject [ $page contentWidget ]
        my assertEquals [ $page TestWidget aTitle ] TestWidget

        my assertEqualsByLine [ $page formatPage ] {
            <html><head><title>TestWidget</title></head><body></body></html>
        }
    }

    TestPageBuilder instproc testAddToModel { } {

        my instvar builder

        set model [ Object new ]

        my assertEquals [ $builder addToModel $model {
            - aTitle "A title"
        } ]  $model 

        my assertObject $model
        my assertEquals [ $model info class ] ::xotcl::Object
        my assertTrue [ $model exists aTitle ] title-not-found

        my assertObjectValues $model {
            aTitle "A title"
        }
    }

    TestPageBuilder instproc testAddToModel2 { } {

        my instvar builder environment

        set model [ Object new ]

        set builder [ ::xohtml::PageBuilder newLanguage -packages {xohtml xohtml::widget}]
        set environment [ $builder set environment ]

        $builder useObject $model

        $environment eval {
            - aTitle "A title"
        } 

        my assertEquals [ $builder set object ] $model wrong-model

        my assertObject $model model
        my assertEquals [ $model info class ] ::xotcl::Object
        my assertTrue [ $model exists aTitle ] title-not-found

        my assertObjectValues $model {
            aTitle "A title"
        }
    }

    TestPageBuilder instproc testBuildPageEmpty { } {

        my assertEqualsByLine [ ::xohtml::buildPage [ Object new ] { } ] {}
    }

    TestPageBuilder instproc testBuildPageSimpleWidget { } {

        my assertEqualsByLine [ ::xohtml::buildPage [ Object new ] { 
            SimpleWidget {
            }
        } ] { <html><head><title>SimpleWidget</title></head><body></body></html> }
    }

    TestPageBuilder instproc tearDown { } {

        #add tear down code here
    }
}


