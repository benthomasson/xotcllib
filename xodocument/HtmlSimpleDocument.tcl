
namespace eval ::xodocument { 

Class create HtmlSimpleDocument -superclass { ::xodocument::HtmlDocument }
  
HtmlSimpleDocument @doc HtmlSimpleDocument {
Please describe HtmlSimpleDocument here.
}
       
HtmlSimpleDocument parameter {

} 
        

HtmlSimpleDocument @doc makeClassDetail { 
makeClassDetail does ...
            dir - 
            class -
}

HtmlSimpleDocument instproc makeClassDetail { dir class } {
        set file [ open [ file join $dir [ my cleanUpLink $class].html ] w ]

        my putsHeader [ namespace tail $class ] $file
        [ my navbar ] selectClass [ my cleanUpLink [ namespace qualifiers $class ] ]-summary.html
        [ my navbar ] putsNavBar $file

        puts $file "

        <HR>
        <!-- ======== START OF CLASS DATA ======== -->
        <H2>
        <FONT SIZE=\"-1\">
        [ namespace qualifiers $class ]</FONT>

        <BR>
        Class [ namespace tail $class ]</H2>

        "

        my putsClassHeritage $file $class

        my putsSubclasses $file $class

        my putsAssociatedTest $file $class

        puts -nonewline $file "
        <DL>
        <DT> Class <b> [ namespace tail $class ] </b> <DT> superclass " 
        set superclasses [ $class info superclass ]

        foreach superclass $superclasses {

        puts -nonewline $file "[my getObjectLinkIfAvailable $superclass $superclass ],"

        }
        puts $file "</DL>"

        puts $file "<pre>"
        puts $file [ my getComment $class [ namespace tail $class ]  ]
        puts $file "</pre>"

        my putsAllParameterSummary $file $class

        my putsMethodSummary $file $class

        my putsAllInheritedMethods $file $class

        my putsProcSummary $file $class

        my putsProcDetail $file $class

        my putsInstprocDetail $file $class

        flush $file
        close $file
}


HtmlSimpleDocument @doc putsAllInheritedMethods { 
putsAllInheritedMethods does ...
            file - 
            class -
}

HtmlSimpleDocument instproc putsAllInheritedMethods { file class } {
        set classes ""
    
        foreach class [ concat $class [ $class info heritage ] ] {

            set classes [ concat $classes $class [ $class info instmixin ] ]
        }

        foreach class [ lrange $classes 1 end ] {

            my putsInheritedMethods $file $class
        }
    
}


HtmlSimpleDocument @doc putsAllParameterSummary { 
putsAllParameterSummary does ...
            file - 
            class -
}

HtmlSimpleDocument instproc putsAllParameterSummary { file class } {
        puts $file "

<!-- =========== Parameter SUMMARY =========== -->

<A NAME=\"parameter_summary\"><!-- --></A>
<TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">

<TR BGCOLOR=\"#CCCCFF\" CLASS=\"TableHeadingColor\">
<TD COLSPAN=4><FONT SIZE=\"+2\">
<B>Variables</B></FONT></TD>
</TR>

<TR BGCOLOR=\"#CCCCFF\" CLASS=\"TableRowColor\">
<TD>Name</TD><TD>Default Value</TD><TD>Class</TD><TD>Comment</TD>
</TR>
    "

        set classes ""
    
        foreach class [ concat $class [ $class info heritage ] ] {

            set classes [ concat $classes $class [ $class info instmixin ] ]
        }

        foreach class $classes {
    
        foreach parameterDefault [ $class info parameter ] {

            set parameter [ lindex $parameterDefault 0 ]
            set defaultValue [ lindex $parameterDefault 1 ]

            if { "" == "$defaultValue" } {
                if { [ llength $parameterDefault ] == 2 } {
                    set defaultValue {""}
                }
            }

            if { ! [ info exists parameterValues($parameter) ] } {
                set parameterValues($parameter) $defaultValue
            }
            if { ! [ info exists parameterComments($parameter) ] } {
            set parameterComments($parameter) [ my getComment $class $parameter ]
            }
            set parameterClasses($parameter) $class 
        }

        }

        foreach parameter [ lsort [ array names parameterValues ] ] {

            puts $file "

<TR BGCOLOR=\"white\" CLASS=\"TableRowColor\">
<TD><CODE><B>${parameter}</B></CODE></TD>
<TD>&nbsp;$parameterValues($parameter)</TD>
<TD>&nbsp;[ my getObjectLinkIfAvailable $parameterClasses($parameter) $parameterClasses($parameter) ]</TD>
<TD><pre>&nbsp;$parameterComments($parameter)</pre></TD>
</TR>
"
        }

        puts $file "

        </TABLE>
        &nbsp;
        "
    
}


HtmlSimpleDocument @doc putsInheritedMethods { 
putsInheritedMethods does ...
            file - 
            class -
}

HtmlSimpleDocument instproc putsInheritedMethods { file class } {
        
        if { [ llength [ my getInstcommandsOnly $class ] ] == 0 } {

            return
        }

        puts -nonewline $file "

        &nbsp;<A NAME=\"methods_inherited_from_class_[ my cleanUpLink $class]\"></A>
        <TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">
        <TR BGCOLOR=\"#EEEEFF\" CLASS=\"TableSubHeadingColor\">
        <TD><B>Methods from [ my getObjectLinkIfAvailable $class $class ] </B></TD>
        </TR>
        <TR BGCOLOR=\"white\" CLASS=\"TableRowColor\">

        <TD><CODE>"

        foreach method [ lsort [ $class info instprocs ] ] {

            puts -nonewline $file " [ my getObjectLinkIfAvailable $class $method _self $method ], "

        }

        puts $file "
        </CODE></TD>

        </TR>
        </TABLE>
        &nbsp;
        "

    
}


HtmlSimpleDocument @doc putsMethodSummary { 
putsMethodSummary does ...
            file - 
            class -
}

HtmlSimpleDocument instproc putsMethodSummary { file class } {
        puts $file "

<!-- =========== Instproc SUMMARY =========== -->

<A NAME=\"instproc_summary\"><!-- --></A>
<TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">

<TR BGCOLOR=\"#CCCCFF\" CLASS=\"TableHeadingColor\">
<TD COLSPAN=2><FONT SIZE=\"+2\">
<B>Methods</B></FONT></TD>
</TR>

<TR BGCOLOR=\"#CCCCFF\" CLASS=\"TableRowColor\">
<TD>Name</TD><TD>Comment</TD>
</TR>
    "
        foreach instproc [ lsort [ $class info instprocs ] ] {

            puts $file "

<TR BGCOLOR=\"white\" CLASS=\"TableRowColor\">
<TD><CODE> [ my getInstprocSummary $class $instproc ]
</CODE> 
</TD><TD>&nbsp;
[ my getShortComment $class $instproc ]
</TD>
</TR>
"
        }

        puts $file "

        </TABLE>
        &nbsp;
        "
    
}
}


