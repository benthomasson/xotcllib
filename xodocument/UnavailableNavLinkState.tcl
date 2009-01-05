
namespace eval ::xodocument { 

Class create UnavailableNavLinkState -superclass { ::xodocument::NavLinkState }
  
UnavailableNavLinkState @doc UnavailableNavLinkState {
Please describe UnavailableNavLinkState here.
}
       
UnavailableNavLinkState parameter {

} 
        

UnavailableNavLinkState @doc getLink { 
getLink does ...
            name - 
            link -
}

UnavailableNavLinkState instproc getLink { name link } {
            return "
<TD BGCOLOR=\"#EEEEFF\" CLASS=\"NavBarCell1\"><FONT CLASS=\"NavBarFont1\"><B>$name</B></FONT>&nbsp;</TD>"
    
}
}


