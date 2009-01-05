
namespace eval ::tclisp { 

Object create ::tclisp::lambdas -requireNamespace

Class create Lambda -superclass { ::xotcl::Object }

Lambda id {$Id: Lambda.tcl,v 1.1.1.1 2007/12/01 04:34:10 bthomass Exp $}
  
Lambda @doc Lambda {
Please describe the class Lambda here.
}
       
Lambda parameter {

} 

Lambda parametercmd lambdaCount
Lambda parametercmd lambdaMap

Lambda proc getLambdaCount { } {

    if {! [ my exists lambdaCount ]} {

        my set lambdaCount 0
    }

    return [ my incr lambdaCount ]
}

Lambda proc generateLambda { arguments body } {

    set index [ list $arguments $body ]

    if [ my exists lambdaMap($index) ] {

        return [ my set lambdaMap($index) ]
    }

    set name [ my nextName ]

    proc $name $arguments $body

    my set lambdaMap($index) $name

    return $name
}

Lambda proc nextName { } {

     return "::tclisp::lambdas::lambda[ my getLambdaCount ]"
}

Lambda proc isLambda { function } {

    return [ string match ::tclisp::lambdas::lambda* $function ]
}

}


