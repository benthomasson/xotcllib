
namespace eval ::xox { 

Class create CVS 

CVS id {$Id: CVS.tcl,v 1.1.1.1 2007/07/31 22:54:07 bthomass Exp $}
  
CVS @doc CVS {
CVS is a mixin to ::xox::Package that adds CVS control to Package.
}
       
CVS parameter {

}

CVS instproc add { { files "" } } {

    if { "" == "$files" } {

        set files [ my getFiles ]
    }
    
    set pwd [ pwd ]
    cd [ my packagePath ]

    set result ""
    catch { exec cvs add $files >&@ stdout } result 
    puts $result

    cd $pwd
}

CVS instproc update { { files "" } } {

    set pwd [ pwd ]
    cd [ my packagePath ]

    if {  "" == "$files" } {

        set result ""
        catch { exec cvs update >&@ stdout } result 
        puts $result

    } else {

        set result ""
        catch { exec cvs update $files >&@ stdout } result 
        puts $result
    }

    cd $pwd
}

CVS instproc commit { { -files "" } } { message } {

    set pwd [ pwd ]
    cd [ my packagePath ]

    if { "" == "$files" } {
        set result ""
        catch { exec cvs commit -m "$message" >&@ stdout } result 
        puts $result
    } else {
        set result ""
        catch { exec cvs commit -m "$message" $files >&@ stdout } result 
        puts $result
    }

    cd $pwd
}

CVS instproc status { } {

    set pwd [ pwd ]
    cd [ my packagePath ]
    set result ""
    catch { exec cvs status | grep Status | egrep -v Up-to-date >&@ stdout }
    puts $result
    cd $pwd
}

}


