
namespace eval ::xoexception { 

Class create Throwable -superclass { ::xotcl::Object }

Throwable id {$Id: Throwable.tcl,v 1.2 2008/04/08 13:49:30 bthomass Exp $}
  
Throwable @doc Throwable {
Throwable is the base class for all objects that can be
        thrown in xoexception. Throwables are objects that are thrown
        with the Tcl "error" command.  Instead of throwing string
        errors, exception objects can be thrown that contain
        more information that an unformatted string. 

        To throw an exception use:

        error [ Throwable new "Some error has occured" ]

        This can be used with a catch statement:

        if [ catch {

            error [ Throwable new "error" ]

        } result ] {

            puts "Caught exception. Message is [ $result message ]"
        }

        Throwable also provides some facilities to work with exceptions.

        isThrowable is used to determine if a catch-result is an 
        exception object or a unformatted string.

        Throwable isThrowable "some string"
        
        returns 0

        Throwable isThrowable [ Throwable new "error" ]

        returns 1

        extractMessage is used to get the message from an Throwable or
        from an unformatted string.

        if [ catch {

        #Some error happens here. It might throw an Throwable or an string.


        } result ] {
            #It doesnt matter if the result is a string or Throwable object.
            puts "[ Throwable extractMessage $result ]"
        }

        try is an extension of catch that can catch certain types of 
        Throwables.  

        try {
            #Code that could possibly thrown an error.
            #The exceptions can be called in this block or
            #in procs within this block.
        } catch {Error e1} {
            #Handle the error here if the error thrown is of
            #type Error or a subclass of Error.
            #More specific exceptions must come first in 
            #the blocks as these blocks are queried in top-to-bottom
            #order. Error is a subclass of Throwable so any Error
            #instance is also an Throwable instance and would always
            #be handled by the next block.
        } catch {Throwable e2} {      
            #Handle the error here if the error thrown is of
            #type Throwable or a subclass of Throwable.
        } catch {error e3} {   
            #try/catch can also catch unformatted string errors.
            #Use the type "error" to catch string errors.
        } finally {                                 
            #Finally blocks are optional.  They are always called
            #after all of the catch blocks are called, and even if 
            #they are not called.
        }
}
    
Throwable @doc message { The message that is carried with the Throwable.}

Throwable @doc trace { The stack trace that was recorded when the Throwable was created}
   
Throwable parameter {
   {message ""}
   {trace ""}
} 
      

Throwable @doc extractMessage { 
Extracts a string message from an Throwable object
        or from an unformatted string.  This is useful
        to get the error message without caring if the
        the message was an Throwable or an unformatted string.
}

Throwable proc extractMessage { message } {
        if [ ::xoexception::Throwable::isThrowable $message ] {

            set message [ $message message ]
        }

        return $message
}


Throwable @doc isThrowable { 
Returns 1 if the message is an exception object, 0 otherwise.
        This is useful in determining if a message is an unformatted
        string or an object reference.  Optionally className can
        be specified that determines if the exception is an instance of
        a subclass of that class.
}

Throwable proc isThrowable { message { className "::xoexception::Throwable" } } {
        set return 0

        if { ![ ::xotcl::Object isobject $message ] } {

           return 0
        }

        #catch {
            if { [$message istype $className ] } {

                set return 1
            }
        #}

        return $return
    
}
  

Throwable @doc init { 
Constructor that creates a new Throwable object with a message.
        The default message is blank.
}

Throwable instproc init { { message "" } } {
        ::xotcl::my message $message
        ::xotcl::my trace [ ::xotcl::my stackTrace ]
    
}
}


