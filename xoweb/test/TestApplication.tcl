# Created at Thu Oct 23 11:18:19 EDT 2008 by ben

namespace eval ::xoweb::test {

    Class TestApplication -superclass ::xounit::TestCase

    TestApplication parameter {

    }

    TestApplication instproc setUp { } {

        my instvar applicationClass 
        set applicationClass [ ::xoweb::ApplicationClass new -superclass ::xoweb::Application ]
    }

    TestApplication instproc testInitialLoad { } {

        my instvar applicationClass

        $applicationClass instproc initialLoad { -a -b -c } { } {

            return [ list $a $b $c ]
        }

        my assertEquals [ $applicationClass processRequest { a 1 b 2 c 3 } ] [ list 1 2 3 ]
    }

    TestApplication instproc testMethod { } {

        my instvar applicationClass

        $applicationClass instproc aMethod { -a -b -c } { } {

            return [ list $a $b $c ]
        }

        my assertEquals [  $applicationClass processRequest { a 1 b 2 c 3 } ] {} 
        my assertEquals [  $applicationClass processRequest { a 1 b 2 c 3 method aMethod } ] [ list 1 2 3 ]
    }

    TestApplication instproc tearDown { } {

        #add tear down code here
    }
}


