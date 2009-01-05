# Created at Fri Feb 08 17:53:30 EST 2008 by bthomass

namespace eval ::server::test {

    Class TestHtmlGenerator -superclass ::xounit::TestCase

    TestHtmlGenerator parameter {

    }

    TestHtmlGenerator instproc setUp { } {

        my instvar generator

        set generator [ ::server::HtmlGenerator new ]
    }

    TestHtmlGenerator instproc testTd { } {

        my instvar generator

        my assertEqualsByLine [ $generator evalSubst {

            [td stuff] 
            
        } ] \
"
<td>stuff</td>
"
    }

    TestHtmlGenerator instproc testMultipleTd { } {

        my instvar generator

        my assertEqualsByLine [ $generator evalSubst {

            [td 1] 
            [td 2] 
            [td 3] 
            
        } ] \
"
<td>1</td>
<td>2</td>
<td>3</td>
"
    }

    TestHtmlGenerator instproc testTr { } {

        my instvar generator

        my assertEqualsByLine [ $generator evalSubst {

            [ tr {
                [td 1] 
                [td 2] 
                [td 3] 
                } ]
                
        } ] \
"
<tr>
<td>1</td>
<td>2</td>
<td>3</td>
</tr>
"
    }

    TestHtmlGenerator instproc testTable { } {

        my instvar generator

        my assertEqualsByLine [ $generator evalSubst {

                [table {
                    [tr {
                        [td 1]
                        [td 2]
                        [td 3]
                        }]
                }]
            
        } ] \
"
<table>
<tr>
<td>1</td>
<td>2</td>
<td>3</td>
</tr>
</table>
"
    }

    TestHtmlGenerator instproc testHtml { } {

        my instvar generator

        my assertEqualsByLine [ $generator evalSubst {

                [html {
                    [table {
                        [tr {
                            [td 1]
                            [td 2]
                            [td 3]
                            }]
                    }]
                }]
            
        } ] \
"
<html>
<table>
<tr>
<td>1</td>
<td>2</td>
<td>3</td>
</tr>
</table>
</html>
"
    }

    TestHtmlGenerator instproc testLink { } {

        my instvar generator

        my assertEqualsByLine [ $generator evalSubst {

            [td {
                [ link http://google.com Google ]
                }]
        } ] \
"
<td>
<a href=\"http://google.com\">Google</a>
</td>
"
    }

    TestHtmlGenerator instproc testName { } {

        my instvar generator

        my assertEqualsByLine [ $generator evalSubst {

            [td {
                [ name Here ]
                }]
        } ] \
"
<td>
<a name=\"Here\" />
</td>
"
    }

    TestHtmlGenerator instproc testH1H2H3 { } {

        my instvar generator

        my assertEqualsByLine [ $generator evalSubst {

            [ h1 { A B C } ]
            [ h2 { D E F } ]
            [ h3 { G H I } ]

        } ] \
"
<h1> A B C </h1>
<h2> D E F </h2>
<h3> G H I </h3>
"
    }

    TestHtmlGenerator instproc testVariables { } {

        my instvar generator

        set a A

        my assertEqualsByLine [ $generator evalSubst {

            [ h1 { $a B C } ]
            [ h2 { D E F } ]
            [ h3 { G H I } ]

        } ] \
"
<h1> A B C </h1>
<h2> D E F </h2>
<h3> G H I </h3>
"
    }

    TestHtmlGenerator instproc testQuotes { } {

        my instvar generator

        set a A

        my assertEqualsByLine [ $generator evalSubst {

            [ h1 { "$a" "B" C } ]
            [ h2 { D E F } ]
            [ h3 { G H I } ]

        } ] \
"
<h1> \"A\" \"B\" C </h1>
<h2> D E F </h2>
<h3> G H I </h3>
"
    }

    TestHtmlGenerator instproc testMenu { } {

        my instvar generator

        set a A

        my assertEqualsByLine [ $generator evalSubst {

            [ menu a b c e ]

        } ] \
"
<a href=\"a\">\[ b \]</a>
<a href=\"c\">\[ e \]</a>
"
    }

    TestHtmlGenerator instproc testFor { } {

        my instvar generator 

        set string [ $generator evalSubst {
            [ for { set i 0 } { $i < 10 } { incr i } {[identity $i]} ]
        } ]

        my assertEqualsTrim $string "0123456789"
    }

    TestHtmlGenerator instproc testForEach { } {

        my instvar generator 

        set string [ $generator evalSubst {

            [ foreach i { a b c d e f g } {[ identity $i ]} ]

        } ]

        my assertEqualsTrim $string "abcdefg"

    }

    TestHtmlGenerator instproc testWebForm { } {

        my instvar generator 

        set a 5
        set b 6

        set string [ $generator evalSubst {

            <td>
            $a

            [ webForm a b c {

                $b
                [td 1 ]
                [td 2 ]
                [td 3 ]
                
            } ]

            </td>
        } ]
        
        my assertEqualsByLine $string \
{
<td>
5
<form action="a" method="post" >
<input type="hidden" name="method" value="b" />
6
<td>1</td>
<td>2</td>
<td>3</td>
<input type="submit" value="c" />
</form>
</td>
}
    }

    TestHtmlGenerator instproc tearDown { } {

        #add tear down code here
    }
}


