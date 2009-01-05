
namespace eval ::xogrid::test {

    namespace import -force ::xotcl::*

    Class TestProxy -superclass ::xounit::TestCase

    TestProxy instproc setUp { } {

        my instvar o server port

        set o [ Object new ]
        set server [ ::xogrid::ProxyServer new 0 -object $o ]
        set port [ $server getPort ]

        after 3000
    }

    TestProxy instproc tearDown { } {

        my instvar o server

        $o destroy
        $server close
        $server destroy
    }

    TestProxy instproc testConnect {} {

        my instvar o server port
        set s [ ::xogrid::Proxy new localhost $port "$server updateClients" ]

        my assertEquals [ $s waitCallBack ] "$server updateClients" 
        $server updateClients
        my assert [ $server exists channels ] "server channels does not exist"
        my assertEquals [ llength [ $server channels ] ] 1
    }

    TestProxy instproc testCommand {} {

        my instvar o server port
        
        set s [ ::xogrid::Proxy new localhost $port "$server updateClients" ]
        my assertEquals [ $s waitCallBack ] "$server updateClients" 
        $server updateClients
        set return [ $s set a 5 ]

        my assertEquals $return 5
        my assert [ $o exists a ] "a does not exist"
        my assertEquals [ $o set a ] 5
    }

    TestProxy instproc testSetMultiLine {} {

        my instvar o server port

        set s [ ::xogrid::Proxy new localhost $port "$server updateClients" ]
        my assertEquals [ $s waitCallBack ] "$server updateClients" 
        $server updateClients
        $s set a {
            hey
        }
    }

    TestProxy instproc testError {} {

        my instvar o server port

        set s [ ::xogrid::Proxy new localhost $port "$server updateClients" ]
        my assertEquals [ $s waitCallBack ] "$server updateClients" 
        $server updateClients
        my assertError { $s a error } "Error not thrown"
    }
}
