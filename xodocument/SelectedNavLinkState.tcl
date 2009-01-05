
namespace eval ::xodocument { 

Class create SelectedNavLinkState -superclass { ::xodocument::NavLinkState }
  
SelectedNavLinkState @doc SelectedNavLinkState {
Please describe SelectedNavLinkState here.
}
       
SelectedNavLinkState parameter {

} 
        

SelectedNavLinkState @doc getLink { 
getLink does ...
            name - 
            link -
}

SelectedNavLinkState instproc getLink { name link } {
           return "
<TD BGCOLOR=\"#FFFFFF\" CLASS=\"NavBarCell1Rev\"> &nbsp;<FONT CLASS=\"NavBarFont1Rev\"><B>$name</B></FONT>&nbsp;</TD>"

    
}
}


