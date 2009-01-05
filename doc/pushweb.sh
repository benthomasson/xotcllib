#!/usr/bin/tclsh
set to bthomass@xotcllib.gforge.cisco.com:/home/groups/xotcllib/htdocs/
foreach file [ glob -nocomplain *.html ] {
    puts "Pushing $file to $to"
    catch { exec scp $file $to >&@ stdout }
}
foreach dir [ glob -nocomplain * ] {

    if { ! [ file isdirectory $dir ] } { continue }
    if [ string match _* $dir ] { continue }
    file mkdir [ file join $to $dir ]
    foreach file [ glob -nocomplain [ file join $dir *.html ] ] {
        puts "Pushing $file to [ file join $to $dir ]"
        catch { exec scp $file [ file join $to $dir ] >&@ stdout }
    }
}
