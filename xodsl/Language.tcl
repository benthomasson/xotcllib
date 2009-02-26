# Created at Fri Oct 17 03:28:37 PM EDT 2008 by bthomass

namespace eval ::xodsl {

    ::xodsl loadClass ::xodsl::LanguageClass

    ::xodsl::LanguageClass create Language -superclass ::xotcl::Object

    Language @doc Language {

        Language is the basis for all Xodsl domain specific languages.  It provides the basic functions that are needed to make a Xodsl language.
        Note: 'global' does not function correctly in Xodsl.  Please do not use 'global' in your languages or their scripts.  Use ::VarName instead.
    }

    Language parameter {

    }

    Language @tag init hidden

    Language instproc init { } {

        my lappend globalProcs method subst isclass configure check eval requireNamespace autoname isobject proc lappend instvar move exists volatile info __next istype array cleanup filterguard filtersearch filter contains append noinit self hasclass set parametercmd mixin defaultmethod trace ismixin ismetaclass procsearch destroy vwait uplevel extractConfigureArg copy init forward upvar unset mixinguard invar incr abstract class

    }

    Language @doc global {

        The "global" command is not supported.  It will cause an error if called.
    }

    Language @arg global args { Ignored }

    Language @tag global Language

    Language instproc global { args } {

        error "Global is not supported in xodsl."
    }

    Language instproc getCommands { } {

        return [ my info methods ]
    }

    Language instproc getHelp { args } {

        return ""
    }
}


