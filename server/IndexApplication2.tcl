
namespace eval ::server { 

Class create IndexApplication2 -superclass { ::server::Application2 }
  
IndexApplication2 @doc IndexApplication2 {
Please describe IndexApplication2 here.
}
    
IndexApplication2 @doc title { }
   
IndexApplication2 parameter {
   { title IndexApplication2 }

} 
        

IndexApplication2 @doc initialLoad { 
initialLoad does ...
            response -
}

IndexApplication2 instproc initialLoad { response } {

        my instvar title

        set map [ ApplicationWebMap getInstance ]

        set vars [ lsort [ $map info vars ] ]

        $response puts [ my evalSubst {
            
            [ withHeadHtml2 $title { } {

                [ foreach name [ lsort [ $map info vars ] ] {

                    [ quiet { set application [ $map set $name ] } ]
                    <a href=\"$name\">$name</a> -&gt; <a href=\"$name\">$application</a> <br />
                } ]
            } ]
        } ]

        $response send200
}


IndexApplication2 @doc sendMessages { 
sendMessages does ...
}

IndexApplication2 instproc sendMessages {  } {
    
}
}


