
namespace eval ::server { 

Class create TelnetUserInterface -superclass { ::server::UserInterface }
  
TelnetUserInterface @doc TelnetUserInterface {
Please describe TelnetUserInterface here.
}
  
TelnetUserInterface instmixin add ::server::mixin::MessagePublisher 
  
TelnetUserInterface @doc socket { }

TelnetUserInterface @doc application { }

TelnetUserInterface @doc address { }

TelnetUserInterface @doc port { }

TelnetUserInterface @doc time { }

TelnetUserInterface @doc idle { }

TelnetUserInterface @doc state { }

TelnetUserInterface @doc command { }
   
TelnetUserInterface parameter {
   {socket}
   {application}
   {address}
   {port}
   {time}
   {idle}
   {state}
   {command}

} 
        

TelnetUserInterface @doc checkIdle { 
checkIdle does ...
}

TelnetUserInterface instproc checkIdle {  } {
        
        set idleTime [ expr {[ clock seconds ] - [ my idle ]} ] 

        if { $idleTime > 9000 } {

            my publishMessage "You have been idle too long."
            my sendMessages
            error "[ self ] idle"
        }
    
}


TelnetUserInterface @doc checkInput { 
checkInput does ...
}

TelnetUserInterface instproc checkInput {  } {
        set count [ gets [ my socket ] command ]

        if { $count != -1 } {

            my idle [ clock seconds ]
            [ my state ] processCommand [ self ] $command
        }

        my checkIdle
        my sendMessages
    
}


TelnetUserInterface @doc close { 
close does ...
}

TelnetUserInterface instproc close {  } {
        catch {

            [ my application ] removeMessageListener [ self ]
            [ CharacterManager getInstance ] addCharacter [ my application ] 

            puts [ my socket ] "Bye."
            flush [ my socket ]
        }
        close [ my socket ]
        [ Server getInstance ] removeConnection [ self ]
        my destroy
    
}


TelnetUserInterface @doc connectInfo { 
connectInfo does ...
}

TelnetUserInterface instproc connectInfo {  } {
        set idleTime [ clock format [ expr {[ clock seconds ] - [ my idle ]} ] -format %T -gmt 1 ]

        catch {
            set application ""
            set application [ my application ]
            set application [ [ my application ] name ]
        }


        return "[ self ] $application [ my address ]:[ my port ] [ my time ] $idleTime" 
    
}


TelnetUserInterface @doc init { 
init does ...
            socket - 
            address - 
            port -
}

TelnetUserInterface instproc init { socket address port } {
        next --noArgs

        my time [ clock format [ clock seconds ] ]

        my idle [ clock seconds ]

        my addMessageListener [ self ]

        my addChannel [ self ]

        my socket $socket
        my address $address
        my port $port
        my application [ Application new ]
        my command ""

        fconfigure $socket -blocking 0
        my state [ ::server::state::ExecState getInstance ]
        my . state . start [ self ]
        my sendMessages
    
}


TelnetUserInterface @doc processCommand { 
processCommand does ...
            command -
}

TelnetUserInterface instproc processCommand { command } {
        my append command $command
        my append command "\n"

        if { ![ info complete [ my command ] ] } { return }

        set command [ string trim [ my command ] ]
        my command ""

        set application [ my application ]

        ::xoexception::try {

            my publishMessage [ my runACommand "[ my application ] $command" ]
        } catch { ::server::ServerException result } {

            my publishMessage "[ $result message ]"
            return

        } catch { error result } {

            my publishMessage "Error: $result"
            return
        }
    
}


TelnetUserInterface @doc prompt { 
prompt does ...
}

TelnetUserInterface instproc prompt {  } {
        return [ [ my state ] prompt [ self ] ]
    
}


TelnetUserInterface @doc sendMessages { 
sendMessages does ...
}

TelnetUserInterface instproc sendMessages {  } {
        my displayMessages [ my socket ]
    
}
}


