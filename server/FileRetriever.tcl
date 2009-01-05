
namespace eval ::server { 

Class create FileRetriever -superclass { ::server::Application }
  
FileRetriever @doc FileRetriever {
Please describe FileRetriever here.
}
       
FileRetriever parameter {

} 
        

FileRetriever @doc initialLoad { 
initialLoad does ...
            response -
}

FileRetriever instproc initialLoad { response } {

        cd [ [ ::server::WebServer getInstance ] pwd ]

        puts [ pwd ]

        puts "FileRetriever [ my web ]"

        set filename [ string range [ my web ] 1 end ]

        set size [ file size $filename ]
        set file [ open $filename ]

        if [ regexp {.*\.css$} $filename ] {

            $response contentType "text/css"
        }

        if [ regexp {.*\.js$} $filename ] {

            $response contentType "text/javascript"
        }

        if [ regexp {.*\.png$} $filename ] {

            $response contentType "image/png"
            fconfigure $file -translation binary
        }

        $response size $size

        $response puts [ read $file ]
        close $file

        $response send200
}


FileRetriever @doc sendMessages { 
sendMessages does ...
}

FileRetriever instproc sendMessages {  } {
    
}
}


