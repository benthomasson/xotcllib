#Created by ben using ::xox::Template
 
package require xox
::xox::Package create ::xoshell
::xoshell id {$Id: xoshell.tcl,v 1.8 2008/11/18 00:25:26 bthomass Exp $}
::xoshell @doc xoshell {
XOShell is a shell platform for interacting with XOTcl objects.   
It allows users to edit objects, classes, and packages, to save them to files,
to load packges,  to reload packages, to generate code and tests,  to run tests,
and is user extensible and can be configured for new abilities on the fly.

A significant portion of XOShell was written using XOShell.
}
::xoshell requires {
    xounit
    xoexception
    xodsl
}
::xoshell loadFirst {
}
::xoshell executables {
    xoshell
    makeScript
}
namespace eval ::xoshell {
}

::xoshell loadAll
::xoshell versions {
}


