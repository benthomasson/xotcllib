
namespace eval ::xogrid::test {

    namespace import -force ::xotcl::*

    Class TestMultipleProcess -superclass ::xounit::TestCase

    TestMultipleProcess instproc setUp { } {

        my instvar process

        catch {file delete test/port}

        set process [ ::xogrid::Process new -name "tclsh test/proxyserver" ]
        $process start
    }

    TestMultipleProcess instproc tearDown { } {

        my instvar process
        $process close
    }

    TestMultipleProcess instproc testConnectProxy { } {

        my instvar process

        while { ! [ file exists test/port ] } {

            after 1000
        }

        set proxy [ ::xogrid::Proxy new localhost [ ::xox::readFile test/port ] ]
        my assertEquals [ $proxy set var ] 5
        my assertEquals [ $proxy info class ] ::A
    }
}
