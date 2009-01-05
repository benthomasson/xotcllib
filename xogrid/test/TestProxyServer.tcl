
namespace eval ::xogrid::test {

    namespace import -force ::xotcl::*

    Class TestProxyServer -superclass ::xounit::TestCase

    TestProxyServer instproc setUp { } {

        my instvar o server port

        set o [ Object new ]
        set server [ ::xogrid::ProxyServer new 0 -object $o ]
        set port [ $server getPort ]
    }

    TestProxyServer instproc tearDown { } {

        my instvar o server

        $o destroy
        $server close
        $server destroy
    }

    TestProxyServer instproc testUpdateClientsNone {} {

        my instvar o server
        $server updateClients
    }

    TestProxyServer instproc testConnect {} {

        my instvar o server port
        set s [ socket localhost $port ]
        $server updateClients
        my assert [ $server exists channels ] "server channels does not exist"
        my assertEquals [ llength [ $server channels ] ] 1
        my assertEquals [ $server getPort ] $port
    }

    TestProxyServer instproc testCommand {} {

        my instvar o server port
        
        set s [ socket localhost $port ]
        puts $s "execute set a 5"
        flush $s
        $server updateClients
        set return [ gets $s ]

        my assertEquals $return "{return {5}}"
        my assertEquals [ $o set a ] 5
    }

    TestProxyServer instproc testNoCommand {} {

        my instvar o server port
        
        set s [ socket localhost $port ]
        $server updateClients
    }

    TestProxyServer instproc testCloseConnection {} {

        my instvar o server port
        
        set s [ socket localhost $port ]
        close $s
        $server updateClients
    }
}
