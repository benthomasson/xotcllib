
namespace eval ::xounit::test {

    namespace import -force ::xotcl::*

    Class TestTestResultsWebFormatter -superclass ::xounit::test::TestTestResultsTextFormatter

    TestTestResultsWebFormatter instproc test {} {

        my instvar testResults

        my assert [ info exists testResults ] 1
        set formatter [ ::xounit::TestResultsWebFormatter new ]
        $formatter printResults $testResults

        return
    }

    TestTestResultsWebFormatter instproc testInit { } {

        set formatter [ ::xounit::TestResultsWebFormatter new ]

        set line "    ::xotcl::__#Ex ::xounit::TestCase->run"

        set object [ lindex $line 0 ]
        set classMethod [ lindex $line 1 ]

        set class [ lindex [ split $classMethod "->" ] 0 ]
        set method [ lindex [ split $classMethod "->" ] 2 ]
        
        my assertEquals $object ::xotcl::__#Ex
        my assertEquals $classMethod ::xounit::TestCase->run
        my assertEquals $class ::xounit::TestCase
        my assertEquals $method run 

        set line [ $formatter formatObjectClassMethodLine $line ]

        my assertEquals $line "    ::xotcl::__#Ex <a href=\"http://xotcllib.sourceforge.net/xodoc/_xounit_TestCase.html#run\">::xounit::TestCase-&gt;run </a>\n"
    }
}
