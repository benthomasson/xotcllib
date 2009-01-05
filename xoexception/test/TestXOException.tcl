
namespace eval ::xoexception::test {

    namespace import -force ::xotcl::*
    namespace import -force ::xoexception::*

::xotcl::Class TestException -superclass ::xounit::TestCase 

TestException instproc testThrowExceptionWithTclError {} {

    catch {

        error [ ::xoexception::Error new ]

        puts "This should not be executed! \
            TestException testThrowExceptionWithTclError Failed!"

        exit 
    }

}

TestException instproc testCatchExceptionWithTclCatch {} {


    catch {

        error [ ::xoexception::Error new ]

        puts "This should not be executed! \
            TestException testCatchExceptionWithTclCatch Failed!"

        exit 
    } result

    ::xotcl::my assertTrue [ info exists result ] "Result should be the Error"
}

TestException instproc testGetTheMessageFromTheException {} {


    catch {

        error [ ::xoexception::Error new "An Error message" ]

        puts "This should not be executed! \
            TestException testGetTheMessageFromTheException Failed!"

        exit 
    } result

    ::xotcl::my assertTrue [ info exists result ] \
        "Result should be the Error"
        
    ::xotcl::my assertEquals [ $result message ] "An Error message"
}

::xotcl::Class TestExtractMessage -superclass ::xounit::TestCase 

TestExtractMessage instproc testExtractMessageFromTclErrorString {} {

    catch {

        error "Simple error"

    } result
    
    set message [ ::xoexception::Throwable extractMessage $result ]

    ::xotcl::my assertEquals $message "Simple error"
} 

TestExtractMessage instproc testExtractMessageFromException {} {

    ::xoexception::try {

        error [ ::xoexception::Exception new "Exception message" ]

    } catch { ::xoexception::Exception result  } {

    }

    set message [ ::xoexception::Throwable extractMessage $result ]

    ::xotcl::my assertEquals $message "Exception message"
}

::xotcl::Class TestIsException -superclass ::xounit::TestCase 

TestIsException instproc testIsExceptionTclError {} {


    catch {

        error "Simple error"

    } result


    ::xotcl::my assertFalse [ ::xoexception::Throwable isThrowable  $result ]

}

TestIsException instproc testIsExceptionException {} {


    catch {

        error [ ::xoexception::Error new "Exception" ]

    } result


    ::xotcl::my assertTrue [ ::xoexception::Throwable isThrowable  $result ]
    ::xotcl::my assertEquals [ $result message ]  "Exception"

}

::xotcl::Class TestTry -superclass ::xounit::TestCase 

TestTry instproc testCatch {} {

    set value [ ::xoexception::try {

        error foobar

    } catch { error someError } { 

        my assertEquals $someError foobar
    }]

    my assertEquals $someError foobar
    unset someError
 
    ::xoexception::try {

        set value 1

    } catch { error someError } { 

        set value 2
    }

    my assertFalse [ info exists someError ]
    my assertEquals $value 1
}

TestTry instproc testFinally {} {

    ::xoexception::try {

        set value 1

    } finally { 

        set a 5
    }

    my assertEquals $value 1 
    my assertEquals $a 5 

    unset value
    unset a

    catch {

        ::xoexception::try {

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

TestTry instproc testCatchException {} {

    catch {

        ::xoexception::try {

            error foobar

        } catch { ::xoexception::Exception anError } { 

            my fail "should not run"
        }

        puts "testCatchException failed did not throw uncaught error"

        exit 1
    }


    set value [ ::xoexception::try {

        error [ ::xoexception::Exception new ]

    } catch { error anError } { 

        my assertTrue [ Object isobject $anError ]
    }]

    my assertTrue [ Object isobject $anError ]

    set value [ ::xoexception::try {

        error [ ::xoexception::Error new ]

    } catch { error anError } { 

        my assertTrue [ Object isobject $anError ]
    }]

    my assertTrue [ info exists anError ]
    my assertTrue [ Object isobject $anError ]


    unset anError

    catch {

    set value [ ::xoexception::try {

        error [ ::xoexception::Exception new ]

    } catch { ::xoexception::Error anError } { 

    }]

    }

    my assertFalse [ info exists anError ]

    set value [ ::xoexception::try {

        error [ ::xoexception::Error new ]

    } catch { ::xoexception::Throwable anError } { 

    }]

    my assertTrue [ info exists anError ]
    my assertTrue [ Object isobject $anError ]
}

TestTry instproc testCatchMultiException {} {

    set value [ ::xoexception::try {

        error [ ::xoexception::Error new ]

    } catch { ::xoexception::Error anError } { 

    } catch { ::xoexception::Exception anExeception } {
        
    } catch { error tclError } {
        
    }]

    my assertTrue [ info exists anError ]
    my assertFalse [ info exists anException ]
    my assertFalse [ info exists tclError ]

    unset anError

    set value [ ::xoexception::try {

        error [ ::xoexception::Exception new ]

    } catch { ::xoexception::Error anError } { 

    } catch { ::xoexception::Exception anException } {
        
    } catch { error tclError } {
        
    }]

    my assertFalse [ info exists anError ]
    my assertTrue [ info exists anException ]
    my assertFalse [ info exists tclError ]

    unset anException

    set value [ ::xoexception::try {

        error foobar

    } catch { ::xoexception::Error anError } { 

    } catch { ::xoexception::Exception anExeception } {
        
    } catch { error tclError } {
        
    }]

    my assertFalse [ info exists anError ]
    my assertFalse [ info exists anException ]
    my assertTrue [ info exists tclError ]
}

TestTry instproc testCatchAssert {} {

    ::xoexception::try {

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

TestTry instproc testNestedTry {} {

    ::xoexception::try {

        ::xoexception::try {
            
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

TestTry instproc testRethrowException {} {

    catch {

        ::xoexception::try {
            
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

TestTry instproc testNestedTry2 {} {

    ::xoexception::try {

        ::xoexception::try {
            
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

}

