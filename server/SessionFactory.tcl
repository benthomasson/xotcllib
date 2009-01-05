
namespace eval ::server { 

Class create SessionFactory -superclass { ::xotcl::Object }
  
SessionFactory @doc SessionFactory {
Please describe SessionFactory here.
}
       
SessionFactory parameter {

} 
        

SessionFactory @doc buildSession { 
buildSession does ...
            request - 
            response -
}

SessionFactory instproc buildSession { request response } {
        set id [ my getID $request $response ]

        if [ my exists sessions($id) ] {

            set session [ my set sessions($id) ]

            $session incr count

            return $session
        }

        set session [ Session new ]
        $session id $id 
        $session count 0
        my set sessions($id) $session
        return $session
    
}


SessionFactory @doc generateID { 
generateID does ...
}

SessionFactory instproc generateID {  } {
        set id [ expr round( 10000 * rand() ) ]

        while { [ my exists sessions($id) ] } {

            set id [ expr round( 10000 * rand() ) ]
        }

        return $id
    
}


SessionFactory @doc getID { 
getID does ...
            request - 
            response -
}

SessionFactory instproc getID { request response } {
        #puts getID

        if { ! [ $request exists Cookie ] } {

            #puts "no Cookie"

            set id [ my generateID ]
            $response set sessionId $id
            return $id
        }

        set cookieString [ $request set Cookie ] 

        #puts "Cookie: $cookieString"

        foreach cookie [ split $cookieString ";" ] {

            set cookie [ split $cookie "=" ]

            set name [ lindex $cookie 0 ]
            set value [ lindex $cookie 1 ]

            if { "$name" == "XSESSIONID" } {

                if { [ my exists sessions($value) ] } {

                    $response set sessionId $value
                    return $value

                } else {

                    set id [ my generateID ]
                    $response set sessionId $id
                    return $id
                }
            }
        }

        set id [ my generateID ]
        $response set sessionId $id
        return $id
    
}
}


