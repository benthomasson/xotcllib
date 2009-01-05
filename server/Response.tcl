
namespace eval ::server { 

Class create Response -superclass { ::xotcl::Object }
  
Response @doc Response {
Please describe Response here.
}
    
Response @doc channel { }

Response @doc ui { }

Response @doc out { }

Response @doc sessionId { }

Response @doc contentType { }

Response @doc request { }
   
Response parameter {
   {channel}
   {ui}
   { out "" }
   {sessionId}
   { contentType "text/html" }
   {request}
   size
} 
        

Response @doc puts { 
puts does ...
            string -
}

Response instproc puts { string } {
        my append out "$string\n"
}

Response instproc send { string } {
        my append out "$string"
}


Response @doc send200 { 
send200 does ...
}

Response instproc send200 {  } {
        my instvar channel

        puts "HTTP/1.1 200 OK"
        puts "Content-Type: [ my contentType ]"
        if [ my exists size ] { puts "Content-Length: [ my size ]" }
        puts "Connection: close"
        puts "Set-Cookie: XSESSIONID=[ my sessionId ]"

        flush stdout

        if [ catch {
            fconfigure $channel -translation binary
            puts $channel "HTTP/1.1 200 OK"
            puts $channel "Content-Type: [ my contentType ]"
            if [ my exists size ] { puts $channel "Content-Length: [ my size ]" }
            puts $channel "Connection: close"
            puts $channel "Set-Cookie: XSESSIONID=[ my sessionId ]"
            puts $channel ""
            puts $channel [ my out ]

            flush $channel
            close $channel
        } ] {

            global errorInfo
            puts $errorInfo
        }
    
}


Response @doc send401 { 
send401 does ...
            name -
}

Response instproc send401 { name } {
        my instvar channel

        if [ catch {

            puts $channel "HTTP/1.0 401 Unauthorized"
            puts $channel "WWW-Authenticate: Basic realm=\"$name\""
            puts $channel ""
            puts $channel "Unauthorized"
            puts $channel "[ my out ]"

            flush $channel
            close $channel
        } ] {

            global errorInfo
            puts $errorInfo
        }
    
}


Response @doc send404 { 
send404 does ...
}

Response instproc send404 {  } {
        my instvar channel

        catch {

            puts $channel "HTTP/1.1 404 Not Found"
            puts $channel "Connection: close"
            puts $channel ""
            puts $channel "Not Found"
            puts $channel "[ my out ]"

            flush $channel
            close $channel
        }
    
}
}


