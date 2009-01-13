# Created at Sun Jul 13 20:00:48 EDT 2008 by bthomass

namespace eval ::xode {

    Class XodeShell -superclass ::xoshell::Shell

    XodeShell instmixin add ::xox::NotGarbageCollectable

    XodeShell @doc XodeShell {

        Please describe the class XodeShell here.
    }

    XodeShell parameter {

    }

    XodeShell @doc init { 

        Starts the XODE shell in interactive mode or executes one command from the shell and exits.
    }

    XodeShell @command init xode
    XodeShell @args init { args }
    XodeShell @arg init args { A command for the XODE shell to execute and exit. }

    XodeShell @example init {

      > xode

      This example starts the XODE shell interactively.

      or

      > xode runTests xox

      This example runs the tests for the xox package and exits.
    }

    XodeShell instproc init { } {

        my instvar environment language

        set language [ ::xode::XodeLanguage newLanguage ]
        set environment [ $language set environment ]

        return [ next ]
    }


    XodeShell instproc prompt {  } {
        my instvar output cyan underline clear

        puts -nonewline $output "${cyan}${underline}xode:[ file tail [pwd] ]>$clear"
        flush $output
    }

    XodeShell instproc processCommand { command } {

        my instvar environment
        set return [ next $command ]
        $environment set return $return
    }

}


