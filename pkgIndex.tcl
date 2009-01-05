package ifneeded xotcllib 1.0 [list source [file join $dir xotcllib.tcl ]]
package ifneeded xotcllib::test 1.0 [list source [file join $dir xotcllib.tcl ]]

foreach dir [ glob -nocomplain -types d [ file join $dir * ] ] {
    if {[file exists [file join $dir pkgIndex.tcl]]} {
        source [file join $dir pkgIndex.tcl]
    } 
} 
           
#testing loginfo

