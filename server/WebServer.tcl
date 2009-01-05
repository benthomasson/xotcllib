
namespace eval ::server { 

::server::SingletonClass create WebServer -superclass { ::xotcl::Object }
  
WebServer @doc WebServer {
Please describe WebServer here.
}
    
WebServer @doc simulator { }

WebServer @doc clock { }

WebServer @doc uis { }

WebServer @doc controlPort { }

WebServer @doc controlSocket { }

WebServer @doc telnetPort { }

WebServer @doc httpPort { }

WebServer @doc password { }

WebServer @doc passwordFile { }
   
WebServer parameter {
   {simulator}
   {clock}
   {uis ""}
   {controlPort}
   {controlSocket}
   { telnetPort 8000 }
   { httpPort 8080 }
   { password pass }
   { passwordFile password.txt }
   { pwd }
} 
        

WebServer @doc connect { 
connect does ...
            channel - 
            address - 
            port -
}

WebServer instproc connect { channel address port } {
        fconfigure $channel -encoding utf-8

        set ui [ TelnetUserInterface new $channel $address $port ]

        my lappend uis $ui
    
}


WebServer @doc init { 
init does ...
}

WebServer instproc init {  } {
        my instvar passwordFile

        my pwd [ pwd ]
        puts [ pwd ]

        set appMap [ ApplicationWebMap getInstance ]

        set reader [ ::xox::XmlNodeReader new ]
        $reader buildTree $appMap web.xml

        if [ file exists $passwordFile ] {

            my password [ string trim [ ::xox::readFile $passwordFile ] ]
        }

        my clock [ Clock getInstance ]
        my simulator [ Simulator getInstance ]
        my . simulator . maxRunTime 100
        my . clock . addClockListener [ my simulator ]
        my . clock . addClockListener [ Scheduler getInstance ]
        #my lappend uis [ LocalUserInterface new ]
        #socket -server "[ self ] connect" [ my telnetPort ]
        socket -server "[ self ] webConnect" [ my httpPort ]
}


WebServer @doc process { 
process does ...
}

WebServer instproc process {  } {
        while { 1 } {

            my processUserInterfaces

            my runSimulatorCommands

            [ my clock ] checkTick

            update 
            after 1
        }
    
}


WebServer @doc processUserInterfaces { 
processUserInterfaces does ...
}

WebServer instproc processUserInterfaces {  } {
        
        foreach ui [ my uis ] {

            if { ![ Object isobject $ui ] } { continue }

            if [ catch {

                $ui checkInput

            } result ] { 
                
                global errorInfo

                puts "WebServer Error [ self ] $result"
                puts "$errorInfo"

                my removeConnection $ui
                catch {
                $ui close
                }
            }
        }
    
}


WebServer @doc removeConnection { 
removeConnection does ...
            ui -
}

WebServer instproc removeConnection { ui } {
        set index [ lsearch -exact [ my uis ] $ui ]

        if { $index != -1 } {

            my uis [ lreplace [ my uis ] $index $index ] 
        }
    
}


WebServer @doc runSimulatorCommands { 
runSimulatorCommands does ...
}

WebServer instproc runSimulatorCommands {  } {
        if [ catch {

            [ my simulator ] runCommands
        } result ] { puts "WebServer Error [ self ] $result " }
    
}


WebServer @doc webConnect { 
webConnect does ...
            channel - 
            address - 
            port -
}

WebServer instproc webConnect { channel address port } {

        cd [ my pwd ]
        fconfigure $channel -blocking 0 -translation crlf -buffering none
        set ui [ [ WebUIFactory getInstance ] processCommand $channel ]

        if { [ lsearch [ my uis ] $ui ] == -1 } {

            my lappend uis $ui
        }
    
}
}


