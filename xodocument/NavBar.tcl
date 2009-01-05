
namespace eval ::xodocument { 

Class create NavBar -superclass { ::xotcl::Object }
  
NavBar @doc NavBar {
Please describe NavBar here.
}
    
NavBar @doc overviewLink { }

NavBar @doc namespaceLink { }

NavBar @doc classLink { }

NavBar @doc SelectedNavLinkState { }

NavBar @doc UnavailableNavLinkState { }

NavBar @doc AvailableNavLinkState { }
   
NavBar parameter {
   {overviewLink}
   {namespaceLink}
   {classLink}
   {SelectedNavLinkState}
   {UnavailableNavLinkState}
   {AvailableNavLinkState}

} 
        

NavBar @doc init { 
init does ...
}

NavBar instproc init {  } {
        ::xotcl::my SelectedNavLinkState [ SelectedNavLinkState new ]
        ::xotcl::my AvailableNavLinkState [ AvailableNavLinkState new ]
        ::xotcl::my UnavailableNavLinkState [ UnavailableNavLinkState new ]

        ::xotcl::my overviewLink [ NavLink new Overview overview-summary.html [ ::xotcl::my SelectedNavLinkState ] ]
        ::xotcl::my namespaceLink [ NavLink new Namespace namespace-summary.html [ ::xotcl::my UnavailableNavLinkState ] ]
        ::xotcl::my classLink [ NavLink new Class class-summary.html [ ::xotcl::my UnavailableNavLinkState ] ]

    
}


NavBar @doc putsNavBar { 
putsNavBar does ...
            file -
}

NavBar instproc putsNavBar { file } {
puts $file "

<!-- ========== START OF NAVBAR ========== -->
<A NAME=\"navbar_top\"><!-- --></A>

<TABLE BORDER=\"0\" WIDTH=\"100%\" CELLPADDING=\"1\" CELLSPACING=\"0\">
<TR>
<TD COLSPAN=3 BGCOLOR=\"#EEEEFF\" CLASS=\"NavBarCell1\">
<A NAME=\"navbar_top_firstrow\"><!-- --></A>
<TABLE BORDER=\"0\" CELLPADDING=\"0\" CELLSPACING=\"3\">
<TR ALIGN=\"center\" VALIGN=\"top\">
[ [ ::xotcl::my overviewLink ] getLink ]
[ [ ::xotcl::my namespaceLink ] getLink ]
[ [ ::xotcl::my classLink ] getLink ]

</TR>

</TABLE>
</TD>
<TD ALIGN=\"right\" VALIGN=\"top\" ROWSPAN=3><EM>
</EM>
</TD>
</TR>

<TR>
<td>
</td>
</TR>
<TR>
<TD VALIGN=\"top\" CLASS=\"NavBarCell3\"><FONT SIZE=\"-2\">
SUMMARY:&nbsp;CHILDREN&nbsp;|&nbsp;<A HREF=\"#parameter_summary\">PARAMETER</A>&nbsp;|&nbsp;<A HREF=\"#instproc_summary\">INSTPROC</A>&nbsp;|&nbsp;<A HREF=\"#instfilter_summary\">INSTFILTER</A>&nbsp;|&nbsp;<A HREF=\"#instforward_summary\">INSTFORWARD</A></FONT></TD>

<TD VALIGN=\"top\" CLASS=\"NavBarCell3\"><FONT SIZE=\"-2\">
DETAIL:&nbsp;|&nbsp;<A HREF=\"#instproc_detail\">INSTPROC</A></FONT></TD>
<TD VALIGN=\"top\" CLASS=\"NavBarCell3\"><FONT SIZE=\"-2\">
</TR>
</TABLE>
<!-- =========== END OF NAVBAR =========== -->
"
}


NavBar @doc selectClass { 
selectClass does ...
            namespace -
}

NavBar instproc selectClass { namespace } {
        [ ::xotcl::my overviewLink ] state [ ::xotcl::my AvailableNavLinkState ]
        [ ::xotcl::my namespaceLink ] state [ ::xotcl::my AvailableNavLinkState ]
        [ ::xotcl::my classLink ] state [ ::xotcl::my SelectedNavLinkState ]

        [ ::xotcl::my namespaceLink ] link $namespace
    
}


NavBar @doc selectNamespace { 
selectNamespace does ...
}

NavBar instproc selectNamespace {  } {
        [ ::xotcl::my overviewLink ] state [ ::xotcl::my AvailableNavLinkState ]
        [ ::xotcl::my namespaceLink ] state [ ::xotcl::my SelectedNavLinkState ]
        [ ::xotcl::my classLink ] state [ ::xotcl::my UnavailableNavLinkState ]
    
}


NavBar @doc selectOverview { 
selectOverview does ...
}

NavBar instproc selectOverview {  } {
        [ ::xotcl::my overviewLink ] state [ ::xotcl::my SelectedNavLinkState ]
        [ ::xotcl::my namespaceLink ] state [ ::xotcl::my UnavailableNavLinkState ]
        [ ::xotcl::my classLink ] state [ ::xotcl::my UnavailableNavLinkState ]
    
}
}


