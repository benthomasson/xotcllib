
namespace eval ::xodocument { 

Class create TestAssertDocument -superclass { ::xodocument::LimitedDocument }
  
TestAssertDocument @doc TestAssertDocument {
Please describe TestAssertDocument here.
}
       
TestAssertDocument parameter {

} 
        

TestAssertDocument @doc makeClassDetail { 
makeClassDetail does ...
            dir - 
            class -
}

TestAssertDocument instproc makeClassDetail { dir class } {
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

        my putsInstprocDetail $file $class

        flush $file
        close $file
    
}


TestAssertDocument @doc putsAllParameterSummary { 
putsAllParameterSummary does ...
            file - 
            class -
}

TestAssertDocument instproc putsAllParameterSummary { file class } {
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

            if { ! [ my isClassAvailable $class ] } { continue }
    
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


TestAssertDocument @doc putsInstprocDetail { 
putsInstprocDetail does ...
            file - 
            class -
}

TestAssertDocument instproc putsInstprocDetail { file class } {
        if { "" == "[ $class info instprocs ]" } { return }

        puts $file "
<!-- ============ INSTPROC DETAIL ========== -->

<A NAME=\"instproc_detail\"><!-- --></A>
<TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">
<TR BGCOLOR=\"#CCCCFF\" CLASS=\"TableHeadingColor\">
<TD COLSPAN=1><FONT SIZE=\"+2\">

<B>Assert and Test Detail</B></FONT></TD>
</TR>
</TABLE>
        "

        foreach instproc [ lsort [ $class info instprocs ] ] { 

            if { ( [ string first test $instproc ] != -1 ) ||  ( [ string first assert $instproc ] != -1 ) ||  ( [ string first fail $instproc ] != -1 ) } { 

            puts $file " <A NAME=\"[ my cleanUpLink $instproc]\"><!-- --></A><H3>
${instproc}</H3>
<dl>
<dt>
<b> Description: </b> </dt><dd><PRE><font color=\"green\"> [ my getComment $class $instproc ]</font></PRE></dd>"

        if { "" != [ $class info instargs $instproc ] } {

        puts $file "<dt> <b> Arguments: </b> </dt>"
        puts $file "<dd><ul>"
        foreach instarg [ $class info instargs $instproc ] {

            if [ $class info instdefault $instproc $instarg defaultValue ] {

                if { "" == "$defaultValue" } {

                    set defaultValue {""}
                }

                puts $file "<li> <code>$instarg</code> - optional, default value: <code>$defaultValue</code> </li>"

            } else {

                puts $file "<li><code>$instarg</code> </li>"
            }
        }
        puts $file "</ul></dd>"

        }

        set overridenClass ""

        foreach superclass [ $class info superclass ] {

            set overridenClass [ ::xox::ObjectGraph findFirstImplementation $superclass $instproc ]

            if { "" != "$overridenClass" } { break }
        }

        if { "" != "$overridenClass" } {
            puts $file "<dt> <b> Overrides: </b> </dt>"
            puts $file "<dd>[my getObjectLinkIfAvailable $overridenClass $instproc _self $instproc ] in [my getObjectLinkIfAvailable $overridenClass $overridenClass ]</dd>"
        }

            puts $file "<dt> <b> Code: </b> </dt> <dd><PRE> <b> ${class} instproc [ my getInstprocSummary $class $instproc ] </b> \{
   [ my cleanUpDataForHtml [ $class info instbody $instproc ] ]
\}
</PRE></dd>
<HR></dl>
            "

        }

        }

    
}


TestAssertDocument @doc putsMethodSummary { 
putsMethodSummary does ...
            file - 
            class -
}

TestAssertDocument instproc putsMethodSummary { file class } {
        puts $file "

<!-- =========== Instproc SUMMARY =========== -->

<A NAME=\"instproc_summary\"><!-- --></A>
<TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">

<TR BGCOLOR=\"#CCCCFF\" CLASS=\"TableHeadingColor\">
<TD COLSPAN=2><FONT SIZE=\"+2\">
<B>Asserts and Tests</B></FONT></TD>
</TR>

<TR BGCOLOR=\"#CCCCFF\" CLASS=\"TableRowColor\">
<TD>Name</TD><TD>Comment</TD>
</TR>
    "

        set classes ""
    
        foreach class [ concat $class [ $class info heritage ] ] {

            set classes [ concat $classes $class [ $class info instmixin ] ]
        }

        foreach class $classes {

            if { ! [ my isClassAvailable $class ] } { continue }
        
        foreach instproc [ lsort [ $class info instprocs ] ] {

            if { ( [ string first test $instproc ] != -1 ) ||  ( [ string first assert $instproc ] != -1 ) ||  ( [ string first fail $instproc ] != -1 ) } { 

                     if { ! [ info exists methodClass($instproc) ] } {
                         set methodClass($instproc) $class
                     }
                 }
        }

        }
        
        foreach instproc [ lsort -dictionary [ array names methodClass ] ] {

            set class $methodClass($instproc)

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


