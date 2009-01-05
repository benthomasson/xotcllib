
namespace eval ::xodocument { 

Class create UsersGuide -superclass { ::xotcl::Object }
  
UsersGuide @doc UsersGuide {
UsersGuide is a special base class that is
        used to create in code-documentation for 
        users of the code.  The formatting of the
        html document will be different than normal
        pages.
}
       
UsersGuide parameter {

}

UsersGuide instproc crossLink { package text } {

    regsub -all {\&} "$data" {\&amp;} data


    return $text
}

}


