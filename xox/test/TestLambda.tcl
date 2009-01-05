
namespace eval ::xox::test { 

Class create TestLambda -superclass { ::xounit::TestCase }

TestLambda id {$Id: TestLambda.tcl,v 1.1.1.1 2007/07/31 22:54:08 bthomass Exp $}
  
TestLambda @doc TestLambda {
Please describe TestLambda here.
}
       
TestLambda parameter {

} 

TestLambda instproc testGenerateLambda { } {

    set lambda [ ::xox::Lambda generateLambda { arg } { 
        return [ expr { 1 + $arg } ]
    } ]

    my assertEquals [ info commands $lambda ] $lambda
    my assertNotEquals [ ::xox::Lambda nextName ] $lambda

    my assertEquals [ $lambda 4 ] 5

    ::xox::Lambda free $lambda

    my assertEquals [ info commands $lambda ] ""
}
        

}
