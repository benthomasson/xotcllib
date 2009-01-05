# Created at Sat Nov 15 11:15:00 EST 2008 by ben

namespace eval ::xoweb {

    ::xox::SingletonClass create Authentication -superclass ::xotcl::Object

    Authentication @doc Authentication {

        Please describe the class Authentication here.
    }

    Authentication parameter {
        password
    }

    Authentication instproc init { } {

           my set users(bthomass) xoweb123
    }
    
    Authentication instproc checkAuthentication { sock realm user pass } {

        my instvar password

        if [ my exists password ] {
            if { "$pass" == "$password" } { return 1 }
        }

        if { ! [ my exists users($user) ] } { return 0 }
        return [ expr { "$pass" == "[ my set users($user) ]" } ]
    }

    proc checkAuthentication { sock realm user pass } {

        [ ::xoweb::Authentication getInstance ] checkAuthentication $sock $realm $user $pass
    }

    proc setPassword { password } {

        [ ::xoweb::Authentication getInstance ] password $password
    }
}


