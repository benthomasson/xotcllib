
namespace eval ::xogrid::test {

    namespace import -force ::xotcl::*

    Class TestLocalProxy -superclass ::xounit::TestCase

    TestLocalProxy instproc testInit {} {

        set o [ Object new ]
        set proxy [ ::xogrid::LocalProxy new $o ]

        my assertNotEquals $o $proxy
    }

    TestLocalProxy instproc testSet {} {

        set o [ Object new ]
        set proxy [ ::xogrid::LocalProxy new $o ]

        $proxy set a 5

        my assertEquals [ $proxy set a ] 5
        my assertEquals [ $o set a ] 5
    }

    TestLocalProxy instproc testMultiLineSet {} {
    
        set o [ Object new ]
        set proxy [ ::xogrid::LocalProxy new $o ]

        $proxy set a \
{1
2}
        my assertEquals [ $proxy set a ] "1\n2"
        my assertEquals [ $o set a ] "1\n2"
    }

    TestLocalProxy instproc testInfoClass {} {

        set o [ Object new ]
        set proxy [ ::xogrid::LocalProxy new $o ]

        my assertEquals [ $o info class ] ::xotcl::Object
        my assertEquals [ $proxy info class ] ::xotcl::Object
    }
}
