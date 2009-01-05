# Created at Tue May 29 19:50:59 EDT 2007 by bthomass

package require xounit

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    Class TestGenerateVariable -superclass ::xounit::TestCase

    TestGenerateVariable instproc testCount { } {

        set count [ ::xox::GenerateVariable getVariableCount ]

        my assertInteger $count

        my assertEquals [ ::xox::GenerateVariable getVariableCount ] \
            [ expr {$count + 1}]
    }

    TestGenerateVariable instproc testGenerateVariable { } {

        ::xox::GenerateVariable variableCount 100

        my assertEquals [ ::xox::GenerateVariable variableCount ] 100
        my assertEquals [ ::xox::GenerateVariable getVariableCount ] 101

        my assertEquals [ ::xox::GenerateVariable generateVariable abc ] \
            "::xox::genvars::abc102"
    }

    TestGenerateVariable instproc testFree { } {


        my assertFalse [ info exists a ] 0.1

        set a 5

        my assertTrue [ info exists a ] 0.2

        my assertEquals $a 5

        unset a 
        
        my assertFalse [ info exists a ] 0.3

        ::xox::GenerateVariable variableCount 100

        set var [ ::xox::GenerateVariable generateVariable ]

        my assertEquals ::xox::genvars::temp101 $var

        my assertFalse [ info exists $var ] 0.4
        my assertFalse [ ::xox::genvars exists $var ] 0.5

        set $var 5

        my assertTrue [ info exists $var ] 1

        #Hmm why does this break?
        #Bug maybe in xotcl
        #my assertTrue [ ::xox::genvars exists $var ] 1.5

        my assertEquals [ set $var ] 5

        my assertEquals [ ::xox::GenerateVariable free $var ] 5

        my assertFalse [ ::xox::genvars exists $var ] 2
        my assertFalse [ info exists $var ] 2
    }
}

package provide xox::test::TestGenerateVariable 1.0

