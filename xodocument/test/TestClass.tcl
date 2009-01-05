# Created at Wed Jan 23 01:27:16 PM EST 2008 by bthomass

namespace eval ::xodocument::test {

    Class TestClass -superclass ::xounit::TestCase

    TestClass parameter {

    }

    TestClass instproc test { } {

        set c [ Class new ]

        set return [ $c @@doc aMethod {

            Author: Ben Thomasson
            Date: 1/1/1970

            Purpose: {

                Multiline purpose

                more purpose
            }

            Change: 1/2/1970 Minor fix
            Change: 1/3/1970 Subtle fix
            Change: 1/4/1970 Rewrite
        } ]

        my assertEquals $return ""

        my assertEquals [ $c set @author ] "{Ben Thomasson}"
        my assertEquals [ $c set @date ] 1/1/1970
        my assertEquals [ $c set @changes(1/2/1970) ] "{Minor fix}"
        my assertEquals [ $c set @changes(1/3/1970) ] "{Subtle fix}"
        my assertEquals [ $c set @changes(1/4/1970) ] "Rewrite"
        my assertEqualsByLine [ $c set #(aMethod) ] \
"Multiline purpose
more purpose"

    }

    TestClass instproc testError { } {

        set c [ Class new ]

        my assertNoError {

            $c @@doc aMethod {

                bad 1 2 3
            }
        }
    }
}


