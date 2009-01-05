# Created at Wed May 16 15:32:03 -0400 2007 by ben

namespace eval ::xoexception::test {

    namespace import -force ::xotcl::*
    namespace import -force ::xoexception::*

    Class TestProcTry -superclass ::xounit::TestCase

    TestProcTry instproc test { } {

        try {

            error error

        } catch {error someError} {

           return $someError
        }
    }

    TestProcTry instproc testNamespace { } {

        set a 5
            puts [ self ]

        try {

            puts [ namespace current ]
            my assertEquals ::xoexception::test [ namespace current ]
            puts [ self ]
            my assertEquals $a 5


        } finally {

            puts [ namespace current ]
            my assertEquals ::xoexception::test [ namespace current ]
            puts [ self ]
            my assertEquals $a 5

        }

        my assertEquals $a 5
    }

    TestProcTry instproc testCatch {} {

        set value [ try {

            error foobar

        } catch { error someError } { 

            my assertEquals $someError foobar
        }]

        my assertEquals $someError foobar

        unset someError
     
        try {

            set value 1

        } catch { error someError } { 

            set value 2
        }

        my assertFalse [ info exists someError ]
        my assertEquals $value 1
    }

    TestProcTry instproc testFinally {} {

        try {

            set value 1

        } finally { 

            set a 5
        }

        my assertEquals $value 1 
        my assertEquals $a 5 

        unset value
        unset a

        catch {

            try {

                set value 1
                error foobar
                set value 2

            } finally { 

                set a 5
            }
        }

        my assertEquals $value 1 
        my assertEquals $a 5 
    }

    TestProcTry instproc testCatchException {} {

        catch {

            try {

                error foobar

            } catch { ::xoexception::Exception anError } { 

                my fail "should not run"
            }

            puts "testCatchException failed did not throw uncaught error"

            exit 1
        }


        set value [ try {

            error [ ::xoexception::Exception new ]

        } catch { error anError } { 

            my assertTrue [ Object isobject $anError ]
        }]

        my assertTrue [ Object isobject $anError ]

        set value [ try {

            error [ ::xoexception::Error new ]

        } catch { error anError } { 

            my assertTrue [ Object isobject $anError ]
        }]

        my assertTrue [ info exists anError ]
        my assertTrue [ Object isobject $anError ]


        unset anError

        catch {

        set value [ try {

            error [ ::xoexception::Exception new ]

        } catch { ::xoexception::Error anError } { 

        }]

        }

        my assertFalse [ info exists anError ]

        set value [ try {

            error [ ::xoexception::Error new ]

        } catch { ::xoexception::Throwable anError } { 

        }]

        my assertTrue [ info exists anError ]
        my assertTrue [ Object isobject $anError ]
    }

    TestProcTry instproc testCatchMultiException {} {

        set value [ try {

            error [ ::xoexception::Error new ]

        } catch { ::xoexception::Error anError } { 

        } catch { ::xoexception::Exception anExeception } {
            
        } catch { error tclError } {
            
        }]

        my assertTrue [ info exists anError ]
        my assertFalse [ info exists anException ]
        my assertFalse [ info exists tclError ]

        unset anError

        set value [ try {

            error [ ::xoexception::Exception new ]

        } catch { ::xoexception::Error anError } { 

        } catch { ::xoexception::Exception anException } {
            
        } catch { error tclError } {
            
        }]

        my assertFalse [ info exists anError ]
        my assertTrue [ info exists anException ]
        my assertFalse [ info exists tclError ]

        unset anException

        set value [ try {

            error foobar

        } catch { ::xoexception::Error anError } { 

        } catch { ::xoexception::Exception anExeception } {
            
        } catch { error tclError } {
            
        }]

        my assertFalse [ info exists anError ]
        my assertFalse [ info exists anException ]
        my assertTrue [ info exists tclError ]
    }

    TestProcTry instproc testCatchAssert {} {

        try {

            my fail "assert failure"

        } catch { ::xounit::AssertionError assert } {

            my assertTrue [ info exists assert ]
            my assertTrue [ Object isobject $assert ]
            my assertEquals [ $assert message ] "assert failure"
            set ran 1
        } 

        my assertTrue [ info exists assert ]
        my assertTrue [ Object isobject $assert ]
        my assertEquals [ $assert message ] "assert failure"
        my assertEquals $ran 1
    }

    TestProcTry instproc testNestedTry {} {

        try {

            try {
                
                error [ ::xoexception::Exception new ]

            } catch { ::xoexception::Exception e } {

                my assertEquals [ $e info class ] ::xoexception::Exception 
            }

            my assert [ info exists e ]

        } catch { ::xoexception::Exception e } {

            my assertEquals [ $e info class ] ::xoexception::Exception 
        }

        my assert [ info exists e ]
    }

    TestProcTry instproc testRethrowException {} {

        catch {

            try {
                
                error [ ::xoexception::Error new ]
                my fail "Should throw error"

            } catch { ::xoexception::Exception e } {

                my fail "Should not be caught"
            }

        } e

       my assert [ info exists e ] 1
       my assert [ Object isobject $e ] 2
       my assertEquals [ $e info class ] ::xoexception::Error 3
    }

    TestProcTry instproc testNestedTry2 {} {

        try {

            try {
                
                error [ ::xoexception::Error new ]

                my fail "Should have thrown error"

            } catch { ::xoexception::Exception e } {

               my fail "Should not catch exception"
            }

        } catch { ::xoexception::Error e } {

            my assertEquals [ $e info class ] ::xoexception::Error 
        }

        my assert [ info exists e ]
}

    TestProcTry instproc testReturn { } {

        try {
            return
        } 

        fail "Should have returned"
    }

    TestProcTry instproc testCatchReturn { } {

        set code [ catch {
            return
        } result ]

        my assertEquals $code 2
        my assertEquals $result ""
    }

    TestProcTry instproc testCatchReturnValue { } {

        set code [ catch {
            return 567
        } result ]

        my assertEquals $code 2
        my assertEquals $result 567
    }

    TestProcTry instproc testContinue { } {

        set done 0

        while { !$done } {

            set done 1

            try {
                continue
            }

            fail "Should have continued"
        }
    }


    TestProcTry instproc testBreak { } {

        set done 0

        while { !$done } {

            try {
                break
            }

            fail "Should have breaked"
        }
    }

    TestProcTry instproc return { code } {

        return -code $code
    }

    TestProcTry instproc testReturnCodes { } {

        my assertEquals [ catch { } ] 0 none
        my assertEquals [ catch { error } ] 1 error
        my assertEquals [ catch { return } ] 2 return
        my assertEquals [ catch { break } ] 3 break
        my assertEquals [ catch { continue } ] 4 continue
        my assertEquals [ catch { my return 1 } ] 1 returnCode1
        my assertEquals [ catch { my return 2 } ] 2 returnCode2
        my assertEquals [ catch { my return 3 } ] 3 returnCode3
        my assertEquals [ catch { my return 4 } ] 4 returnCode4
        my assertEquals [ catch { my return 5 } ] 5 returnCode5
    }

    TestProcTry instproc testOtherReturnCodes { } {

        set pass 0

        try {
            my return 1
        } catch { error e } {
            set pass 1
        }

        my assertEquals $pass 1 return1

        set pass 0

        try {
            my return 100
        } catch { 100 e } {
            set pass 1
        }

        my assertEquals $pass 1 return100

        set pass 0

        my assertEquals [ catch {
            try {
                my return 99
            } catch { 101 e } {
                set pass 1
            }  
        } result ] 1

        my assertEquals $pass 0 return99
        my assertEquals $result "Error code 99 not supported by ::xoexception::try"
    }
}

