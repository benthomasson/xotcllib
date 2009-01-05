# Created at Fri Jan 18 10:56:55 EST 2008 by bthomass

namespace eval ::xointerp {

    Class InterpretedTestCaseEnvironment -superclass ::xounit::TestCase

    InterpretedTestCaseEnvironment # InterpretedTestCaseEnvironment {

        Please describe the class InterpretedTestCaseEnvironment here.
    }

    InterpretedTestCaseEnvironment parameter {

    }

    InterpretedTestCaseEnvironment instmixin add ::xointerp::Interpretable

    InterpretedTestCaseEnvironment instproc init { } {

        my set interpretableProcs {if while for foreach assertError assertInfoExists assertNoError assertFailure assertNoFailure } 
    }

    InterpretedTestCaseEnvironment instproc assertError { interpreter script { message "" } } {

        my assert [ catch { 

            $interpreter tclEval $script
        } ] "$message\nExpected to find an error in $script"
    }

    InterpretedTestCaseEnvironment instproc assertNoError { interpreter script { message "" } } {

        my assertFalse [ catch { 

            $interpreter tclEval $script
        } ] "$message\nExpected not to find an error in $script"
    }

    InterpretedTestCaseEnvironment instproc assertInfoExists { interpreter varName { message "" } } {

        $interpreter tclEval "

            assert \[ exists $varName \] \"$message\n Expected $varName to exist\"
        "
    }


    InterpretedTestCaseEnvironment instproc assertFailure { interpreter script { message "" } } {

        my assert [ catch { $interpreter tclEval $script } result ] \
            "$message\nExpected to find a failure in $script"

        my assert [ Object isobject $result ] \
            "$message\nExpected failure.  Error was found instead: $result"

        my assert [ $result hasclass ::xounit::AssertionError ] \
            "$message\nExpected to find a failure. Found object instead:\n$result is a [ $result info class ]"
    }

    InterpretedTestCaseEnvironment instproc assertNoFailure { interpreter script { message "" } } {

        set result ""

        my assertFalse [ catch { $interpreter tclEval $script } result ] \
            "$message\nExpected not to find a failure in $script\n[ ::xoexception::Throwable extractMessage $result ]"
    }
}


