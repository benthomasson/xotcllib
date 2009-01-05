

namespace eval ::xodocument::test {

    Class TestSimpleDocInterpreter -superclass ::xounit::TestCase

    TestSimpleDocInterpreter parameter {

    }

    TestSimpleDocInterpreter instproc setUp { } {

        my instvar simpleDoc
        set simpleDoc  [ ::xodocument::SimpleDocLanguage newLanguage ]
    }

    TestSimpleDocInterpreter instproc testInit { } {
        my instvar simpleDoc
        my assertEquals [ $simpleDoc info class ] ::xodocument::SimpleDocLanguage ]
    }

    TestSimpleDocInterpreter instproc testEmpty { } {
        my instvar simpleDoc
        my assertEqualsTrim [ $simpleDoc evaluateDoc { } ] ""
    }

    TestSimpleDocInterpreter instproc testDocument { } {
        my instvar simpleDoc
        my assertXmlEquals [ $simpleDoc evaluateDoc {

            document Test { } 
        } ] \
"<document>
<title>Test</title>
</document>"

    }

    TestSimpleDocInterpreter instproc testBody { } {
        my instvar simpleDoc

        my assertXmlEquals [ $simpleDoc evaluateDoc {

            document Test {
                text { stuff }
            }
        } ] \
"<document>
<title>Test</title>
<text>
<body> stuff </body>
</text>
</document>" { } { } assertEqualsByLine 

    }

    TestSimpleDocInterpreter instproc testInnerCommand { } {
        my instvar simpleDoc

        my assertXmlEquals [ $simpleDoc evaluateDoc {
            document Test {
                , expr 1 + 1
            }
        } ]  \
"<document>
<title>Test</title>
2
</document>"
    }

    TestSimpleDocInterpreter instproc testRecursive { } {
        my instvar simpleDoc


        my assertXmlEquals [ $simpleDoc evaluateDoc {
            document Test {
               document Test { }
            }
        } ]  \
"<document>
<title>Test</title>
<document>
<title>Test</title>
</document> 
</document>"
    }

    TestSimpleDocInterpreter instproc testSection { } {
        my instvar simpleDoc


        my assertXmlEquals [ $simpleDoc evaluateDoc {
            document Test {
               section Test { } 
            }
        } ]  \
"<document>
<title>Test</title>
<section>
<title>Test</title>
<number>1 </number>
</section>
</document>"

    }

    TestSimpleDocInterpreter instproc testLink { } {
        my instvar simpleDoc


        my assertXmlEquals [ $simpleDoc evaluateDoc {
            document Test {
               link Google http://google.com
            }
        } ]  \
"<document>
<title>Test</title>
<link> <text>Google</text><href>http://google.com</href> </link> 
</document>"

    }

    TestSimpleDocInterpreter instproc testExample { } {
        my instvar simpleDoc


        my assertXmlEquals [ $simpleDoc evaluateDoc {
            document Test {
               example 1.1 { expr 1 + [ expr 1 + 1 ] } 
            }
        } ]  \
"<document>
<title>Test</title>
<example>
<title>1.1</title>
<body>expr 1 + \[ expr 1 + 1 \] </body>
</example> 
</document>"

    }

    TestSimpleDocInterpreter instproc testExampleRemoveLeftSpace { } {
        my instvar simpleDoc


        my assertXmlEquals [ $simpleDoc evaluateDoc {
            document Test {
               example 1.1 { 
                   expr 1 + [ expr 1 + 1 ] 
                   a
                   b
                   c
                   d
               } 
            }
        } ]  \
" <document>
    <title>Test</title>
    <example>
    <title>1.1</title>
    <body>
expr 1 + \[ expr 1 + 1 \] 
a
b
c
d
               </body>
</example> 
</document>" { } { } assertEqualsByLine

    }

    TestSimpleDocInterpreter instproc test2Sections { } {
        my instvar simpleDoc

        my assertXmlEquals [ $simpleDoc evaluateDoc {
            document "SimpleDoc Documentation Language" {

                section "Introduction" {

                }

                section "Getting Started" {

                }

                section Other {

                }

            }
        } ] \
"<document>
<title>SimpleDoc Documentation Language</title>
<section>
<title>Introduction</title>
<number>1 </number>
</section>
<section>
<title>Getting Started</title>
<number>2 </number>
</section>
<section>
<title>Other</title>
<number>3 </number>
</section>
</document>
"
    }

    TestSimpleDocInterpreter instproc testSubstitution { } {
        my instvar simpleDoc

        my assertXmlEquals [ $simpleDoc evaluateDoc {
            document "SimpleDoc Documentation Language" {

                text {
                    set a to [ set a 5 ]
                    1 + 1 is [ expr 1 + 1 ]
                    
                    Google can be found at [ link google.com http://www.google.com ]

                    [ escape <hi></hi> ]

                    a was set to $a
                }

                text {
                    a was set to $a
                }
            }
        } ] \
"<document>
<title>SimpleDoc Documentation Language</title>
<text>
<body>
set a to 5
1 + 1 is 2
Google can be found at <link> <text>google.com</text><href>http://www.google.com</href> </link>
&lt;hi&gt;&lt;/hi&gt;
a was set to 5
</body>
</text><text>
<body>
a was set to 5
</body>
</text>
</document>
" { } { } assertEqualsByLine
    }

    TestSimpleDocInterpreter instproc testField { } {
        my instvar simpleDoc

        my assertXmlEquals [ $simpleDoc evaluateDoc {
            document "Test Field" {

                Author "Ben Thomasson"
                Date [ clock format [ clock seconds ] ]
            }
        } ] \
"<document>
<title>Test Field</title>
<Author> Ben Thomasson </Author>
<Date> [ clock format [ clock seconds ] ] </Date>
</document>"
    }

    TestSimpleDocInterpreter instproc test@Doc { } {
        my instvar simpleDoc

        my assertXmlEquals [ $simpleDoc evaluateDoc {
            document "Test @Doc" {

                text {
                    [ @doc ::xotcl::Object unset ]
                }
            }
        } ] \
"<document>
<title>Test @Doc</title>
<text>
<body>
Delete variables.
unset ?-nocomplain? ?--? ?name name name ...?
Example:
set a 5
unset a
</body>
</text>
</document>" { } { } assertEqualsByLine
}

    TestSimpleDocInterpreter instproc testCommandReference { } {
        my instvar simpleDoc

        my assertXmlEquals [ $simpleDoc evaluateDoc {
            document "Test @Doc" {

                section "Doc" {

                    commandReference ::xodocument::test::TestSimpleDocInterpreter someMethod
                }
            }
        } ] \
"<document>
<title>Test @Doc</title>
<section>
<title>Doc</title>
<number>1 </number>
<command>
<name>someMethod</name>
<description>
Test method
</description>
<argument>
<name>a</name>
<explanation> description here </explanation>
</argument>
<argument>
<name>b</name>
<explanation></explanation>
</argument>
<argument>
<name>c</name>
<explanation></explanation>
</argument>
<return>none</return>
<example>.</example>
</command>
</section>
</document>" { } { } assertEqualsByLine 
}

    TestSimpleDocInterpreter @doc someMethod { Test method }

    TestSimpleDocInterpreter @arg someMethod a { description here }

    TestSimpleDocInterpreter instproc someMethod { a b c } {

    }


    TestSimpleDocInterpreter instproc testList { } {
        my instvar simpleDoc

        my assertXmlEquals [ $simpleDoc evaluateDoc {
            document "Test List" {

                orderedList {
                    a
                    b


                    c
                }

                unorderedList {

                    x - 1

                    y - 2

                    z - 3
                }
            }
        } ] \
"<document>
<title>Test List</title>
<orderedList>
<item>a</item>
<item>b</item>
<item>c</item>
</orderedList>
<unorderedList>
<item>x - 1</item>
<item>y - 2</item>
<item>z - 3</item>
</unorderedList>
</document>" {} {} assertEqualsTrim
}

    TestSimpleDocInterpreter instproc testExampleFail { } {
        my instvar simpleDoc

        $simpleDoc evaluateDoc {

            document "Neat Scripting Language(NSL) Users Guide" {

                section "Getting Started" {

                    example "NSL Script" {

                        XPurpose {

                        }       

                        [ xpath /parse/summary/fiveSecProcess ]
                    }
                }
            }
        }
    }

    TestSimpleDocInterpreter instproc exampleToInclude { } {

        set a 5

        my assertEquals $a 6

    }

    TestSimpleDocInterpreter instproc testIncludeExample { } {
        my instvar simpleDoc

        my assertXmlEquals [ $simpleDoc evaluateDoc {

            document "Neat Scripting Language(NSL) Users Guide" {

                    includeExample "Example" ::xodocument::test::TestSimpleDocInterpreter exampleToInclude
            }
        } ] \
{<document>
<title>Neat Scripting Language(NSL) Users Guide</title>
<example>
<title>Example</title>
<body>
set a 5

my assertEquals $a 6
</body>
</example>
</document>} {} {} assertEqualsByLine
    }

    TestSimpleDocInterpreter instproc testWiki { } {
        my instvar simpleDoc

        my assertXmlEquals [ $simpleDoc evaluateDoc {

            wikiSite http://wiki

            document "Neat Scripting Language(NSL) Users Guide" {

                wiki Hey There
            }
        } ] \
{
<document>
<title>Neat Scripting Language(NSL) Users Guide</title>
<link>
<text> Hey There </text> <href> http://wiki/Hey+There </href>
</link>
</document>
}
    }

    TestSimpleDocInterpreter instproc testError { } {
        my instvar simpleDoc

        my assertEquals [ my assertError {

            $simpleDoc evaluateDoc {
                notACommand
            }

        } ] "invalid command name \"notACommand\""
    }

    TestSimpleDocInterpreter instproc testParameterReference { } {
        my instvar simpleDoc

        ::xodocument::test::TestSimpleDocInterpreter @parameter testparam XYZ123

        my assertXmlEquals [ $simpleDoc evaluateDoc {

            document "Neat Scripting Language(NSL) Users Guide" {

                parameterList
                parameterReference ::xodocument::test::TestSimpleDocInterpreter testparam

            }
        } ] \
{
<document>
<title>Neat Scripting Language(NSL) Users Guide</title>
<parameterList/>
<parameter>
<name>testparam</name>
<description>
XYZ123
</description>
</parameter>
</document>
}
    }

    TestSimpleDocInterpreter instproc testXodoc { } {
        my instvar simpleDoc

        my assertXmlEquals [ $simpleDoc evaluateDoc {

            xodocSite http://xodoc

            document "Neat Scripting Language(NSL) Users Guide" {

                xodoc ::xort::NeatScriptLibrary
            }
        } ] \
{
<document>
<title>Neat Scripting Language(NSL) Users Guide</title>
<link>
<text> ::xort::NeatScriptLibrary </text> <href> http://xodoc/_xort_NeatScriptLibrary.html </href>
</link>
</document>
}
    }
}



