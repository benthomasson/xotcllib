# Created at Wed Jan 23 08:13:24 EST 2008 by bthomass

namespace eval ::xodocument::test {

    Class TestClassDocLanguage -superclass ::xounit::TestCase

    TestClassDocLanguage parameter {

    }

    TestClassDocLanguage instproc setUp { } {

        my instvar language class method environment

        set class [ Class new ]
        set method aMethod
        set language [ ::xodocument::ClassDocLanguage newLanguage -docClass $class -method $method ]
        set environment [ $language set environment ]
    }

    TestClassDocLanguage instproc testSetup { } {

        my instvar language class method

        my assert [ my isclass $class ] 
        my assertEquals $method aMethod

        set a ""
        lappend a "x y z"

        my assertEquals $a "{x y z}"
    }

    TestClassDocLanguage instproc testEval { } {

        my instvar language class method environment


        $environment eval { Author: Ben Thomasson }
        my assertEquals [ $class set @author ] "{Ben Thomasson}"

        $environment eval { Author: Davie Jones }
        my assertEquals [ $class set @author ] "{Ben Thomasson} {Davie Jones}"

        $environment eval { Date: "1/1/1970" }
        my assertEquals [ $class set @date ] "1/1/1970"

        $environment eval {  Purpose: To go where no man has gone before. }
        my assertEquals [ $class set #(aMethod) ] "To go where no man has gone before."

        $environment eval { Example: {

            set a 5
            incr a
        }
        }

        my assertEqualsByLine [ $class set @example(aMethod) ] \
"set a 5
incr a"

        $environment eval { Tags: a b c }

        my assertEquals [ $class set @tag(aMethod) ] "a b c"

        $environment eval {  Change: 1/1/1970 Something happened }

        my assertEquals [ $class set @changes(1/1/1970) ] "{Something happened}" 

        $environment eval {  Change: 1/1/1970 Something else happened }

        my assertEquals [ $class set @changes(1/1/1970) ] "{Something happened} {Something else happened}"

        $environment eval {  Arguments: {

            a something here
            b 

            c {

                multiline

                after

            }

            d another arg
        } }

        my assertEquals [ $class set "@arg(aMethod a)" ] "something here"
        my assertEquals [ $class set "@arg(aMethod b)" ] ""
        my assertEqualsByLine [ $class set "@arg(aMethod c)" ] \
"multiline
after"
        my assertEquals [ $class set "@arg(aMethod d)" ] "another arg"


        $environment eval { Returns: {

            0 - if false
            1 - if true
        } }

        my assertEquals [ $class set "@return(aMethod)" ] {{0 - if false} {1 - if true}}

        $environment eval { Command: doX  }

        my assertEquals [ $class set "@command(aMethod)" ] doX

        my assertEquals [ $class set "@tag(aMethod)" ] {a b c}
        my assertEquals [ $class set "@tagged(a)" ] aMethod
        my assertEquals [ $class set "@tagged(b)" ] aMethod
        my assertEquals [ $class set "@tagged(c)" ] aMethod
   
    }

    TestClassDocLanguage instproc testCommands { } {

        my instvar language class method

        $language Author: Ben Thomasson
        my assertEquals [ $class set @author ] "{Ben Thomasson}"
        $language Author: Davie Jones
        my assertEquals [ $class set @author ] "{Ben Thomasson} {Davie Jones}"

        $language Date: "1/1/1970"
        my assertEquals [ $class set @date ] "1/1/1970"

        $language Purpose: To go where no man has gone before.
        my assertEquals [ $class set #(aMethod) ] "To go where no man has gone before."

        $language Example: {

            set a 5
            incr a
        }

        my assertEqualsByLine [ $class set @example(aMethod) ] \
"set a 5
incr a"

        $language Tags: a b c 

        my assertEquals [ $class set @tag(aMethod) ] "a b c"

        $language Change: 1/1/1970 Something happened

        my assertEquals [ $class set @changes(1/1/1970) ] "{Something happened}" 

        $language Change: 1/1/1970 Something else happened

        my assertEquals [ $class set @changes(1/1/1970) ] "{Something happened} {Something else happened}"

        $language Arguments: {

            a something here
            b 

            c {

                multiline

                after

            }

            d another arg
        }

        my assertEquals [ $class set "@arg(aMethod a)" ] "something here"
        my assertEquals [ $class set "@arg(aMethod b)" ] ""
        my assertEqualsByLine [ $class set "@arg(aMethod c)" ] \
"multiline
after"
        my assertEquals [ $class set "@arg(aMethod d)" ] "another arg"


        $language Returns: {

            0 - if false
            1 - if true
        }

        my assertEquals [ $class set "@return(aMethod)" ] {{0 - if false} {1 - if true}}

        $language Command: doX 

        my assertEquals [ $class set "@command(aMethod)" ] doX

        my assertEquals [ $class set "@tag(aMethod)" ] {a b c}
        my assertEquals [ $class set "@tagged(a)" ] aMethod
        my assertEquals [ $class set "@tagged(b)" ] aMethod
        my assertEquals [ $class set "@tagged(c)" ] aMethod
    }

    TestClassDocLanguage instproc testParameter { } {

        my instvar language class method

        set method [ namespace tail $class ]
        set language [ ::xodocument::ClassDocLanguage newLanguage -docClass $class -method $method ]

        $language Parameter: {

            a something here
            b 

            c {

                multiline

                after

            }

            d another arg
        }

        my assertEquals [ $class set "@parameter(a)" ] "something here"
        my assertEquals [ $class set "@parameter(b)" ] ""
        my assertEqualsByLine [ $class set "@parameter(c)" ] \
"multiline
after"
        my assertEquals [ $class set "@parameter(d)" ] "another arg"
    }

    TestClassDocLanguage instproc testParameterFail { } {

        my instvar language class method

        my assertEquals [ my assertError {

        $language Parameter: {

            a something here
            b 

            c {

                multiline

                after

            }

            d another arg
        }

        } ] "Parameter not valid on token aMethod, please change to [ namespace tail $class ] for $class"
    }

    TestClassDocLanguage instproc testParameterEval { } {

        my instvar language class method 

        set method [ namespace tail $class ]
        set language [ ::xodocument::ClassDocLanguage newLanguage -docClass $class -method $method ]
        set environment [ $language set environment ]

        $environment eval { Parameter: {

            a something here
            b 

            c {

                multiline

                after

            }

            d another arg
        } }

        my assertEquals [ $class set "@parameter(a)" ] "something here"
        my assertEquals [ $class set "@parameter(b)" ] ""
        my assertEqualsByLine [ $class set "@parameter(c)" ] \
"multiline
after"
        my assertEquals [ $class set "@parameter(d)" ] "another arg"
    }

    TestClassDocLanguage instproc testParameterFail { } {

        my instvar language class method environment

        my assertEquals [ my assertError {

        $environment eval { Parameter: {

            a something here
            b 

            c {

                multiline

                after

            }

            d another arg
        } }

        } ] "Parameter not valid on token aMethod, please change to [ namespace tail $class ] for $class"
    }
}


