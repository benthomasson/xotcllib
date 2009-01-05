
namespace eval ::xoexception { 

Class create Error -superclass { ::xoexception::Throwable }

Error id {$Id: Error.tcl,v 1.1.1.1 2007/07/31 22:54:55 bthomass Exp $}
  
Error @doc Error {
Error is the base class for all errors in 
        xoexception. An error can be thrown using "error":

        error [ ::xoexception::Error new "Some message" ]

        Error is not a subclass of Exception. This is to
        allow a different error handling mechanism for Errors.

        An Error represents a major problem in the code, that
        cannot be handled by the application. The error handling
        code should alert the user in some fasion that the error
        has occured and may ask the user for a course of action to 
        follow.
}
       
Error parameter {

}
}


