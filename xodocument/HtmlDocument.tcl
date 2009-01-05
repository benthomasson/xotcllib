
namespace eval ::xodocument { 

Class create HtmlDocument -superclass { ::xox::Template }
  
HtmlDocument @doc HtmlDocument {
Please describe HtmlDocument here.
}
    
HtmlDocument @doc project { }

HtmlDocument @doc stylesheet { }

HtmlDocument @doc namespaces { }

HtmlDocument @doc objectList { }

HtmlDocument @doc tclformatter { }

HtmlDocument @doc navbar { }
   
HtmlDocument parameter {
   {project}
   {stylesheet}
   {namespaces}
   {objectList}
   {tclformatter}
   {navbar}

} 
        

HtmlDocument @doc cleanUpComment { 
cleanUpComment does ...
            data -
}

HtmlDocument instproc cleanUpComment { data } {
        regsub -all {\&} "$data" {\&amp;} data
        regsub -all < "$data" {\&lt;} data
        regsub -all > "$data" {\&gt;} data

        set newData ""
        
        set lines [ split $data "\n" ]

        while { 1 } {

            if { [ llength $lines ] == 0 } { break }

            set firstLine [ lindex $lines 0 ]

            if [ my isSpaces $firstLine ] {

                set lines [ lrange $lines 1 end ]

            } else {
                
                break
            }
        }

        set firstLine [ lindex $lines 0 ]

        set spaces 0

        foreach char [ split $firstLine "" ] {

            if [ string is space $char ] {
                incr spaces
            } else {
                break
            }
        }
        
        incr spaces -1

        foreach line $lines {

            set whitespace [ string range $line 0 $spaces ]

            if [ my isSpaces $whitespace ] {

                append newData [ string range $line $spaces end ]
                append newData "\n"

            } else {

                append newData $line 
                append newData "\n"
            }
        }

        return [ string trim $newData ]
    
}


HtmlDocument @doc cleanUpDataForHtml { 
cleanUpDataForHtml does ...
            data -
}

HtmlDocument instproc cleanUpDataForHtml { data } {
        return [ [my tclformatter ] formatTcl $data ]
    
}


HtmlDocument @doc cleanUpLink { 
cleanUpLink does ...
            link -
}

HtmlDocument instproc cleanUpLink { link } {
        regsub -all {::} "$link" {_} link
        regsub -all {#} "$link" {_} link

        return $link
    
}

HtmlDocument instproc namespaceObjects { } {

    set objects [ ::xox::mapcar {

        string range $namespace 0 end-1
        
    } namespace [ my namespaces ] ]

    set retObjects ""

    foreach object $objects {

        if { "::" == "$object" } continue

        if { ! [ my isobject $object ] } {

            if { ! [ my isobject ${object}::info ] } {
                Object create $object -noinit -requireNamespace 
            }
        }

        lappend retObjects $object
    }

    return $retObjects
}

HtmlDocument @doc generateDoc { 
generateDoc does ...
            dir -
}

HtmlDocument instproc generateDoc { dir } {
        set dir [ my getAbsoluteDir $dir ]
        
        if { ![ file exists $dir ] } {

            file mkdir $dir
        }

        if { ![ file isdirectory $dir ] } {

            error [ ::xoexception::Exception new  "$dir is not a directory" ]
        }

        set stylesheet [ my stylesheet ]

        if { [ file exists $stylesheet ] } {

            file copy -force $stylesheet [ file join $dir $stylesheet ] 
        }

        set objectList [ my namespaceObjects ]

        foreach namespace [ my namespaces ] {

            set objectList [ concat $objectList [ lsort -unique [ ::xox::ObjectGraph findAllInstances ::xotcl::Object $namespace ] ] ]
            set objectList [ concat $objectList [ lsort -unique [ ::xox::ObjectGraph findAllInstances ::xotcl::Object [ string tolower $namespace ] ] ] ]

            puts "Finding objects in $namespace"
        }

        set objectList [ concat [ my objectList ] $objectList ]

        set objectList [ lsort -unique $objectList ]

        set objectList [ ::xox::removeIf {
            ::xox::ObjectGraph hasParentWithClass $object ::xotcl::Class
        } object $objectList ]
        
        my objectList $objectList

        my makeClassIndex $dir $objectList

        set namespaceList [ my namespaceObjects ]

        foreach class $objectList {

            set namespace [ namespace qualifiers $class ]

            if { [ lsearch $namespaceList $namespace ] == -1  } {

                lappend namespaceList $namespace
            }
        }

        set namespaceList [ lsort -unique $namespaceList ]

        my makeOverview $dir $namespaceList
        my makeNamespaceIndex $dir $namespaceList

        foreach namespace $namespaceList {

            if { "" == "$namespace" } {

                set namespace ::
            }

            my makeNamespaceSummary $dir $namespace $objectList
            my makeClassIndexPerNamespace $dir $namespace $objectList
            my makeUsersGuide $dir $namespace 
        }

        foreach object $objectList {

            if [ my isclass $object ] {

                my makeClassDetail $dir $object
                puts "Generated doc for $object"

            } else {

                my makeObjectDetail $dir $object
                puts "Generated doc for $object"

            }
        }

        my makeFrames $dir

        puts "Done"
}


HtmlDocument @doc getAbsoluteDir { 
getAbsoluteDir does ...
            dir -
}

HtmlDocument instproc getAbsoluteDir { dir } {
        if { "[file pathtype $dir]" == "relative" } {

            set dir [ file join [ pwd ]  $dir ]
        }

        return $dir
    
}


HtmlDocument @doc getObjectLinkIfAvailable { 
getObjectLinkIfAvailable does ...
            class - 
            text - 
            target - 
            anchor -
}

HtmlDocument instproc getObjectLinkIfAvailable { class text { target "_self" } { anchor "top" } } {
       if { ! [ my isClassAvailable $class ] } {

           return ${text}
       }

       return "<A HREF=\"[ my cleanUpLink $class].html#${anchor}\" TARGET=\"$target\">${text}</A>"
    
}


HtmlDocument @doc getComment { 
getComment does ...
            class - 
            args -
}

HtmlDocument instproc getComment { class args } {
        set comment [ ::xox::ObjectGraph findFirstComment $class $args ]
        return [ my cleanUpComment $comment ]
    
}


HtmlDocument @doc getInstcommandSummary { 
getInstcommandSummary does ...
            class - 
            instcommand -
}

HtmlDocument instproc getInstcommandSummary { class instcommand } {
        return " <B><A HREF=\"#[ my cleanUpLink $instcommand]\">${instcommand}</A></B>"

    
}


HtmlDocument @doc getInstcommandsOnly { 
getInstcommandsOnly does ...
            class -
}

HtmlDocument instproc getInstcommandsOnly { class } {
        set instprocs [ $class info instprocs ]
        set instprocs [ concat $instprocs [ $class info parameter ] ]

        set instcommandsOnly {}
    
        foreach instcommand [ lsort [ $class info instcommands ] ] {

            if { [ lsearch -exact $instprocs $instcommand ] != -1 } {
                continue
            }

            lappend instcommandsOnly $instcommand
        }
        return $instcommandsOnly
    
}


HtmlDocument @doc getInstprocSummary { 
getInstprocSummary does ...
            class - 
            instproc -
}

HtmlDocument instproc getInstprocSummary { class instproc } {
        set instnonposargs "\{[ $class info instnonposargs $instproc ]\}"

        if { "$instnonposargs" == "\{\}" } {

            set instnonposargs ""
        }

        set instargs ""

        foreach instarg [ $class info instargs $instproc ] {

            if [ $class info instdefault $instproc $instarg defaultValue ] {

                if { "" == "$defaultValue" } {

                    set defaultValue {""}
                }

                lappend instargs "$instarg $defaultValue"

            } else {

                lappend instargs $instarg
            }
        }

        set instargs "\{$instargs\}"


        return "<B>[ my getObjectLinkIfAvailable $class $instproc _self $instproc ]</B>$instnonposargs $instargs" 

    
}


HtmlDocument @doc getProcSummary { 
getProcSummary does ...
            class - 
            proc -
}

HtmlDocument instproc getProcSummary { class proc } {
        set args "\{ [ $class info args $proc ] \} "

        set nonposargs "\{[ $class info nonposargs $proc ]\}"

        if { "$nonposargs" == "\{\}" } {

            set nonposargs ""
        }

        return " <B><A HREF=\"#[ my cleanUpLink $proc]\">${proc}</A></B>$nonposargs $args" 

    
}


HtmlDocument @doc getShortComment { 
getShortComment does ...
            class - 
            args -
}

HtmlDocument instproc getShortComment { class args } {
        set comment [ ::xox::ObjectGraph findFirstComment $class $args ]
        return [ my cleanUpComment [ lindex [ split $comment "."  ] 0 ] ]
    
}


HtmlDocument @doc init { 
init does ...
}

HtmlDocument instproc init {  } {
        my project "Project Name"
        my stylesheet "stylesheet.css"
        my namespaces "::*"
        my objectList ""
        my tclformatter [ TclHtmlFormatter new ]
        my navbar [ NavBar new ]
}


HtmlDocument @doc isClassAvailable { 
isClassAvailable does ...
            class -
}

HtmlDocument instproc isClassAvailable { class } {
       return [ expr { [ lsearch [ my objectList ] $class ] != -1 } ]
    
}


HtmlDocument @doc isSpaces { 
isSpaces does ...
            string -
}

HtmlDocument instproc isSpaces { string } {
        return [ expr { "[ string trim $string ]" == "" } ] 
    
}


HtmlDocument instproc makeObjectDetail { dir object } {
        set file [ open [ file join $dir [ my cleanUpLink $object].html ] w ]

        my putsHeader [ namespace tail $object ] $file
        [ my navbar ] selectClass [ my cleanUpLink [ namespace qualifiers $object ] ]-summary.html
        [ my navbar ] putsNavBar $file

        puts $file "

        <HR>
        <!-- ======== START OF OBJECT DATA ======== -->
        <H2>
        <FONT SIZE=\"-1\">
        [ namespace qualifiers $object ]</FONT>

        <BR>
        [ $object info class ] [ namespace tail $object ]</H2>

        "

        my putsAssociatedTest $file $object

        puts -nonewline $file "
        <DL>
        <DT> [ $object info class ] <b> [ namespace tail $object ] </b> <DT>" 
        puts $file "</DL>"

        puts $file "<pre>"
        puts $file [ my getComment $object [ namespace tail $object ] ]
        puts $file "</pre>"

        my putsVariableSummary $file $object
        my putsProcSummary $file $object
        my putsProcDetail $file $object

        flush $file
        close $file
}

HtmlDocument @doc makeClassDetail { 
makeClassDetail does ...
            dir - 
            class -
}

HtmlDocument instproc makeClassDetail { dir class } {
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

        my putsInstMixins $file $class

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
        puts $file [ my getComment $class [ namespace tail $class ] ]
        puts $file "</pre>"

        my putsParameterSummary $file $class
        foreach superclass [ $class info heritage ] {
            my putsParameterInherited $file $superclass
        }
        my putsVariableSummary $file $class
        my putsProcSummary $file $class
        my putsInstprocSummary $file $class
        foreach superclass [ $class info heritage ] {
            my putsInstprocInherited $file $superclass
        }
        my putsInstcommandSummary $file $class
        foreach superclass [ $class info heritage ] {
            my putsInstcommandInherited $file $superclass
        }
        my putsInstfilterSummary $file $class
        foreach superclass [ $class info heritage ] {
            my putsInstfilterInherited $file $superclass
        }
        my putsInstforwardSummary $file $class

        my putsProcDetail $file $class
        my putsInstprocDetail $file $class

        my putsInstcommandDetail $file $class

        flush $file
        close $file
}


HtmlDocument @doc makeClassIndex { 
makeClassIndex does ...
            dir - 
            objectList -
}

HtmlDocument instproc makeClassIndex { dir objectList } {
        set file [ open [ file join $dir allclasses-frame.html ] w ]

        my putsHeader "All Objects" $file

        puts $file "

<FONT size=\"+1\" CLASS=\"FrameHeadingFont\">
<B>All Objects</B></FONT>
<BR>

<TABLE BORDER=\"0\" WIDTH=\"100%\">
<TR>
<TD NOWRAP>
<FONT CLASS=\"FrameItemFont\">
        "

        foreach class $objectList {

            puts $file "
            <A HREF=\"[ my cleanUpLink $class].html\" TARGET=\"classFrame\">$class</A>
            <BR>"
        }

        puts $file "
        <BR>
        </FONT></TD>
        </TR>
        </TABLE>

        </BODY>
        </HTML>"

        flush $file
        close $file
    
}


HtmlDocument @doc makeClassIndexPerNamespace { 
makeClassIndexPerNamespace does ...
            dir - 
            namespace - 
            objectList -
}

HtmlDocument instproc makeClassIndexPerNamespace { dir namespace objectList } {
        set file [ open [ file join $dir [ my cleanUpLink $namespace]-frame.html ] w ]

        set localClassList {}

        foreach class $objectList {

            if { "$namespace" == "[ namespace qualifiers $class ]" } {

                lappend localClassList $class
            }
        }

        set localClassList [ lsort -unique $localClassList ]

        puts $file " <FONT size=\"+1\" CLASS=\"FrameTitleFont\">
<A HREF=\"[ my cleanUpLink $namespace]-summary.html\" TARGET=\"classFrame\">${namespace}</A></FONT>

<TABLE BORDER=\"0\" WIDTH=\"100%\">
<TR>
<TD NOWRAP><FONT size=\"+1\" CLASS=\"FrameHeadingFont\">
Classes</FONT>&nbsp;
<FONT CLASS=\"FrameItemFont\">
<BR>"

        foreach class $localClassList {

            puts $file " <A HREF=\"[ my cleanUpLink $class ].html\" TARGET=\"classFrame\">[ namespace tail $class ]</A>
<BR>"
        }

        puts $file " </FONT></TD>

</TR>
</TABLE>"

        flush $file
        close $file
    
}


HtmlDocument @doc makeFrames { 
makeFrames does ...
            dir -
}

HtmlDocument instproc makeFrames { dir } {
        set file [ open [ file join $dir index.html ] w ]

        puts $file " <FRAMESET cols=\"20%,80%\">
<FRAMESET rows=\"30%,70%\">
<FRAME src=\"overview-frame.html\" name=\"packageListFrame\">
<FRAME src=\"allclasses-frame.html\" name=\"packageFrame\">
</FRAMESET>
<FRAME src=\"overview-summary.html\" name=\"classFrame\">
</FRAMESET>"

        flush $file
        close $file
    
}


HtmlDocument @doc makeNamespaceIndex { 
makeNamespaceIndex does ...
            dir - 
            namespaceList -
}

HtmlDocument instproc makeNamespaceIndex { dir namespaceList } {
        set file [ open [ file join $dir overview-frame.html ] w ]

        my putsHeader Overview $file

        puts $file " <TABLE BORDER=\"0\" WIDTH=\"100%\">
<TR>
<TD NOWRAP><FONT CLASS=\"FrameItemFont\"><A HREF=\"allclasses-frame.html\" TARGET=\"packageFrame\">All Objects</A></FONT>
<P>
<FONT size=\"+1\" CLASS=\"FrameHeadingFont\">
Namespaces</FONT>
<BR>"

        foreach namespace $namespaceList {

            if { "" == "$namespace" } {

                set namespace ::
            }

            puts $file " 
<FONT CLASS=\"FrameItemFont\"><A HREF=\"[ my cleanUpLink $namespace]-frame.html\" TARGET=\"packageFrame\">${namespace}</A></FONT>
<BR>"

        }

        puts $file " <BR>
</TD>

</TR>
</TABLE>

<P>
&nbsp;"



        flush $file
        close $file
}

HtmlDocument instproc hasUsersGuide { object } {

    if { ! [ my isobject $object ] } { return 0 }

    return [ expr { "[ my getComment $object UsersGuide ]" != "" } ]
}

HtmlDocument instproc makeUsersGuide { dir namespace } {

        if { ! [ my hasUsersGuide $namespace ] } { return }

        set file [ open [ file join $dir [ my cleanUpLink $namespace ]-guide.html ] w ]

        my putsHeader $namespace $file

        [ my navbar ] selectNamespace
        [ my navbar ] putsNavBar $file

        puts $file " <HR>
<H2>

${namespace} User's Guide
</H2>
<pre>
[ my crossLinkUsersGuide $namespace ]
</pre>


<hr/>
<br/>
<br/>
<br/>
"

        flush $file
        close $file

        puts "Generated Users Guide for $namespace"
}

HtmlDocument instproc crossLinkUsersGuide { package } {

    my instvar tclformatter

    set text [ my getComment $package UsersGuide ]

    #set text [ [my tclformatter ] formatTcl $text ]

    #set packageName [ $package packageName ]

    #regsub -all "\\m${packageName}\\M" "$text" "[ my getObjectLinkIfAvailable $package $packageName ]" text

    set objectList [ lsort -unique [ ::xox::ObjectGraph findAllInstances ::xotcl::Object $package ] ] 

    foreach object $objectList {

        set objectName [ namespace tail $object ]

        foreach proc [ $object info procs ] {

            regsub -all "\\m${objectName} ${proc}\\M" "$text" "[ my getObjectLinkIfAvailable $object "${objectName}_${proc}" _self $proc]" text
        }

        if [ my isclass $object ] {

            foreach instproc [ concat [ $object info instprocs ] [ $object info parameter ] ] {

                set instproc [ lindex $instproc 0 ]

                regsub -all "\\m${objectName} ${instproc}\\M" "$text" "[ my getObjectLinkIfAvailable $object "${objectName}_${instproc}" _self $instproc]" text
            }
        }

        if { "$objectName" == "info" } { continue }
        if { "$objectName" == "A" } { continue }
        if { "$objectName" == "HREF" } { continue }
        if { "$objectName" == "TARGET" } { continue }
        if { "$objectName" == "self" } { continue }
        if { "$objectName" == "html" } { continue }
        if { "$objectName" == "test" } { continue }

        regsub -all "\\m${objectName}\\M" "$text" "[ my getObjectLinkIfAvailable $object $objectName ]" text
    
    }
    return $text
}

HtmlDocument @doc makeNamespaceSummary { 
makeNamespaceSummary does ...
            dir - 
            namespace - 
            objectList -
}

HtmlDocument instproc makeNamespaceSummary { dir namespace objectList } {

        set file [ open [ file join $dir [ my cleanUpLink $namespace ]-summary.html ] w ]

        my putsHeader $namespace $file

        [ my navbar ] selectNamespace
        [ my navbar ] putsNavBar $file

        set localClassList {}

        foreach class $objectList {

            if { "$namespace" == "[ namespace qualifiers $class ]" } {

                lappend localClassList $class
            }
        }

        set localClassList [ lsort -unique $localClassList ]

        set namespaceComment ""

        if [ my isobject $namespace ] {

            set namespaceComment [ my getComment $namespace [ namespace tail $namespace ] ]
        } else {

            catch { 
                if { ! [ my isobject ${namespace}::info ] } {
                    Object create $namespace -noinit -requireNamespace 
                }
            }
        }

        puts $file " <HR>
<H2>

Namespace ${namespace}
</H2>
<pre>
$namespaceComment
</pre>

"
    if [ my isobject $namespace ] {
        my putsVariableSummary $file $namespace
        my putsProcSummary $file $namespace
    }

    if { "" != "$localClassList" } {

    puts $file " 
<TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">
<TR BGCOLOR=\"#CCCCFF\" CLASS=\"TableHeadingColor\">
<TD COLSPAN=2><FONT SIZE=\"+2\">
<B>Object Summary</B></FONT></TD>
</TR>
"

    foreach class $localClassList {

        puts $file " 
<TR BGCOLOR=\"white\" CLASS=\"[ namespace tail $class ]\">
<TD WIDTH=\"15%\"><B><A HREF=\"[ my cleanUpLink $class].html\">[ namespace tail $class]</A></B></TD>
<TD>&nbsp;<b>[ my getShortComment $class [ namespace tail $class ] ]</b></TD>
</TR>"

    }

    }

    if [ my isobject $namespace ] {
        puts $file "<br>"
        my putsProcDetail $file $namespace
    }

    puts $file " 
</TABLE>
&nbsp;

<P>

<HR>


    "



    puts "Generated doc for $namespace"
}


HtmlDocument @doc makeOverview { 
makeOverview does ...
            dir - 
            namespaceList -
}

HtmlDocument instproc makeOverview { dir namespaceList } {
        set file [ open [ file join $dir overview-summary.html ] w ]

        my putsHeader "Overview" $file

        [ my navbar ] selectOverview
        [ my navbar ] putsNavBar $file

        puts $file "
<HR>

<TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">
<TR BGCOLOR=\"#CCCCFF\" CLASS=\"TableHeadingColor\">
<TD COLSPAN=3><FONT SIZE=\"+2\">
<B>Namespace</B></FONT></TD>
</TR>
"

        foreach namespace $namespaceList {

            if { "" == "$namespace" } {

                set namespace ::
            }


        set packageDescription ""
        set usersGuide ""

        set packageObject "::${namespace}"

        if [ Object isobject $packageObject ] {

            set packageDescription [ my getShortComment $packageObject [ namespace tail $packageObject ] ]
            if [ my hasUsersGuide $packageObject ] {

                set usersGuide "<a href=\"[ my cleanUpLink $namespace]-guide.html\">User's Guide</a>"
            }
        }

        puts $file " <TR BGCOLOR=\"white\" CLASS=\"TableRowColor\">
<TD WIDTH=\"20%\"><B><A HREF=\"[ my cleanUpLink $namespace]-summary.html\">${namespace}</A></B></TD>
<TD>&nbsp;$packageDescription</TD>
<TD>&nbsp;$usersGuide</TD>
</TR>"

        }

        puts $file " </TABLE>

<P>
&nbsp;<HR>"

        flush $file
        close $file
    
}


HtmlDocument @doc putsAssociatedTest { 
putsAssociatedTest does ...
            file - 
            class -
}

HtmlDocument instproc putsAssociatedTest { file class } {
        set qualifiers [ namespace qualifiers $class ]
        set mainPackage [ namespace qualifiers $qualifiers ]
        set name [ namespace tail $class ]
        set testedName [ string range $name 4 end ]

        set testClass "${qualifiers}::test::Test${name}"
        set testedClass "${mainPackage}::${testedName}"

        #puts "testClass $testClass"
        #puts "testedClass $testedClass"

        if { [ Object isobject $testClass ] } {
            puts -nonewline $file "
            <DL>
            <DT><B>Associated Test:</B> <DD>" 

            puts $file "[my getObjectLinkIfAvailable $testClass $testClass ]"

            puts $file "</DD>
            </DL>
            <HR>"
            return

        } elseif { [ Object isobject $testedClass ] } {

            puts -nonewline $file "
            <DL>
            <DT><B>Tested Object:</B> <DD>" 

            puts $file "[my getObjectLinkIfAvailable $testedClass $testedClass ]"

            puts $file "</DD>
            </DL>
            <HR>"
            return

        } else {
            return
        }

    
}


HtmlDocument @doc putsClassHeritage { 
putsClassHeritage does ...
            file - 
            class -
}

HtmlDocument instproc putsClassHeritage { file class } {
        
        puts $file "<b>Heritage:</b><PRE>"

        set heritage [ $class info heritage ]

        set length [ llength $heritage ]

        incr length -1 

        set brackets 0
        set spaces "  "

        for { set loop $length } { $loop >= 0 } { incr loop -1 } {

            set current [ lindex $heritage $loop ]

            if { $brackets > 0 } {

                puts -nonewline $file  "$spaces|\n$spaces+--"
                append spaces "      "
            }    

            puts $file [ my getObjectLinkIfAvailable $current $current ]

            incr brackets
        }

        puts $file "</PRE>"

    
}


HtmlDocument @doc putsHeader { 
putsHeader does ...
            title - 
            file -
}

HtmlDocument instproc putsHeader { title file } {
        puts $file "

<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">
<!--NewPage-->
<HTML>
<HEAD>
<!-- Generated by xodocument on [ clock format [ clock seconds ] ]  -->
<TITLE>
$title ([ my project ] API)
</TITLE>
<LINK REL =\"stylesheet\" TYPE=\"text/css\" HREF=\"[ my stylesheet ]\" TITLE=\"Style\">
</HEAD>
<SCRIPT>
function asd()
{
    parent.document.title=\"$title ([ my project ] API)\";
}
</SCRIPT>
<BODY BGCOLOR=\"white\" onload=\"asd();\">
"
    
}


HtmlDocument @doc putsInstMixins { 
putsInstMixins does ...
            file - 
            class -
}

HtmlDocument instproc putsInstMixins { file class } {
        if { "" == "[ $class info instmixin ]" } { return }

        set instmixins [ lsort [ $class info instmixin ] ]

        if { [ llength $instmixins ] == 0 } {

            return 
        }

        puts -nonewline $file "
        <DL>
        <DT><B>All Instmixins:</B> <DD>" 


        foreach instmixin $instmixins {

            puts -nonewline $file "<A HREF=\"[ my cleanUpLink $instmixin].html\">${instmixin}</A>, "

        }

        puts $file "</DD>
        </DL>
        <HR>"
    
}


HtmlDocument @doc putsInstcommandDetail { 
putsInstcommandDetail does ...
            file - 
            class -
}

HtmlDocument instproc putsInstcommandDetail { file class } {
        if { [ llength [ my getInstcommandsOnly $class ] ] == 0 } { return }

        puts $file "
<!-- ============ INSTCOMMAND DETAIL ========== -->

<A NAME=\"instcommand_detail\"><!-- --></A>
<TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">
<TR BGCOLOR=\"#CCCCFF\" CLASS=\"TableHeadingColor\">
<TD COLSPAN=1><FONT SIZE=\"+2\">

<B>Instcommand Detail</B></FONT></TD>
</TR>
</TABLE>
        "

        foreach instcommand [ my getInstcommandsOnly $class ] { 

            puts $file "

<A NAME=\"[ my cleanUpLink $instcommand]\"><!-- --></A><H3>
${instcommand}</H3>
<PRE>
<font color=\"green\">
[ my getComment $class $instcommand ]
</font>
${class} instcommand [ my getInstcommandSummary $class $instcommand ] 
</PRE>
<HR>
            "

        }

    
}


HtmlDocument @doc putsInstcommandInherited { 
putsInstcommandInherited does ...
            file - 
            class -
}

HtmlDocument instproc putsInstcommandInherited { file class } {
        
        if { [ llength [ my getInstcommandsOnly $class ] ] == 0 } {

            return
        }

        puts -nonewline $file "

        &nbsp;<A NAME=\"instcommands_inherited_from_class_[ my cleanUpLink $class]\"><!-- --></A>
        <TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">
        <TR BGCOLOR=\"#EEEEFF\" CLASS=\"TableSubHeadingColor\">
        <TD><B>Instcommands inherited from class [ my getObjectLinkIfAvailable $class $class ] </B></TD>
        </TR>
        <TR BGCOLOR=\"white\" CLASS=\"TableRowColor\">

        <TD><CODE>"

        foreach instcommand [ my getInstcommandsOnly $class ] {

            puts -nonewline $file " [ my getObjectLinkIfAvailable $class $instcommand _self $instcommand ], "

        }

        puts $file "
        </CODE></TD>

        </TR>
        </TABLE>
        &nbsp;
        "

    
}


HtmlDocument @doc putsInstcommandSummary { 
putsInstcommandSummary does ...
            file - 
            class -
}

HtmlDocument instproc putsInstcommandSummary { file class } {
        if { "" == "[ my getInstcommandsOnly $class ]" } { return }

        puts $file "

<!-- =========== Instcommand SUMMARY =========== -->

<A NAME=\"instcommand_summary\"><!-- --></A>
<TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">

<TR BGCOLOR=\"#CCCCFF\" CLASS=\"TableHeadingColor\">
<TD COLSPAN=2><FONT SIZE=\"+2\">
<B>Instcommand Summary</B></FONT></TD>
</TR>

    "
        foreach instcommand [ my getInstcommandsOnly $class ] {

            puts $file "

<TR BGCOLOR=\"white\" CLASS=\"TableRowColor\">
<TD><CODE> [ my getInstcommandSummary $class $instcommand ]
</CODE> <br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
[ my getShortComment $class $instcommand ]
</TD>
</TR>
"
        }

        puts $file "

        </TABLE>
        &nbsp;
        "
    
}


HtmlDocument @doc putsInstfilterInherited { 
putsInstfilterInherited does ...
            file - 
            class -
}

HtmlDocument instproc putsInstfilterInherited { file class } {
        if { [ llength [ $class info instfilter ] ] == 0 } {

            return
        }

        puts -nonewline $file "

        &nbsp;<A NAME=\"instfilters_inherited_from_class_[ my cleanUpLink $class]\"><!-- --></A>
        <TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">
        <TR BGCOLOR=\"#EEEEFF\" CLASS=\"TableSubHeadingColor\">
        <TD><B>Instfilters inherited from class [ my getObjectLinkIfAvailable $class $class ] </B></TD>
        </TR>
        <TR BGCOLOR=\"white\" CLASS=\"TableRowColor\">

        <TD><CODE>"

        foreach instfilter [ lsort [ $class info instfilter ] ] {

            puts -nonewline $file " [ my getObjectLinkIfAvailable $class $instfilter _self $instfilter ], "

        }

        puts $file "
        </CODE></TD>

        </TR>
        </TABLE>
        &nbsp;
        "
    
}


HtmlDocument @doc putsInstfilterSummary { 
putsInstfilterSummary does ...
            file - 
            class -
}

HtmlDocument instproc putsInstfilterSummary { file class } {
        if { "" == "[ $class info instfilter ]" } { return }

        puts $file "

<!-- =========== Instfilter SUMMARY =========== -->

<A NAME=\"instfilter_summary\"><!-- --></A>
<TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">

<TR BGCOLOR=\"#CCCCFF\" CLASS=\"TableHeadingColor\">
<TD COLSPAN=2><FONT SIZE=\"+2\">
<B>Instfilter Summary</B></FONT></TD>
</TR>

    "
        foreach instfilter [ lsort [ $class info instfilter -guards ] ] {

            puts $file "

<TR BGCOLOR=\"white\" CLASS=\"TableRowColor\">
<TD><CODE><B><A HREF=\"#[ my cleanUpLink $instfilter]\">${instfilter}</A></B></CODE>
</TD>
</TR>
"
        }

        puts $file "

        </TABLE>
        &nbsp;
        "
    
}


HtmlDocument @doc putsInstforwardSummary { 
putsInstforwardSummary does ...
            file - 
            class -
}

HtmlDocument instproc putsInstforwardSummary { file class } {
        if { "" == "[ $class info instforward ]" } { return }

        puts $file "

<!-- =========== Instforward SUMMARY =========== -->

<A NAME=\"instforward_summary\"><!-- --></A>
<TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">

<TR BGCOLOR=\"#CCCCFF\" CLASS=\"TableHeadingColor\">
<TD COLSPAN=2><FONT SIZE=\"+2\">
<B>Instforward Summary</B></FONT></TD>
</TR>

    "
        foreach instforward [ lsort [ $class info instforward ] ] {

            puts $file "

<TR BGCOLOR=\"white\" CLASS=\"TableRowColor\">
<TD><CODE><B><A HREF=\"#[ my cleanUpLink $instforward]\">${instforward}</A></B></CODE>
</TD>
</TR>
"
        }

        puts $file "

        </TABLE>
        &nbsp;
        "
    
}


HtmlDocument @doc putsInstprocDetail { 
putsInstprocDetail does ...
            file - 
            class -
}

HtmlDocument instproc putsInstprocDetail { file class } {
        if { "" == "[ $class info instprocs ]" } { return }

        puts $file "
<!-- ============ INSTPROC DETAIL ========== -->

<A NAME=\"instproc_detail\"><!-- --></A>
<TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">
<TR BGCOLOR=\"#CCCCFF\" CLASS=\"TableHeadingColor\">
<TD COLSPAN=1><FONT SIZE=\"+2\">

<B>Instproc Detail</B></FONT></TD>
</TR>
</TABLE>
        "

        foreach instproc [ lsort [ $class info instprocs ] ] { 

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
            set testClass [ my getTestName $class ]
            set testMethod [ my getTestMethodName $instproc ]


            if { [ my isclass $testClass ] && [ $testClass info instprocs $testMethod ] != "" } {

            puts $file "<dt><b> Test: </b> </dt> <dd>[my getObjectLinkIfAvailable $testClass $testMethod _self $testMethod ] </dd>"

            }

            puts $file "<dt> <b> Code: </b> </dt> <dd><PRE> <b> ${class} instproc [ my getInstprocSummary $class $instproc ] </b> \{
   [ my cleanUpDataForHtml [ $class info instbody $instproc ] ]
\}
</PRE></dd>
<HR></dl>
            "

        }

    
}


HtmlDocument @doc putsInstprocInherited { 
putsInstprocInherited does ...
            file - 
            class -
}

HtmlDocument instproc putsInstprocInherited { file class } {
        
        if { [ llength [ $class info instprocs ] ] == 0 } {

            return
        }

        puts -nonewline $file "

        &nbsp;<A NAME=\"instprocs_inherited_from_class_[ my cleanUpLink $class]\"><!-- --></A>
        <TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">
        <TR BGCOLOR=\"#EEEEFF\" CLASS=\"TableSubHeadingColor\">
        <TD><B>Instprocs inherited from class [ my getObjectLinkIfAvailable $class $class ] </B></TD>
        </TR>
        <TR BGCOLOR=\"white\" CLASS=\"TableRowColor\">

        <TD><CODE>"

        foreach instproc [ lsort [ $class info instprocs ] ] {

            puts -nonewline $file " [ my getObjectLinkIfAvailable $class $instproc _self $instproc ], "

        }

        puts $file "
        </CODE></TD>

        </TR>
        </TABLE>
        &nbsp;
        "

    
}


HtmlDocument @doc putsInstprocSummary { 
putsInstprocSummary does ...
            file - 
            class -
}

HtmlDocument instproc putsInstprocSummary { file class } {
        
        if { "" == "[ $class info instprocs ]" } { return }

        puts $file "

<!-- =========== Instproc SUMMARY =========== -->

<A NAME=\"instproc_summary\"><!-- --></A>
<TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">

<TR BGCOLOR=\"#CCCCFF\" CLASS=\"TableHeadingColor\">
<TD COLSPAN=2><FONT SIZE=\"+2\">
<B>Instproc Summary</B></FONT></TD>
</TR>

    "
        foreach instproc [ lsort [ $class info instprocs ] ] {

            puts $file "

<TR BGCOLOR=\"white\" CLASS=\"TableRowColor\">
<TD><CODE> [ my getInstprocSummary $class $instproc ]
</CODE> <br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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


HtmlDocument @doc putsParameterInherited { 
putsParameterInherited does ...
            file - 
            class -
}

HtmlDocument instproc putsParameterInherited { file class } {
        if { [ llength [ $class info parameter ] ] == 0 } {

            return
        }

        puts -nonewline $file "

        &nbsp;<A NAME=\"parameters_inherited_from_class_[ my cleanUpLink $class]\"><!-- --></A>
        <TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">
        <TR BGCOLOR=\"#EEEEFF\" CLASS=\"TableSubHeadingColor\">
        <TD><B>Parameters inherited from class [ my getObjectLinkIfAvailable $class $class ] </B></TD>
        </TR>
        <TR BGCOLOR=\"white\" CLASS=\"TableRowColor\">

        <TD><CODE>"

        foreach parameterValue [ $class info parameter ] {

            set parameter [ lindex $parameterValue 0 ]

            puts -nonewline $file " [ my getObjectLinkIfAvailable $class $parameter _self $parameter ], "

        }

        puts $file "
        </CODE></TD>

        </TR>
        </TABLE>
        &nbsp;
        "

    
}


HtmlDocument @doc putsParameterSummary { 
putsParameterSummary does ...
            file - 
            class -
}

HtmlDocument instproc putsParameterSummary { file class } {
        if { "" == "[ $class info parameter ]" } { return }

        puts $file "

<!-- =========== Parameter SUMMARY =========== -->

<A NAME=\"parameter_summary\"><!-- --></A>
<TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">

<TR BGCOLOR=\"#CCCCFF\" CLASS=\"TableHeadingColor\">
<TD COLSPAN=3><FONT SIZE=\"+2\">
<B>Parameter Summary</B></FONT></TD>
</TR>

    "
        foreach parameterDefault [ $class info parameter ] {

            set parameter [ lindex $parameterDefault 0 ]
            set defaultValue [ lindex $parameterDefault 1 ]

            if { "" == "$defaultValue" } {
                if { [ llength $parameterDefault ] == 2 } {
                    set defaultValue {""}
                }
            }

            puts $file "

<TR BGCOLOR=\"white\" CLASS=\"TableRowColor\">
<TD><CODE><B><A HREF=\"#[ my cleanUpLink $parameter]\">${parameter}</A></B></CODE>
</TD><TD>&nbsp;$defaultValue</TD><TD>&nbsp;[ my getComment $class $parameter ]</TD>
</TR>
"
        }

        puts $file "

        </TABLE>
        &nbsp;
        "
    
}

HtmlDocument instproc putsVariableSummary { file object } {

        if { "" == "[ $object info vars ]" } { return }

        puts $file "

<!-- =========== VARIABLE SUMMARY =========== -->

<A NAME=\"variable_summary\"><!-- --></A>
<TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">

<TR BGCOLOR=\"#CCCCFF\" CLASS=\"TableHeadingColor\">
<TD COLSPAN=3><FONT SIZE=\"+2\">
<B>Variables</B></FONT></TD>
</TR>

    "

        foreach var [ $object info vars ] {

            if { "$var" == "#" } { continue }

            if [ $object array exists $var ] { 

                foreach index [ $object array names $var ] {

            puts $file "

<TR BGCOLOR=\"white\" CLASS=\"TableRowColor\">
<TD><CODE><B>${var}\($index\)</B></CODE>
</TD><TD>&nbsp;[ $object set $var\($index\) ]</TD><TD>&nbsp;[ my getComment $object $var ]</TD>
</TR>
"
                }

            } else {

            puts $file "

<TR BGCOLOR=\"white\" CLASS=\"TableRowColor\">
<TD><CODE><B>${var}</B></CODE>
</TD><TD>&nbsp;[ $object set $var ]</TD><TD>&nbsp;[ my getComment $object $var ]</TD>
</TR>
"
            }
        }

        puts $file "

        </TABLE>
        &nbsp;
        "
    
}

HtmlDocument @doc putsProcDetail { 
putsProcDetail does ...
            file - 
            class -
}

HtmlDocument instproc putsProcDetail { file object } {
    
        if { "" == "[ $object info procs ]" } { return }

        puts $file "
<!-- ============ PROC DETAIL ========== -->

<A NAME=\"proc_detail\"><!-- --></A>
<TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">
<TR BGCOLOR=\"#CCCCFF\" CLASS=\"TableHeadingColor\">
<TD COLSPAN=1><FONT SIZE=\"+2\">

<B>Proc Detail</B></FONT></TD>
</TR>
</TABLE>
        "

        foreach proc [ lsort [ $object info procs ] ] { 

            puts $file " <A NAME=\"[ my cleanUpLink $proc]\"><!-- --></A><H3>
${proc}</H3>
<dl>
<dt>
<b> Description: </b> </dt><dd><PRE><font color=\"green\"> [ my getComment $object $proc ]</font></PRE></dd>"

        if { "" != [ $object info args $proc ] } {

        puts $file "<dt> <b> Arguments: </b> </dt>"
        puts $file "<dd><ul>"
        foreach arg [ $object info args $proc ] {

            if [ $object info default $proc $arg defaultValue ] {

                if { "" == "$defaultValue" } {

                    set defaultValue {""}
                }

                puts $file "<li> <code>$arg</code> - optional, default value: <code>$defaultValue</code> </li>"

            } else {

                puts $file "<li><code>$arg</code> </li>"
            }
        }
        puts $file "</ul></dd>"

        }

        set overridenClass ""

        if [ my isclass $object ] {

        foreach superclass [ $object info superclass ] {

            set overridenClass [ ::xox::ObjectGraph findFirstImplementation $superclass $proc ]

            if { "" != "$overridenClass" } { break }
        }

        }

        if { "" != "$overridenClass" } {
            puts $file "<dt> <b> Overrides: </b> </dt>"
            puts $file "<dd>[my getObjectLinkIfAvailable $overridenClass $proc _self $proc ] in [my getObjectLinkIfAvailable $overridenClass $overridenClass ]</dd>"
        }

            puts $file "<dt> <b> Code: </b> </dt> <dd><PRE> <b> ${object} proc [ my getProcSummary $object $proc ] </b> \{
   [ my cleanUpDataForHtml [ $object info body $proc ] ]
\}
</PRE></dd>
<HR></dl>
            "

        }
    

    flush $file
}


HtmlDocument @doc putsProcSummary { 
putsProcSummary does ...
            file - 
            class -
}

HtmlDocument instproc putsProcSummary { file class } {
        if { "" == "[ $class info procs ]" } { return }

        puts $file "

<!-- =========== PROC SUMMARY =========== -->

<A NAME=\"proc_summary\"><!-- --></A>
<TABLE BORDER=\"1\" CELLPADDING=\"3\" CELLSPACING=\"0\" WIDTH=\"100%\">

<TR BGCOLOR=\"#CCCCFF\" CLASS=\"TableHeadingColor\">
<TD COLSPAN=2><FONT SIZE=\"+2\">
<B>Proc Summary</B></FONT></TD>
</TR>

    "
        foreach proc [ lsort [ $class info procs ] ] {

            puts $file "

<TR BGCOLOR=\"white\" CLASS=\"TableRowColor\">
<TD><CODE> [ my getProcSummary $class $proc ]
</CODE> <br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
[ my getShortComment $class $proc ]
</TD>
</TR>
"
        }

        puts $file "

        </TABLE>
        &nbsp;
        "
    
}


HtmlDocument @doc putsSubclasses { 
putsSubclasses does ...
            file - 
            class -
}

HtmlDocument instproc putsSubclasses { file class } {
        set subclasses [ lsort [ $class info subclass ] ]

        if { [ llength $subclasses ] == 0 } {

            return 
        }

        puts -nonewline $file "
        <DL>
        <DT><B>Direct Known Subclasses:</B> <DD>" 


        foreach subclass $subclasses {

            puts -nonewline $file "[ my getObjectLinkIfAvailable $subclass $subclass ], "

        }

        puts $file "</DD>
        </DL>
        <HR>"
    
}
}


