
namespace eval ::server { 

Class create IndexApplication -superclass { ::server::Application }
  
IndexApplication @doc IndexApplication {
Please describe IndexApplication here.
}
    
IndexApplication @doc title { }
   
IndexApplication parameter {
   { title IndexApplication }

} 
        

IndexApplication @doc initialLoad { 
initialLoad does ...
            response -
}

IndexApplication instproc initialLoad { response } {
        set map [ ApplicationWebMap getInstance ]

        my withHtml response {

            foreach { name } [ lsort [ $map info vars ]  ] {

                set application [ $map set $name ]

                $response puts "<a href=\"$name\">$name</a> -&gt; <a href=\"$name\">$application</a> <br />"
            }
        }
    
}


IndexApplication @doc sendMessages { 
sendMessages does ...
}

IndexApplication instproc sendMessages {  } {
    
}
}


