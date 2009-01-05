
namespace eval ::xodocument { 

Class create TclHtmlFormatter -superclass { ::xotcl::Object }
  
TclHtmlFormatter @doc TclHtmlFormatter {
Please describe TclHtmlFormatter here.
}
    
TclHtmlFormatter @doc tclcommands { }

TclHtmlFormatter @doc tcldoclocation { }

TclHtmlFormatter @doc xotclcommands { }

TclHtmlFormatter @doc xotcldoclocation { }
   
TclHtmlFormatter parameter {
   {tclcommands}
   {tcldoclocation}
   {xotclcommands}
   {xotcldoclocation}

} 
      

TclHtmlFormatter @doc getInstance { 
getInstance does ...
}

TclHtmlFormatter proc getInstance {  } {
        if { ![ my exists singleton ] } {

            my set singleton [ TclHtmlFormatter new ]
        }

        return [ my set singleton ]
    
}
  

TclHtmlFormatter @doc formatTcl { 
formatTcl does ...
            data -
}

TclHtmlFormatter instproc formatTcl { data } {
        regsub -all {\&} "$data" {\&amp;} data
        regsub -all < "$data" {\&lt;} data
        regsub -all > "$data" {\&gt;} data
        regsub -all {\\"} "$data" {<font color=orange>\\\&quot;</font>} data
        regsub -all {\\n} "$data" {<font color=orange>\\n</font>} data
        regsub -all {\$\m.*?\M} "$data" {<font color=maroon>&</font>} data 
        regsub -all -line {#.*} "$data" {<font color=green>&</font>} data 
        regsub -all "\"(.*?)\"" "$data"  {<font color=red>\&quot;\1\&quot;</font>} data

        foreach command [ ::xotcl::my tclcommands ] {

            regsub -all "\\m${command}\\M" "$data" "<a href=\"[::xotcl::my tcldoclocation]${command}.htm\">$command</a>" data

        }

        foreach command [ ::xotcl::my xotclcommands ] {

            regsub -all "\\m${command}\\M" "$data" "<a href=\"[::xotcl::my xotcldoclocation]\">$command</a>" data

        }

        foreach command { proc instproc } {

            regsub -all " \\m${command}\\M \\m(\\w+)\\M " "$data" " <a href=\"[::xotcl::my xotcldoclocation]\">$command</a> \\1<a name=\"\\1\" /> " data

        }

        return $data
    
}


TclHtmlFormatter @doc init { 
init does ...
}

TclHtmlFormatter instproc init {  } {
        ::xotcl::my tclcommands {
            encoding    if          pid         switch
            eof         incr        
            after       info    
            eval        interp          
            array       exec        join        puts    
            exit        lappend     pwd 
            expr        lindex  
            fblocked    linsert     read    
            fconfigure  list        regexp  
            fcopy       llength     registry    tell
            file        load        regsub      time
            fileevent   lrange      rename      trace
            bgerror     filename    lreplace    resource    unknown
            binary      flush       lsearch     return      unset
            break       for         lset        scan        update
            catch       foreach     lsort       seek        uplevel
            cd          format      memory      set         upvar
            clock       gets        msgcat      socket      variable
            close       glob        namespace   source      vwait
            concat      global      open        split       while
            continue    history     package     string
            dde         subst       append      error}

       ::xotcl::my tcldoclocation {http://www.tcl.tk/man/tcl8.5/TclCmd/}

       ::xotcl::my xotclcommands { my self next instmixin parameter }

       ::xotcl::my xotcldoclocation {http://media.wu-wien.ac.at/doc/langRef-xotcl.html}
    
}
}


