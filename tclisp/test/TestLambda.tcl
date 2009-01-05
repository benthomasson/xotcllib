
namespace eval ::tclisp::test { 

Class create TestLambda -superclass { ::xounit::TestCase }

TestLambda id {$Id: TestLambda.tcl,v 1.1.1.1 2007/12/01 04:34:10 bthomass Exp $}
  
TestLambda @doc TestLambda {
Please describe TestLambda here.
}
       
TestLambda parameter {

} 

TestLambda instproc testGenerateLambda { } {

    set lambda [ ::tclisp::Lambda generateLambda { arg } { 
        return [ expr { 1 + $arg } ]
    } ]

    my assertEquals [ info commands $lambda ] $lambda
    my assertNotEquals [ ::tclisp::Lambda nextName ] $lambda

    my assertEquals [ $lambda 4 ] 5

    my assert [ ::tclisp::Lambda isLambda $lambda ]
    my assertFalse [ ::tclisp::Lambda isLambda xyz ]
}

TestLambda instproc testLongIndexNames { } {

    set name {{ a b c} {puts $a [ incr b ] $c
    puts hi
    puts ho
    puts "$b hey"}}

    set a($name) 1

    my assertEquals $a($name) 1
    my assertEquals [ set a($name) ] 1
}

TestLambda instproc testMemoization { } {

    set lambda [ ::tclisp::Lambda generateLambda { arg } { 
        return [ expr { 1 + $arg } ]
    } ]
    
    set lamada2 [ ::tclisp::Lambda generateLambda { arg } { 
        return [ expr { 1 + $arg } ]
    } ]

    my assertEquals $lambda $lamada2

    my assertEquals [ $lambda 4 ] 5
}
        

}
