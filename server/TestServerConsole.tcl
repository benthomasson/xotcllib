
namespace eval ::server { 

Class create TestServerConsole -superclass { ::server::Application ::xounit::TestRunner }
  
TestServerConsole @doc TestServerConsole {
Please describe TestServerConsole here.
}
  
TestServerConsole instmixin add ::server::DisplayMessage 
TestServerConsole instmixin add ::xounit::TestResultsTextFormatter 
TestServerConsole instmixin add ::server::mixin::MessagePublisher 
  
TestServerConsole @doc scheduler { }

TestServerConsole @doc state { }

TestServerConsole @doc messages { }

TestServerConsole @doc waitResponse { }

TestServerConsole @doc command { }
   
TestServerConsole parameter {
   {scheduler}
   {state}
   {messages}
   {waitResponse}
   {command}

} 
        

TestServerConsole @doc after { 
after does ...
            time - 
            class -
}

TestServerConsole instproc after { time class } {
         set waitTime [ clock scan $time -base 0 ] 
         my . scheduler . scheduleCommand $waitTime "[ self ] run $class"
    
}


TestServerConsole @doc at { 
at does ...
            time - 
            class -
}

TestServerConsole instproc at { time class } {
         set waitTime [ expr [ clock scan $time ] - [ clock seconds ] ]
         my . scheduler . scheduleCommand $waitTime "[ self ] run $class"
    
}


TestServerConsole @doc getTextResults { 
getTextResults does ...
}

TestServerConsole instproc getTextResults {  } {
        return [ my formatResults [ my results ] ]
    
}


TestServerConsole @doc init { 
init does ...
}

TestServerConsole instproc init {  } {
        my messages ""
        my addMessageListener [ self ]
        my addChannel [ self ]
        my scheduler [ Scheduler getInstance ]
        my state [ ::server::state::ExecState getInstance ]
        my . state . start [ self ]
    
}


TestServerConsole @doc initialLoad { 
initialLoad does ...
            response -
}

TestServerConsole instproc initialLoad { response } {
        $response puts "<html>"
        $response puts "<script>

  var messageReq;
  var promptReq;
  var executeReq;
  var commandHistory = new Array();
  var commandIndex = 0;
  var which;

  function promptAndMessage() {

      sendPrompt();
      sendMessage();
  }

  function sendPrompt() {
    promptReq = new XMLHttpRequest();
    promptReq.onreadystatechange = promptStateChange;
    try {
      promptReq.open(\"GET\", '[ my web ]?method=prompt' , true);
    } catch (e) {
      alert(e);
    }
    promptReq.send(null);
  }
  
  function sendMessage() {
    messageReq = new XMLHttpRequest();
    messageReq.onreadystatechange = messagesStateChange;
    try {
      messageReq.open(\"GET\", '[ my web ]?method=webMessages' , true);
    } catch (e) {
      alert(e);
    }
    messageReq.send(null);
  }

  function messagesStateChange() {
    if (messageReq.readyState == 4) { // Complete
      if (messageReq.status == 200) { // OK response
        if ( document.getElementById(\"messages\").innerHTML.length > 20000 ) {
            document.getElementById(\"messages\").innerHTML = \"\"
        }
        document.getElementById(\"messages\").innerHTML += messageReq.responseText;
        sendMessage();
        sendPrompt();
        document.form.args.focus();
        document.body.scrollTop = 1000000;
      } else {
        alert(\"Problem: \" + messageReq.statusText);
      }
    }
  }

  function promptStateChange() {
    if (promptReq.readyState == 4) { // Complete
      if (promptReq.status == 200) { // OK response
        document.getElementById(\"prompt\").innerHTML = promptReq.responseText;
      } else {
        alert(\"Problem: \" + promptReq.statusText);
      }
    }
  }

  function executeStateChange() {
    if (executeReq.readyState == 4) { // Complete
      if (executeReq.status == 200) { // OK response
        promptAndMessage();
      } else {
        alert(\"Problem: \" + executeReq.statusText);
      }
    }
  }

  function formSubmitted() {
      var submit;
      submit = 'method=' + encodeURIComponent( document.form.method.value );
      submit += '&args=' + encodeURIComponent( document.form.args.value );
      commandHistory.push( document.form.args.value );
      commandIndex = commandHistory.length - 1;
      document.form.reset();
      executeReq = new XMLHttpRequest();
      executeReq.onreadystatechange = executeStateChange;
      try {
         executeReq.open(\"GET\", '[ my web ]?' + submit , true);
      } catch (e) {
         alert(e);
      }
      executeReq.send(null);
  }

  function getCommandHistory(textbox,event) {

      if ( event.keyCode == 38 ) {
          textbox.value = commandHistory\[commandIndex\];
          commandIndex--;
      } else if ( event.keyCode == 40 ) {
          commandIndex++;
          textbox.value = commandHistory\[commandIndex\];
      }
  }
  
</script>"
        $response puts "<body bgcolor=\"black\" text=\"white\" onLoad=\"promptAndMessage();\" >"
        $response puts "\n"
        $response puts "<span id=\"messages\"></span>"
        $response puts "
<form method=\"post\" action=\"javascript:formSubmitted();\" name=\"form\">
<input type=\"hidden\" name=\"method\" value=\"webCommand\">
<span id=\"prompt\"></span><input type=\"text\" name=\"args\" value=\"\" size=\"80\" onkeydown=\"getCommandHistory(this,event)\" />
</form>"

        $response send200
    
}


TestServerConsole @doc name { 
name does ...
}

TestServerConsole instproc name {  } {
        return [ my info class ]
    
}


TestServerConsole @doc processCommand { 
processCommand does ...
            command -
}

TestServerConsole instproc processCommand { command } {
        puts "processCommand $command"

        my append command $command
        my append command "\n"

        if { ![ info complete [ my command ] ] } { return }

        set command [ string trim [ my command ] ]
        my command ""

        ::xoexception::try {

            my publishMessage [ eval "[ self ] $command" ]
            
        } catch { ::server::ServerException result } {

            my publishMessage "[ $result message ]"
            return

        } catch { error result } {

            my publishMessage "Error: $result"
            return
        }
    
}


TestServerConsole @doc prompt { 
prompt does ...
            response -
}

TestServerConsole instproc prompt { response } {
        puts prompt

        $response puts "[ [ my state ] prompt [ self ] ]"
        $response send200
    
}


TestServerConsole @doc require { 
require does ...
            package -
}

TestServerConsole instproc require { package } {
        return [ package require $package ]
    
}


TestServerConsole @doc run { 
run does ...
            class -
}

TestServerConsole instproc run { class } {
         my runTests $class
    
}


TestServerConsole @doc sendMessages { 
sendMessages does ...
}

TestServerConsole instproc sendMessages {  } {
        #puts "Messages: [ my messages ]"

        if { [ my messages ] != "" } {

            if [ my exists waitResponse ] {

                #puts sendMessages
                #puts ":[ my messages ]:"

                my sendWebMessages [ my waitResponse ]
                my unset waitResponse
            }
        }
    
}


TestServerConsole @doc sendWebMessages { 
sendWebMessages does ...
            response -
}

TestServerConsole instproc sendWebMessages { response } {
        set fullMessage ""

        set messages [ my messages ]
        my messages ""

        $response puts "<pre>"
        $response puts $messages
        $response puts "</pre>"

        $response send200
    
}


TestServerConsole @doc webCommand { 
webCommand does ...
            response - 
            args -
}

TestServerConsole instproc webCommand { response args } {
        puts "webCommand $args"

        [ my state ] processCommand [ self ] "$args"

        $response send200
    
}


TestServerConsole @doc webMessages { 
webMessages does ...
            response -
}

TestServerConsole instproc webMessages { response } {
        puts webMessages

        if [ my exists waitResponse ] {

            #puts "send empty response"
            [ my waitResponse ] send200
            [ my waitResponse ] destroy
            my unset waitResponse 
        }

        if { [ my messages ] == "" } {

            #puts "save response"

            my waitResponse $response
            return
        }

        my sendWebMessages $response
    
}
}


