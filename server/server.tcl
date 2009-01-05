#Created by bthomass using ::xox::Template
 
package require xox
::xox::Package create ::server
::server id {$Id: server.tcl,v 1.3 2008/07/22 02:38:23 bthomass Exp $}
::server @doc server {
Please describe server here.
}
::server requires {
    xounit
    xodocument
    xoserialize
    xointerp
    xohtml
}
::server loadFirst {
    ::server::SingletonClass
}
::server executables {
    
}
::server loadAll
namespace eval ::server {
}



