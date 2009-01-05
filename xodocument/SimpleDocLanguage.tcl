# Created at Mon Jan 07 13:40:52 EST 2008 by bthomass

namespace eval ::xodocument {

    ::xodsl::LanguageClass create SimpleDocLanguage -superclass ::xodsl::StringBuildingLanguage

    SimpleDocLanguage instmixin add ::xodsl::StringBuilding

    SimpleDocLanguage # SimpleDocLanguage {

        Please describe the class SimpleDocLanguage here.
    }

    SimpleDocLanguage parameter {
        { sectionNumber 0 }
    }

    SimpleDocLanguage instproc evaluateDoc { script } {

        my instvar collector

        set collector [ Object new -set string "" ]

        my evaluateStringScript $script

        return [ $collector set string ]
    }

    SimpleDocLanguage proc bodyTemplate { name arguments } {

        set argumentTabs ""

        foreach argument $arguments {

            append argumentTabs "<$argument>\$$argument</$argument>"
        }

        my instproc $name [ concat $arguments body ] "

            return \[ subst \\
{<$name>
    $argumentTabs
    \[ my evaluateInternalStringScript \$body \]
</$name>} \]
         "
    }

    SimpleDocLanguage instproc bodyTemplate { name arguments } {

        ::xodocument::SimpleDocLanguage bodyTemplate $name $arguments

        ::xodocument::SimpleDocLanguage updateEnvironment [ self ]
    }

    SimpleDocLanguage proc template { name arguments } {

        set argumentTabs ""

        foreach argument $arguments {

            append argumentTabs "<$argument>\$$argument</$argument>"
        }

        my instproc $name $arguments "

            return \[ subst {<$name> $argumentTabs </$name>} \]
            "
    }

    SimpleDocLanguage instproc template { name arguments } {

        ::xodocument::SimpleDocLanguage template $name $arguments
    }

    SimpleDocLanguage proc field { name } {

        my instproc $name { value } "

            return \[ subst {<$name> \$value </$name>} \]
            "
    }

    SimpleDocLanguage instproc field { name } {

        ::xodocument::SimpleDocLanguage field $name
    }

    SimpleDocLanguage proc substituteField { name } {

        my instproc $name { value } "

            return \[ <$name> [ my mysubst \${value} </$name> \]
            "
    }

    SimpleDocLanguage instproc substituteField { name } {

        ::xodocument::SimpleDocLanguage substituteField $name
    }

    SimpleDocLanguage proc substituteBodyTemplate { name arguments } {

        set argumentTabs ""

        foreach argument $arguments {

            append argumentTabs "<$argument>\$$argument</$argument>"
        }

        my instproc $name [ concat $arguments body ] "

            set result \[ my mysubst \${body} \]

            return \[ subst \\
{<$name>
    $argumentTabs
    <body>\${result}</body>
</$name>} \]
         "
    }

    SimpleDocLanguage instproc substituteBodyTemplate { name arguments } {

        ::xodocument::SimpleDocLanguage substituteBodyTemplate $name $arguments
    }

    SimpleDocLanguage instproc removeLeftSpace { text } {

        set lines [ split $text "\n" ]

        set spaces ""
        set first ""
        foreach line $lines {

            set first $line 
            if { "" != "[ string trim $line ]" } { break }
        }

        foreach char [ split $first {} ] {

            if { "$char" == " " } {

                append spaces $char
            } else {
                break
            }
        }

        set length [ string length $spaces ]

        set newLines ""

        set first 1

        foreach line $lines {

            if { !$first } {

                append newLines "\n"
            }
            set first 0

            if [ string match ${spaces}* $line ] {

                append newLines [ string range $line $length end ]

            } else {

                append newLines $line
            }
        }

        return $newLines
    }

    SimpleDocLanguage instproc escape { text } {


        regsub -all {<} $text "\\&lt;" text
        regsub -all {>} $text "\\&gt;" text


        return $text
    }

    SimpleDocLanguage instproc qset { var value } {

        my instvar environment

        $environment set $var $value

        return ""
    }

    SimpleDocLanguage instproc section { title body } {

            my instvar sectionNumber

            set first [ lrange $sectionNumber 0 end-1 ]
            set incr [ expr [ lindex $sectionNumber end ] + 1 ]

            set sectionNumber [ concat $first $incr 0 ]

            set return [ subst \
{<section>
    <title>$title</title>
    <number>[ join [ concat $first $incr ] . ] </number>
    [ my evaluateInternalStringScript $body ]
</section>} ]

            set sectionNumber [ concat $first $incr ]

            return $return
    }

    SimpleDocLanguage instproc @doc { class token } {

        return [ my escape [ $class getClean# $token ] ]
    }

    SimpleDocLanguage instproc  getCommand { class method } {

        if [ $class exists @command($method) ] {

            return [ my escape [ $class set @command($method) ] ]
        }

        return [ my escape $method ]
    }

    SimpleDocLanguage instproc  getParameter { class parameter } {

        if [ $class exists "@parameter($parameter)" ] {

            return [ my escape [ $class set "@parameter($parameter)" ] ]
        }

        return ""
    }

    SimpleDocLanguage instproc  getArgument { class method arg } {

        if { [ llength $arg ] == 2 } {

            return [ my escape [ lindex $arg 1 ] ]
        }

        if [ $class exists "@arg($method $arg)" ] {

            return [ my escape [ $class set "@arg($method $arg)" ] ]
        }

        return ""
    }

    SimpleDocLanguage instproc  getDoc { class method } {

        if [ $class exists #($method) ] {

            return "    [ my escape [ string trim [ $class set #($method) ] ] ]"
        }

        return "."
    }

    SimpleDocLanguage instproc  getReturn { class method } {

        if [ $class exists @return($method) ] {

            return "    [ string trim [ $class set @return($method) ] ]"
        }

        return "    none"
    }

    SimpleDocLanguage instproc  getExample { class method } {

        if [ $class exists @example($method) ] {

            return [ string trim [ my removeLeftSpace [ my escape [ $class set @example($method) ] ] ] "\n\r" ]
        }

        return "."
    }

    SimpleDocLanguage instproc getClassNonPosArgs { class method } {

        set args [ $class info nonposargs $method ] 

        if [ $class exists @nonposargs($method) ] {

            set args [ concat [ $class set @nonposargs($method) ] $args ]
        }

        return $args
    }

    SimpleDocLanguage instproc getClassArgs { class method } {

        set args [ $class info args $method ] 

        if { "$args" == "args" } {

            if [ $class exists @args($method) ] {

                return [ $class set @args($method) ]
            } 

            return "args"
        }

        return $args
    }

    SimpleDocLanguage instproc  getNonPosArgs { class method } {

        set args [ $class info instnonposargs $method ] 

        if [ $class exists @nonposargs($method) ] {

            set args [ concat [ $class set @nonposargs($method) ] $args ]
        }

        return $args
    }

    SimpleDocLanguage instproc  getArgs { class method } {

        set args [ $class info instargs $method ] 

        if { "$args" == "args" } {

            if [ $class exists @args($method) ] {

                return [ $class set @args($method) ]
            } 

            return "args"
        }

        return $args
    }

    SimpleDocLanguage instproc commandReference { class method  } {

        return [ subst { \
<command>
<name>[ my getCommand $class $method ]</name>
<description>
[ my getDoc $class $method ]
</description>
[ ::xox::mappend {
    set argName [ lindex $arg 0 ]
    set type [ lindex [ split $argName : ] 1 ]
    set argName [ lindex [ split $argName : ] 0 ]
    if { "" == "$type" } { set type optional }
    ::xox::identity "<positionalArgument>\n<name>$argName</name><type>$type</type>\n<explanation>[my getArgument $class $method $arg]</explanation>\n</positionalArgument>\n"
} arg [my getNonPosArgs $class $method ] ] 
[ ::xox::mappend {
    set argName [ lindex $arg 0 ]
    ::xox::identity "<argument>\n<name>$argName</name>\n<explanation>[my getArgument $class $method $arg]</explanation>\n</argument>\n"
} arg [my getArgs $class $method ] ] 
[ ::xox::mappend {
    ::xox::identity "<return>$aret</return>"
} aret [ my getReturn $class $method ] ]
<example>[ my escape [my getExample $class $method] ]</example>
</command>
} ]
    }

    SimpleDocLanguage instproc objectCommandReference { class method } {

        return [ subst { \
<command>
<name>[ my getCommand $class $method ]</name>
<description>
[ my getDoc $class $method ]
</description>
[ ::xox::mappend {
    set argName [ lindex $arg 0 ]
    set type [ lindex [ split $argName : ] 1 ]
    set argName [ lindex [ split $argName : ] 0 ]
    if { "" == "$type" } { set type optional }
    ::xox::identity "<positionalArgument>\n<name>$argName</name><type>$type</type>\n<explanation>[my getArgument $class $method $arg]</explanation>\n</positionalArgument>\n"
} arg [my getClassNonPosArgs $class $method ] ] 
[ ::xox::mappend {
    set argName [ lindex $arg 0 ]
    ::xox::identity "<argument>\n<name>$argName</name>\n<explanation>[my getArgument $class $method $arg]</explanation>\n</argument>\n"
} arg [my getClassArgs $class $method ] ] 
[ ::xox::mappend {
    ::xox::identity "<return>$aret</return>"
} aret [ my getReturn $class $method ] ]
<example>[ my escape [my getExample $class $method] ]</example>
</command>
} ]
    }

    SimpleDocLanguage instproc classCommandReference { class method } {

        return [ subst { \
<command>
<name>[ my getCommand $class $method ]</name>
<description>
[ my getDoc $class $method ]
</description>
[ ::xox::mappend {
    set argName [ lindex $arg 0 ]
    set type [ lindex [ split $argName : ] 1 ]
    set argName [ lindex [ split $argName : ] 0 ]
    if { "" == "$type" } { set type optional }
    ::xox::identity "<positionalArgument>\n<name>$argName</name><type>$type</type>\n<explanation>[my getArgument $class $method $arg]</explanation>\n</positionalArgument>\n"
} arg [my getClassNonPosArgs $class $method ] ] 
[ ::xox::mappend {
    set argName [ lindex $arg 0 ]
    ::xox::identity "<argument>\n<name>$argName</name>\n<explanation>[my getArgument $class $method $arg]</explanation>\n</argument>\n"
} arg [my getClassArgs $class $method ] ] 
[ ::xox::mappend {
    ::xox::identity "<return>$aret</return>"
} aret [ my getReturn $class $method ] ]
<example>[ my escape [my getExample $class $method] ]</example>
</command>
} ]
    }

    SimpleDocLanguage instproc parameterReference { class parameter } {

        return [ subst { \
<parameter>
<name>$parameter</name>
<description>
[ my getParameter $class $parameter ]
</description>
</parameter>
} ]
    }

    SimpleDocLanguage instproc mappend { script name list } {

#TODO

    }

    SimpleDocLanguage instproc executable { name description nonposargs posargs returns example } {

        return [ subst { \
<command>
<name>$name</name>
<description>
$description
</description>
[ ::xox::mappend {
    set argName [ lindex $arg 0 ]
    set type [ lindex [ split $argName : ] 1 ]
    set argName [ lindex [ split $argName : ] 0 ]
    if { "" == "$type" } { set type optional }
    ::xox::identity "<positionalArgument>\n<name>$argName</name><type>$type</type>\n<explanation>[ lrange $arg 1 end ]</explanation>\n</positionalArgument>\n"
} arg $nonposargs ]
[ ::xox::mappend {
    set argName [ lindex $arg 0 ]
    ::xox::identity "<argument>\n<name>$argName</name>\n<explanation>[ lrange $arg 1 end ]</explanation>\n</argument>\n"
} arg $posargs ]
<return>$returns</return>
<example>$example</example>
</command>
} ]
    }

    SimpleDocLanguage instproc package { args } {

        eval ::package $args

        return ""
    }

    SimpleDocLanguage instproc orderedList { lines } {

        set list ""

        foreach line [ split $lines "\n" ] {

            set line [ string trim $line ]
            if { "" == "$line" } continue
            append list "<item>$line</item>\n"
        }

        return [ subst {\
        <orderedList>
        $list
        </orderedList>
        } ]
    }

    SimpleDocLanguage instproc unorderedList { lines } {

        set list ""

        foreach line [ split $lines "\n" ] {

            set line [ string trim $line ]
            if { "" == "$line" } continue
            append list "<item>[ my mysubst $line]</item>\n"
        }

        return [ subst {\
        <unorderedList>
        $list
        </unorderedList>
        } ]
    }

    SimpleDocLanguage instproc commandList { } {

        return "<commandList/>"
    }

    SimpleDocLanguage instproc parameterList { } {

        return "<parameterList/>"
    }

    SimpleDocLanguage instproc example { title body } {

            return [ subst \
{<example>
    <title>$title</title>
    <body>[ my removeLeftSpace [ my escape ${body} ] ]</body>
</example>} ]
    }

    SimpleDocLanguage instproc code { body } {

            return [ subst \
{<code>
    <body>[ my removeLeftSpace [ my escape ${body} ] ]</body>
</code>} ]
    }

    SimpleDocLanguage instproc includeExample { title class method } {

            return [ subst \
{<example>
    <title>$title</title>
    <body>[ my removeLeftSpace [ my escape [ $class info instbody $method ] ] ]</body>
</example>} ]
    }

    SimpleDocLanguage instproc xodocSite { site } {

        my set xodocSite $site
        return
    }

    SimpleDocLanguage instproc xodoc { class } {

        my instvar xodocSite

        set link [ my cleanUpLink $class ].html

        return [ subst \
{<link>
<text> $class </text> <href> $xodocSite/$link </href>
</link>
} ]
    }

    SimpleDocLanguage instproc cleanUpLink { link } {
            regsub -all {::} "$link" {_} link
            regsub -all {#} "$link" {_} link

            return $link
        
    }

    SimpleDocLanguage instproc wikiSite { site } {

        my set wikiSite $site
        return
    }

    SimpleDocLanguage instproc cleanUpWikiLink { link } {
        
        regsub -all { } $link {+} link

        return $link
    }

    SimpleDocLanguage instproc wiki { args } {

        my instvar wikiSite

        set link [ my cleanUpWikiLink $args ]

        return [ subst \
{<link>
<text> $args </text> <href> $wikiSite/$link </href>
</link>
} ]
    }

    SimpleDocLanguage instproc wikiAnchor { args } {

        my instvar wikiSite

        set pageAnchor [ split $args # ]

        set page [ my cleanUpWikiLink [ string trim [ lindex $pageAnchor 0 ] ] ]
        set anchor [ string trim [ lindex $pageAnchor 1 ] ]

        regsub -all { } $anchor {%20} anchorLink

        set link [ my cleanUpWikiLink $page ]

        return [ subst \
{<link>
<text> $anchor </text> <href> $wikiSite/${page}#${anchorLink} </href>
</link>
} ]
    }

    SimpleDocLanguage instproc anchorLink { args } {

        regsub -all { } $args {%20} anchorLink

        return [ subst \
{<link>
<text> $args </text> <href> #${anchorLink} </href>
</link>
} ]
    }

    SimpleDocLanguage bodyTemplate document { title } 
    SimpleDocLanguage bodyTemplate command { name } 
    SimpleDocLanguage substituteBodyTemplate text {} 
    SimpleDocLanguage template link { text href } 
    SimpleDocLanguage field Author
    SimpleDocLanguage field Date
}


