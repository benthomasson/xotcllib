
namespace eval ::xox { 

Object create ::xox::lambdas -requireNamespace

Class create Lambda -superclass { ::xotcl::Object }

Lambda id {$Id: Lambda.tcl,v 1.1.1.1 2007/07/31 22:54:07 bthomass Exp $}
  
Lambda @doc Lambda {
Please describe the class Lambda here.
}
       
Lambda parameter {

} 

Lambda parametercmd lambdaCount

Lambda proc getLambdaCount { } {

    if {! [ my exists lambdaCount ]} {

        my set lambdaCount 0
    }

    return [ my incr lambdaCount ]
}

Lambda proc generateLambda { arguments body } {

    set name [ my nextName ]

    proc $name $arguments $body

    return $name
}

Lambda proc nextName { } {

     return "::xox::lambdas::lambda[ my getLambdaCount ]"
}

Lambda proc free { lambda } {

    catch { rename $lambda {} }

    return $lambda
}

}


