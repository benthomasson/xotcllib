
namespace eval ::server { 

Class create TestableServer -superclass { ::server::WebServer }
  
TestableServer @doc TestableServer {
TestableServer is a WebServer with limited functionality
        so it can be tested.
}
       
TestableServer parameter {

} 
        

TestableServer @doc init { 
init does ...
}

TestableServer instproc init {  } {
        set appMap [ ApplicationWebMap getInstance ]

        set reader [ ::xox::XmlNodeReader new ]
        $reader buildTree $appMap web.xml

        my clock [ Clock getInstance ]
        my simulator [ Simulator getInstance ]
        my . simulator . maxRunTime 100
        my . clock . addClockListener [ my simulator ]
        my . clock . addClockListener [ Scheduler getInstance ]
        my lappend uis [ LocalUserInterface new ]
}


TestableServer @doc processOneRound { 
processOneRound does ...
}

TestableServer instproc processOneRound {  } {
        my processUserInterfaces

        my runSimulatorCommands

        [ my clock ] checkTick

        update 
    
}
}


