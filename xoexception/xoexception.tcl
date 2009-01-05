#Created by bthomass using ::xox::Template
 
package require xox
::xox::Package create ::xoexception
::xoexception id {$Id: xoexception.tcl,v 1.5 2008/07/31 20:42:47 bthomass Exp $}
::xoexception @doc xoexception {
Please describe xoexception here.
}
::xoexception requires {
    xox
}
::xoexception loadFirst {
    
}
::xoexception executables {
    
}
::xoexception exports {
    try
}
::xoexception @doc try { 
try is an extension of the catch proc it allows
    for multiplexing the error handling code with
    Throwable types. 

    try catches the error and then uses the class of
    the error to determine which block of error handling
    code should execute. If an error is an object try
    uses the first catch statement that has the class
    or a superclass of the object.  For instance
    if a catch block was

    try {

    } catch { ::xoexception::Exception e } {

    }

    only errors that refer to instances of Exceptions
    or subclasses of Exceptions would be handled by this block.

    try can also handle not object errors.  It does so with
    the "error" type.

    try { 
        error "some string error"
    } catch { error e } {
        puts "Error: $e"
    }

    try also works with errorInfo:

    try { 
        error "some string error"
    } catch { error e } {
        global errorInfo
        puts "Error: $e\n$errorInfo"
    }

    Example:

    try {

        error [ ::xoexception::Exception new "Ouch" ]
        
    } catch {Error e1} {
        #This block is not called because Exception is not
        #a subclass of Error.
        puts "Error [ $e1 message ]"
    } catch {Throwable e2} {      
        #This block is called because Exception is a subclass
        #of Throwable.
        puts "Throwable [ $e2 message ]"
    } catch {error e3} {   
        #try/catch can also catch unformatted string errors.
        #Use the type "error" to catch string errors.
        #This block is not called because the previous block
        #matched the Exception type.
    } finally {                                 

        #finally blocks are always called.
        #put essential clean up code here.
        puts "Done with try/catch/finally"
    }
}

proc ::xoexception::try { script args } {
                    set remainingArgs $args

    set retValue [ catch "uplevel {$script}" result ]

    set finallyScript ""
    set runACatchBlock 1

    if { 0 == $retValue } {

        set runACatchBlock 0
    }

    switch $retValue {

        3 { return -code break }
        4 { return -code continue }
        2 { return -code return $result }
        default { 
            while { [ llength $remainingArgs ] != 0 } {

                set firstArg [ lindex $remainingArgs 0 ]

                switch $firstArg {

                    catch { 

                        set errorTypeAndName [ lindex $remainingArgs 1 ]
                        set errorType [ lindex $errorTypeAndName 0 ]
                        set errorName [ lindex $errorTypeAndName 1 ]
                        set catchScript [ lindex $remainingArgs 2 ]
                        set remainingArgs [ lrange $remainingArgs 3 end ]

                        if { $runACatchBlock } {

                            if { "error" == "$errorType" } {

                                uplevel [ list set $errorName $result ]
                                uplevel $catchScript
                                set runACatchBlock 0

                            } elseif { "$retValue" == "$errorType" } {

                                uplevel [ list set $errorName $result ]
                                uplevel $catchScript
                                set runACatchBlock 0
                                
                            } elseif [ ::xoexception::Throwable::isThrowable $result $errorType ] {

                                uplevel [ list set $errorName $result ]
                                uplevel $catchScript
                                set runACatchBlock 0

                            } elseif { "onlyerror" == "$errorType" && ! [ ::xoexception::Throwable::isThrowable $result ] } {
                                uplevel [ list set $errorName $result ]
                                uplevel $catchScript
                                set runACatchBlock 0
                            }
                        }
                    }

                    finally { 

                        if { "" != "$finallyScript" } {

                            error "try may only have one finally block"
                        }

                        set finallyScript [ lindex $remainingArgs 1 ]
                        set remainingArgs [ lrange $remainingArgs 3 end ]
                    }

                    default { error "Expected catch or finally in try" }
                }
            }

            uplevel $finallyScript

            if { $runACatchBlock } {

                if [ ::xoexception::Throwable::isThrowable $result ] {

                    error $result

                } else {

                    switch $retValue {

                        1 { error $result $::errorInfo $::errorCode }
                        0 { return -code 0 $result }
                        default { error "Error code $retValue not supported by ::xoexception::try" }
                    }
                }
            }

            return $result
        }
    }
}
::xoexception loadAll
::xoexception versions {
    ::xoexception::Error 1.5
    ::xoexception::Exception 1.5
    ::xoexception::Throwable 1.5
    ::xoexception::test::TestException 1.0
    ::xoexception::test::TestExtractMessage 1.0
    ::xoexception::test::TestIsException 1.0
    ::xoexception::test::TestProcTry 1.0
    ::xoexception::test::TestThrowable 1.0
    ::xoexception::test::TestTry 1.0
}


