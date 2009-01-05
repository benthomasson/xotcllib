
namespace eval ::xodocument { 

Class create AvailableNavLinkState -superclass { ::xodocument::NavLinkState }
  
AvailableNavLinkState @doc AvailableNavLinkState {
Please describe AvailableNavLinkState here.
}
       
AvailableNavLinkState parameter {

} 
        

AvailableNavLinkState @doc getLink { 
getLink does ...
            name - 
            link -
}

AvailableNavLinkState instproc getLink { name link } {
            return "
<TD BGCOLOR=\"#EEEEFF\" CLASS=\"NavBarCell1\">    <A HREF=\"$link\"><FONT CLASS=\"NavBarFont1\"><B>$name</B></FONT></A>&nbsp;</TD>"
    
}
}


