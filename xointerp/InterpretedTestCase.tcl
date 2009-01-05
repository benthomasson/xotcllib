# Created at Fri Jan 18 10:56:24 EST 2008 by bthomass

namespace eval ::xointerp {

    Class InterpretedTestCase -superclass ::xounit::TestCase

    InterpretedTestCase # InterpretedTestCase {

        Please describe the class InterpretedTestCase here.
    }

    InterpretedTestCase parameter {
        script
    }

    InterpretedTestCase instproc test { } {

        my instvar script

        set environment [ ::xointerp::InterpretedTestCaseEnvironment new ]
        foreach var [ my info vars ] {
            if [ my array exists $var ] {
                $environment array set $var [ my array get $var ]
            } else {
                $environment set $var [ my set $var ]
            }
        }
        set interpreter [ ::xointerp::ObjectInterpreter new -environment $environment -library $environment ]

        $interpreter tclEval $script
    }
}


