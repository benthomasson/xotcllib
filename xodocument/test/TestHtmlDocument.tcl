
namespace eval ::xodocument::test { 

Class create TestHtmlDocument -superclass { ::xounit::TestCase }
  
TestHtmlDocument @doc TestHtmlDocument {
Please describe TestHtmlDocument here.
}
       
TestHtmlDocument parameter {

} 
        

TestHtmlDocument @doc test { 
test does ...
}

TestHtmlDocument instproc notest {  } {
        set doc [ ::xodocument::HtmlDocument new ]

        $doc project "XOUnit"
        #$doc namespaces { ::xounit::* ::xodocument::* }

        $doc generateDoc xodoc 

        my assertTrue [ file exists xodoc ]
        my assertTrue [ file isdirectory xodoc ]
    
}
}


