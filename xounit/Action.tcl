

namespace eval xounit {

   ::xotcl::Class create Action 

   Action # Class description {

       Action is a mixin that is used to execute a method on
       an object and return a test result.  This is useful in 
       building applications with an IDE or test runner 
       initiating the execution of the actions.
       
       Returning a result allows the result to be stored in a repository
       and retrieved at a later time.
   }

   Action instproc executeActionReturnResult { command } {

       set actionResult [ my newResult ]
       my runTest $actionResult $command 

       return $actionResult
   }
}


