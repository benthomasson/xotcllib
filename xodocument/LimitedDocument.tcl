
namespace eval ::xodocument { 

Class create LimitedDocument -superclass { ::xodocument::HtmlDocument }
  
LimitedDocument @doc LimitedDocument {
Please describe LimitedDocument here.
}
       
LimitedDocument parameter {

} 
        

LimitedDocument @doc makeFrames { 
makeFrames does ...
            dir -
}

LimitedDocument instproc makeFrames { dir } {
        set file [ open [ file join $dir index.html ] w ]

        puts $file " <FRAMESET cols=\"20%,80%\">
<FRAME src=\"allclasses-frame.html\" name=\"packageFrame\">
<FRAME src=\"overview-summary.html\" name=\"classFrame\">
</FRAMESET>"

        flush $file
        close $file
    
}
}


