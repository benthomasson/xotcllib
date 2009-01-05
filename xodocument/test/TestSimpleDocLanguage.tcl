# Created at Mon Jan 07 13:40:52 EST 2008 by bthomass

namespace eval ::xodocument::test {

    Class TestSimpleDocLanguage -superclass ::xounit::TestCase

    TestSimpleDocLanguage parameter {

    }

    TestSimpleDocLanguage instproc testRemoveLeftSpace { } {


        set lang [ ::xodocument::SimpleDocLanguage newLanguage ]

        my assertEquals [ $lang removeLeftSpace "     a b c" ] "a b c"

        my assertEquals [ $lang removeLeftSpace " a b c\n d e f\n g h i" ] "a b c\nd e f\ng h i"
        my assertEquals [ $lang removeLeftSpace " a b c\nd e f\n g h i" ] "a b c\nd e f\ng h i"
        my assertEquals [ $lang removeLeftSpace "  a b c\n d e f\n  g h i" ] "a b c\n d e f\ng h i"
    }

    TestSimpleDocLanguage instproc testWiki { } {


        set lang [ ::xodocument::SimpleDocLanguage newLanguage -wikiSite unknown ]

        my assertEqualsByLine [ $lang evaluateDoc { wiki A B C } ] \
{
    <link>
    <text> A B C </text> <href> unknown/A+B+C </href>
    </link>
}
    }

    TestSimpleDocLanguage instproc testExecutable { } {


        set lang [ ::xodocument::SimpleDocLanguage newLanguage  ]

        my assertEqualsByLine [ $lang evaluateDoc { executable abc {does abc} {a b c} {x y z} { } {abc -a 1 -b 2 -c 3 4 5 6} }  ] \
{
    <command>
    <name>abc</name>
    <description>
    does abc
    </description>
    <positionalArgument>
    <name>a</name><type>optional</type>
    <explanation></explanation>
    </positionalArgument>
    <positionalArgument>
    <name>b</name><type>optional</type>
    <explanation></explanation>
    </positionalArgument>
    <positionalArgument>
    <name>c</name><type>optional</type>
    <explanation></explanation>
    </positionalArgument>

    <argument>
    <name>x</name>
    <explanation></explanation>
    </argument>
    <argument>
    <name>y</name>
    <explanation></explanation>
    </argument>
    <argument>
    <name>z</name>
    <explanation></explanation>
    </argument>

    <return> </return>
    <example>abc -a 1 -b 2 -c 3 4 5 6</example>
    </command>
}
    }
}


