package ifneeded server 1.2 [list source [file join $dir server.tcl ]]
package ifneeded server::test 1.0 [list source [file join $dir test server.tcl ]]

foreach dir [ glob -nocomplain -types d [ file join $dir * ] ] {
    if {[file exists [file join $dir pkgIndex.tcl]]} {
        source [file join $dir pkgIndex.tcl]
    } 
} 
           
#testing loginfo

