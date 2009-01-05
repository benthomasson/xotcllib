
namespace eval ::server { 

::server::SingletonClass create WebUIFactory -superclass { ::server::SessionFactory }
  
WebUIFactory @doc WebUIFactory {
Please describe WebUIFactory here.
}
    
WebUIFactory @doc readDelay { }
   
WebUIFactory parameter {
   { readDelay 10 }

} 
        

WebUIFactory @doc buildSession { 
buildSession does ...
            request - 
            response -
}

WebUIFactory instproc buildSession { request response } {
        set id [ my getID $request $response ]

        if [ my exists sessions($id) ] {

            set session [ my set sessions($id) ]
            return $session
        }

        set session [ WebUserInterface new ]
        $session id $id 
        my set sessions($id) $session
        return $session
    
}


WebUIFactory @doc processCommand { 
processCommand does ...
            channel -
}

WebUIFactory instproc processCommand { channel } {
        my instvar readDelay

        set request [ ::server::Request new ]
        set response [ Response new -channel $channel ]

        set command ""

        set misReadCount 0

        while { $misReadCount < 10 } {

	    puts "misReadCount: $misReadCount"

            if [ eof $channel ] { puts eof; break }
            if [ fblocked $channel ] { puts fblocked; break } 

            set nextCommand [ read $channel ]
	    puts "nextCommand: $nextCommand"
            if { "" != "$command" } {
                if { "" == "$nextCommand" } { incr misReadCount } 
            }
            append command $nextCommand

            after $readDelay
        }

        puts "WebUIFactory command: $command"

        set split [ split $command "\n" ]
        
        $request set action [ lindex $split 0 ]

        #bugged here, what if body has a : in it???

        foreach line [ lrange $split 1 end ] {

            if { [ string first : $line ] == -1 } {

                $request append body $line
                $request append body "\n"
                continue
            }

            set nameValue [ split $line ":" ]

            set name [ lindex $nameValue 0 ]
            set value [ string trim [ join [ lrange $nameValue 1 end ] : ] ]
            $request set $name $value
        }

        set ui [ my buildSession $request $response ]
        
        $ui processRequest $request $response

        return $ui
    
}


WebUIFactory @doc removeSession { 
removeSession does ...
            id -
}

WebUIFactory instproc removeSession { id } {
        my set sessions($id) ""
        my unset sessions($id) 
    
}
}


