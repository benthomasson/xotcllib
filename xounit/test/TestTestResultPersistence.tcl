
namespace eval ::xounit::test {

    namespace import -force ::xotcl::*

    Class TestTestResultPersistence -superclass ::xounit::TestCase

    TestTestResultPersistence instproc test {} {

        set writer [ ::xox::XmlNodeWriter new ]
        set reader [ ::xox::XmlNodeReader new ]
        set result [ ::xounit::TestResult new -name Result ]
        set root [ ::xox::Node new ]

        set result [ $root addNode $result ]
        
        set xml [ $writer generateXml $root ]

        puts $xml

        set newRoot [ ::xox::Node new ]

        my assertEquals [ llength [ $newRoot nodes ] ] 0
        $reader buildNodes $newRoot $xml
        my assertEquals [ llength [ $newRoot nodes ] ] 1

        set newResult [ $root nodes ]

        my assertEquals [ $newResult name ] Result
        my assertEquals [ $newResult info class ] ::xounit::TestResult
    }

    TestTestResultPersistence instproc testTree {} {

        set writer [ ::xox::XmlNodeWriter new ]
        set reader [ ::xox::XmlNodeReader new ]
        set result [ ::xounit::TestResult new -name Result ]
        set root [ ::xox::Node new ]

        set result [ $root addNode $result ]
        $result addResult [ ::xounit::TestResult new -name Result ]
        $result addResult [ ::xounit::TestPass new -name Pass \
                                -test A \
                                -return 1 ]
        $result addResult [ ::xounit::TestFailure new -name Failure \
                                -test B \
                                -error 2 ]
        $result addResult [ ::xounit::TestError new -name Error \
                                -test C \
                                -error 3 ]
        
        set xml [ $writer generateXml $root ]

        my debug $xml

        set newRoot [ ::xox::Node new ]

        my assertEquals [ llength [ $newRoot nodes ] ] 0
        $reader buildNodes $newRoot $xml
        my assertEquals [ llength [ $newRoot nodes ] ] 1

        set newResult [ $root nodes ]

        my assertEquals [ $newResult name ] Result
        my assertEquals [ $newResult info class ] ::xounit::TestResult

        set sub [ lindex [ $newResult results ] 0 ]
        my assertEquals [ $sub name ] Result
        my assertEquals [ $sub info class ] ::xounit::TestResult
        my assertNotEquals $sub $newResult

        set sub [ lindex [ $newResult results ] 1 ]
        my assertEquals [ $sub name ] Pass
        my assertEquals [ $sub test ] A
        my assertEquals [ $sub message ] 1
        my assertEquals [ $sub info class ] ::xounit::TestPass
        my assertNotEquals $sub $newResult

        set sub [ lindex [ $newResult results ] 2 ]
        my assertEquals [ $sub name ] Failure
        my assertEquals [ $sub message ] 2
        my assertEquals [ $sub info class ] ::xounit::TestFailure
        my assertNotEquals $sub $newResult

        set sub [ lindex [ $newResult results ] 3 ]
        my assertEquals [ $sub name ] Error
        my assertEquals [ $sub message ] 3
        my assertEquals [ $sub info class ] ::xounit::TestError
        my assertNotEquals $sub $newResult
    }
}
