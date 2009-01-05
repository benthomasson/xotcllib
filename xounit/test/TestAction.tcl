# Created at Thu Jun 14 09:46:31 EDT 2007 by bthomass


namespace eval ::xounit::test {

    namespace import -force ::xotcl::*

    Class TestAction -superclass ::xounit::TestCase

    TestAction parameter {

    }

    TestAction instproc test { } {

        my instvar actor

        set actor [ ::xounit::TestCase new ]
        $actor mixin ::xounit::Action

        $actor proc doSomething { } {

            return 5
        }

        my assertEquals [ $actor doSomething ] 5

        set result [ $actor executeActionReturnResult doSomething ] 

        #my debug [ $result dumpTreeData ]
        my assertEquals [ ${result}::TestFinished return ] 5
    }

    TestAction instproc testError { } {

        my instvar actor

        my test

        $actor proc doError { } {

            error "An error occurred"
        }

        my assertError { 

            $actor doError
        }

        set result [ $actor executeActionReturnResult doError ] 

        #my debug [ $result dumpTreeData ]
        my assertEquals \
            [ ::xox::first [ split [ ${result}::TestError message ] "\n" ] ] \
            "An error occurred"
    }

    TestAction instproc testFailure { } {

        my instvar actor

        my test

        $actor proc doFailure { } {

            my fail "I failed"
        }

        my assertFailure { 

            $actor doFailure
        }

        set result [ $actor executeActionReturnResult doFailure ] 

        #my debug [ $result dumpTreeData ]
        my assertEquals \
            [ ${result}::TestFailure message ] \
            "I failed"
    }
}


