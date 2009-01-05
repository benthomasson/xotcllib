
namespace eval ::server { 

Class create LocalUserInterface -superclass { ::server::UserInterface }
  
LocalUserInterface @doc LocalUserInterface {
Please describe LocalUserInterface here.
}
  
LocalUserInterface instmixin add ::server::mixin::MessagePublisher 
  
LocalUserInterface @doc application { }

LocalUserInterface @doc command { }
   
LocalUserInterface parameter {
   {application}
   {command}

} 
        

LocalUserInterface @doc checkInput { 
checkInput does ...
}

LocalUserInterface instproc checkInput {  } {
        if [ catch {

        set count [ gets stdin line ]

        if { $count != -1 } {

            my append command $line
            my append command "\n"

            if [ info complete [ my command ] ] {

                set command [ string trim [ my command ] ]
                my command ""

                my processCommand $command
            }
        }

        my displayMessages stdout

        } result ] {

            global errorInfo

            puts " Error [ self ] $result\n$errorInfo "
        }
    
}


LocalUserInterface @doc close { 
close does ...
}

LocalUserInterface instproc close {  } {
        puts "Oh well."
        flush stdout
        exit
    
}


LocalUserInterface @doc connectInfo { 
connectInfo does ...
}

LocalUserInterface instproc connectInfo {  } {
        return "[ [ my application ] name ] stdin/stdout/stderr" 
    
}


LocalUserInterface @doc init { 
init does ...
}

LocalUserInterface instproc init {  } {
        next 

        my channels ::save::character::creator

        my application [ TestServer new ]
        my addMessageListener [ self ]
        my addChannel [ self ]
        fconfigure stdin -blocking 0
        my displayMessages stdout
    
}


LocalUserInterface @doc processCommand { 
processCommand does ...
            command -
}

LocalUserInterface instproc processCommand { command } {
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

            global errorInfo

            puts "$application $command\n$result\n$errorInfo"
            my publishMessage "Error: $result"
            return
        }
    
}


LocalUserInterface @doc prompt { 
prompt does ...
}

LocalUserInterface instproc prompt {  } {
        return "[[ my application ] name ]>"
    
}


LocalUserInterface @doc sendMessages { 
sendMessages does ...
}

LocalUserInterface instproc sendMessages {  } {
        my displayMessages stdout
    
}
}


