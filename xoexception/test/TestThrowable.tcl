
namespace eval ::xoexception::test {

    namespace import -force ::xotcl::*

::xotcl::Class TestThrowable -superclass ::xounit::TestCase 

TestThrowable instproc test { } {

    set t [ ::xoexception::Throwable new message ]
    my assert [ $t exists message ] 1
    my assertEquals [ $t message ] message
    my assert [ $t exists trace ]
    puts [ $t trace ]
}

}

