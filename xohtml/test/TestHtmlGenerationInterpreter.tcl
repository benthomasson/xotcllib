# Created at Mon Jul 21 19:51:46 EDT 2008 by bthomass

namespace eval ::xohtml::test {

    Class TestHtmlGenerationInterpreter -superclass ::xounit::TestCase

    TestHtmlGenerationInterpreter parameter {

    }

    TestHtmlGenerationInterpreter instproc setUp { } {

        my instvar builder language environment

        set language [ ::xohtml::HtmlGenerationLanguage newLanguage ]
        set environment [ $language set environment ]
        set builder [ ::xodsl::StringBuilder new -language $language -environment $environment ]
    }

    TestHtmlGenerationInterpreter instproc testSetup { } {

        my instvar builder language environment

        my assertEquals [ $builder environment ] $environment
        my assertEquals [ $builder language ] $language
    }

    TestHtmlGenerationInterpreter instproc testSimple2 { } {

        my instvar builder language environment

        my assertEqualsByLine [ $builder buildString {
            ' "<html></html>"
        } ] {
            <html></html>
        }
    }

    TestHtmlGenerationInterpreter instproc testVariable2 { } {

        my instvar builder language environment

        $environment set title "A Title"

        my assertEqualsByLine [ $builder buildString {
           ' "<html>$title</html>"
        } ] {
            <html>A Title</html>
        }
    }

    TestHtmlGenerationInterpreter instproc testCall { } {

        my instvar builder language environment

        my assertEqualsByLine [ $builder buildString {
            html
        } ] {
            <html></html>
        }
    }

    TestHtmlGenerationInterpreter instproc testOption { } {

        my instvar builder language environment

        my assertEqualsByLine [ $builder buildString {
            div -id 123
        } ] {
            <div id="123" ></div>
        }
    }

    TestHtmlGenerationInterpreter instproc testInnerCall { } {

        my instvar builder language environment

        my assertEqualsByLine [ $builder buildString {
            div div
        } ] {
            <div><div></div></div>
        }
    }

    TestHtmlGenerationInterpreter instproc testBlock { } {

        my instvar builder language environment

        my assertEqualsByLine [ $builder buildString {
            div {
                div
            }
        } ] {
            <div><div></div></div>
        }
    }

    TestHtmlGenerationInterpreter instproc testTable { } {

        my instvar builder language environment

        my assertEqualsByLine [ $builder buildString {
            table {
                thead {
                    th ' a 
                    th ' b
                    th ' c
                }
                tbody {
                    tr {
                        th ' 1
                        td ' A1
                        td ' A2
                        td ' A3
                    }
                }
            }
        } ] {
            <table><thead><th>a</th><th>b</th><th>c</th></thead><tbody><tr><th>1</th><td>A1</td><td>A2</td><td>A3</td></tr></tbody></table>
     }
    }

    TestHtmlGenerationInterpreter instproc testTableForeach { } {

        my instvar builder language environment

        my assertEqualsByLine [ $builder buildString {
            table {
                thead {
                    foreach x { a b c } {
                        th ' $x
                    }
                }
                tbody {
                    tr {
                        th ' 1
                        foreach x {A1 A2 A3} {
                            td ' $x
                        }
                    }
                }
            }
        } ] {
            <table><thead><th>a</th><th>b</th><th>c</th></thead><tbody><tr><th>1</th><td>A1</td><td>A2</td><td>A3</td></tr></tbody></table>
     }
    }

    TestHtmlGenerationInterpreter instproc testCode { } {

        my instvar builder language environment

        my assertEqualsByLine [ $builder buildString {
            code ' {
                a b c
            }
        } ] {
            <code>
            a b c
            </code>
        }
    }

    TestHtmlGenerationInterpreter instproc testForeachCall { } {

        my instvar builder language environment

        my assertEqualsByLine [ $builder buildString {

            Object create ::o
            ::o set a 5

            foreach var [ ::o info vars ] {
                ' $var
            }
        } ] {a}
    }

    TestHtmlGenerationInterpreter instproc testMacroEmpty { } {

        my instvar builder language environment

        my assertEqualsByLine [ $builder buildString {
            macro divObject { body } {
                div -class object {
                    %body
                }
            }
            divObject {  }
        } ] { <div class="object" ></div> }
    }

    TestHtmlGenerationInterpreter instproc testMacroSimple { } {

        my instvar builder language environment

        my assertEqualsByLine [ $builder buildString {
            macro divObject { body } {
                div -class object {
                    %body
                }
            }
            divObject { ' Hi  }
        } ] { <div class="object" >Hi</div> }
    }

    TestHtmlGenerationInterpreter instproc testMacroScript { } {

        my instvar builder language environment

        my assertEqualsByLine [ $builder buildString {
            macro divObject { body } {
                div -class object {
                    %body
                }
            }
            divObject { 
                set list {1 2 3 4 5 6 7}
                foreach item $list {
                    ' $item
                }
            }
        } ] { <div class="object" >1234567</div> }
    }

    TestHtmlGenerationInterpreter instproc testInstMacroScript { } {

        ::xohtml::HtmlGenerationLanguage instmacro divObjectXYZ123 { body } {
            div -class object {
                %body
            }
        }

        set language [ ::xohtml::HtmlGenerationLanguage newLanguage ]
        set environment [ $language set environment ]
        set builder [ ::xodsl::StringBuilder new -language $language -environment $environment ]

        my assertEqualsByLine [ $builder buildString {
            divObjectXYZ123 { 
                set list {1 2 3 4 5 6 7}
                foreach item $list {
                    ' $item
                }
            }
        } ] { <div class="object" >1234567</div> }

        ::xohtml::HtmlGenerationLanguage instproc divObjectXYZ123 { body } {}
    }

    TestHtmlGenerationInterpreter instproc tearDown { } {

        #add tear down code here
    }
}


