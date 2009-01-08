# Created at Mon Jul 21 19:51:36 EDT 2008 by bthomass

namespace eval ::xohtml {

    ::xodsl::LanguageClass create HtmlGenerationLanguage -superclass ::xodsl::StringBuildingLanguage

    HtmlGenerationLanguage mixin add ::xodsl::MacroClass
    HtmlGenerationLanguage instmixin add ::xodsl::Macro

    HtmlGenerationLanguage @doc HtmlGenerationLanguage {

        HtmlGenerationLanguage is a Domain Specific Language for generating HTML.  It allows users to use
        commands instead of <tags> for generating HTML.  All Tcl commands can be used with the HTML tag commands. Thus
        any kind of logic or looping constructs are available when generating HTML.  HtmlGenerationLanguage also supports
        HtmlWidgets which are objects that hold state and generate their own HTML code. HtmlWidgets allow
        users to make modular and reusable web interface components. These can be customized for each HTML page generated.
    }

    HtmlGenerationLanguage @example HtmlGenerationLanguage {

        html {
            head {
                title ' Hello World In HtmlGenerationLanguage
            }
            body {
                h1 ' Hello World
                for { set i 1 } { $i < 7 } { incr i } {
                    h2 ' $i Hello $::env(USER)
                }
            }
        }
    }

    HtmlGenerationLanguage parameter {
    }

    HtmlGenerationLanguage instproc init { } {

        my lappend globalProcs method subst isclass configure check eval requireNamespace autoname isobject proc lappend instvar move exists volatile info __next istype array cleanup filterguard filtersearch filter contains append noinit self hasclass set parametercmd defaultmethod trace ismixin ismetaclass procsearch destroy vwait uplevel extractConfigureArg copy init forward upvar unset mixinguard invar incr abstract class

    }

    HtmlGenerationLanguage @doc fixArgs {

        Internally used.

        If arguments list is a single item return the contents of that item. Otherwise return the list of items in arguments.
        This is useful to enable processing of "args" as a script or a single command.
    }

    HtmlGenerationLanguage @tag fixArgs hidden

    HtmlGenerationLanguage instproc fixArgs { arguments } {

        #puts "<a>$arguments<a/>"

        set return $arguments
        catch {
            if { [ llength $arguments ] == 1 } {
                    set return [ lindex $arguments 0 ] 
            } 
        }

        #puts "<r>$arguments<r/>"

        return $return
    }

    HtmlGenerationLanguage @doc buildAttributes {

        Internally used.

        Builds a list of HTML attributes.
    }

    HtmlGenerationLanguage @tag buildAttributes hidden

    HtmlGenerationLanguage instproc buildAttributes { args } {

        set __attributes ""

        foreach __arg $args {

            upvar $__arg $__arg
            if [ info exists $__arg ] {
                append __attributes " $__arg=\"[ set $__arg ]\" "
            }
        }
        return $__attributes
    }

    HtmlGenerationLanguage proc tag { name args } {

        set dashedOptions ""
        set attributes $args

        foreach attribute $attributes {
            lappend dashedOptions "-${attribute}"
        }

        my @doc $name "

            Creates HTML $name tag: <$name></$name>. 
            The args arguments are evaluated and will appear inside this tag. 
            If args is a single block of code it will be evaluated as a script.
        "

        my @arg $name args { Each argument is evaluated inside the tag block. }

        foreach attribute $attributes {
            my @arg $name -${attribute} "$attribute argument for the $name tag"
        }

        my instproc $name " $dashedOptions " { args } [ subst {
            my instvar environment 
            #puts "\$environment \[ \$environment info class \]"
            set args \[ my fixArgs \$args \]
            set attributes \[ my buildAttributes $attributes \] 
            #puts \$args
            my write \"<$name\$attributes>\"
            \$environment eval \$args 
            my write \"</$name>\"
            return
        } ]
    }

    HtmlGenerationLanguage proc singleTag { name args } {

        set dashedOptions ""
        set attributes $args

        foreach attribute $attributes {
            lappend dashedOptions "-${attribute}"
        }

        my @doc $name "

            Creates HTML $name tag: <$name>. 
        "

        foreach attribute $attributes {
            my @arg $name -${attribute} "$attribute argument for the $name tag"
        }

        my instproc $name " $dashedOptions " { } [ subst {
            set attributes \[ my buildAttributes $attributes \] 
            my write \"<$name\$attributes>\"
            return
        } ]
    }

    #HtmlGenerationLanguage instproc a { -href -name } { args } {
    #    my instvar environment 
    #    if [ info exists href ] {
    #        regsub -all {#} $href {%23} href
    #        regsub -all {:} $href {%3A} href
    #    }
    #    set args [ my fixArgs $args ]
    #    set attributes [ my buildAttributes href name ]
    #    my write "<a$attributes>"
    #    $environment eval $args 
    #    my write "</a>"
    #    return
    #}

    HtmlGenerationLanguage tag a href name target
    HtmlGenerationLanguage tag b
    HtmlGenerationLanguage tag p id class
    HtmlGenerationLanguage tag body bgcolor
    HtmlGenerationLanguage tag code
    HtmlGenerationLanguage tag div class id style
    HtmlGenerationLanguage tag span class id style
    HtmlGenerationLanguage tag html
    HtmlGenerationLanguage tag head
    HtmlGenerationLanguage tag meta http-equiv content
    HtmlGenerationLanguage tag h1 class
    HtmlGenerationLanguage tag h2 class
    HtmlGenerationLanguage tag h3 class
    HtmlGenerationLanguage tag h4 class
    HtmlGenerationLanguage tag h5 class
    HtmlGenerationLanguage tag h6 class
    HtmlGenerationLanguage tag pre class
    HtmlGenerationLanguage tag ul class
    HtmlGenerationLanguage tag ol class
    HtmlGenerationLanguage tag li class
    HtmlGenerationLanguage tag form action method onsubmit name class
    HtmlGenerationLanguage tag input type name value size id onclick src style
    HtmlGenerationLanguage tag img src title style
    HtmlGenerationLanguage tag table id class
    HtmlGenerationLanguage tag tr class
    HtmlGenerationLanguage tag td class style
    HtmlGenerationLanguage tag th class colspan
    HtmlGenerationLanguage tag thead class
    HtmlGenerationLanguage tag tfoot class
    HtmlGenerationLanguage tag tbody class
    HtmlGenerationLanguage tag title class
    HtmlGenerationLanguage tag style type
    HtmlGenerationLanguage tag textarea name rows cols readonly id
    HtmlGenerationLanguage tag select name class id onChange
    HtmlGenerationLanguage tag option
    HtmlGenerationLanguage tag script language src type
    HtmlGenerationLanguage tag meta http-equiv content charset
    HtmlGenerationLanguage singleTag br
    HtmlGenerationLanguage singleTag hr


    HtmlGenerationLanguage @doc defineWidget {

        Defines a new Widget Class.  All Widgets are a subclass of ::xohtml::HtmlWidget and provide a quick
        method to hold data and produce HTML using that data.
    }

    HtmlGenerationLanguage @arg defineWidget name { The name of the widget class.  ::xohtml::widget will be added if name is not fully-qualified }
    HtmlGenerationLanguage @arg defineWidget parameters { The parameters for the Widget Class. }
    HtmlGenerationLanguage @arg defineWidget modelCode { }
    HtmlGenerationLanguage @arg defineWidget htmlWidgetCode { HtmlGenerationLanguage code that defines the HTML the Widget will produce. }

    HtmlGenerationLanguage @example defineWidget {

        defineWidget Hello { name } {

            h1 ' "Hello $name"
        }
    }

    HtmlGenerationLanguage instproc defineWidget { name parameters modelCode htmlWidgetCode } {

        ::xohtml::WidgetClass defineWidget $name $parameters $modelCode $htmlWidgetCode
        return 
    }

    HtmlGenerationLanguage @doc css {

        Creates a CSS block.  

        The block argument is not evalutated.
    }

    HtmlGenerationLanguage @arg css block { A block of CSS code. }

    HtmlGenerationLanguage @example css {

        css {
            body {
                font-family: Helvetica,Arial,Sans-Serif;
                background-color: #CCC;
            }
        }
    }

    HtmlGenerationLanguage instproc css { block } {

        my write "<style type=\"text/css\"><!--
        $block
        --></style>"
    }

    HtmlGenerationLanguage instproc javascript { block } {

        my write "<script language=\"javascript\" type=\"text/javascript\"><!--
        $block
        --></script>"
    }

    HtmlGenerationLanguage @doc source {

        Loads an HtmlGenerationLanguage source file.  The code in the file is evaluted as HtmlGenerationLanguage code.  Commands
        in the file can be Tcl, XOTcl, or HtmlGenerationLanguage commands.
    }

    HtmlGenerationLanguage @arg source file { An HtmlGenerationLanguage source file. }

    HtmlGenerationLanguage instproc source { file } {

        my instvar environment 

        $environment eval [ ::xox::readFile $file ]
    }

    HtmlGenerationLanguage @doc new {

        Creates a new Widget and inserts its generated HTML in the document.
        The new command creates a new Widget from the "name" class using "args" dashed parameters to configure the widget.  
        Then the Widget's HTML is generated and added to the document.  The Widget is then destroyed.
    }

    HtmlGenerationLanguage @arg new name { The Widget class to create the Widget from. }
    HtmlGenerationLanguage @arg new args { Dashed parameters used to configure the widget. }

    HtmlGenerationLanguage @example new {

        defineWidget Hello { name } { } {
            ' Hello there $name
        }

        h1 ' My Document
        new Hello -name $::env(USER)
    }
    
    HtmlGenerationLanguage instproc new { name args } {

        my instvar collector

        if { ! [ string match ::* $name ] } {

            set name ::xohtml::widget::${name}
        }

        set widget [ eval $name new $args ]
        $widget formatWidgetWithCollector $collector
        $widget destroy

        return
    }


    HtmlGenerationLanguage @doc ,, {

        Evaluates args as a script and converts the characters in the returned string to HTML friendly versions. 
        This command is similar to , except that it converts characters in the returned string.

        This is typed as two commas: ,,
    }

    HtmlGenerationLanguage @example ,, {

        li ,, expr 1 + 1
    }

    HtmlGenerationLanguage @arg ,, args { See description. }

    HtmlGenerationLanguage instproc ,, { args } {

        my instvar environment collector

        if { [ llength $args ] == 1 } {
            set args [ lindex $args 0 ]
        }

        $collector append string [ string map {< &lt; > &gt; } [ $environment eval $args ] ]

        return
    }

    HtmlGenerationLanguage @arg '' args { See description. }

    HtmlGenerationLanguage @doc '' {

        Stops evaluation of arguments and converts characters to HTML friendly versions. 
        This command takes all arguments as strings.  This command is similiar to ' except
        that is converts characters to be HTML friendly.

        This is typed as two single quotes: ''
    }

    HtmlGenerationLanguage @example '' {

        #This command:

        li '' " 1 < 0 "

        #produces:
        <li> 1 &lt; 0 </li>
    }

    HtmlGenerationLanguage instproc '' { args } {

        my instvar collector

        if { [ llength $args ] == 1 } {
            set args [ lindex $args 0 ]
        }

        $collector append string [ string map {< &lt; > &gt;} $args ]

        return
    }

    HtmlGenerationLanguage @doc cleanUpLink {

        Cleans up values in an URL.
    }

    HtmlGenerationLanguage @arg cleanUpLink value { The value to clean up for inclusion in an URL }

    HtmlGenerationLanguage instproc cleanUpLink { value } {
            #regsub -all {%} $value {%25} value
            #regsub -all " " $value {%20} value
            #regsub -all "!" $value {%21} value
            #regsub -all {"} $value {%22} value
            #regsub -all {#} $value {%23} value
            #regsub -all "$" $value {%24} value
            #regsub -all {\&} $value {%26} value
            #regsub -all {\(} $value {%28} value
            #regsub -all {\)} $value {%29} value
            #regsub -all " " $value {\+} value
            #regsub -all {\{} $value {%7B} value
            #regsub -all {\}} $value {%7D} value
            #regsub -all {^} $value {%5E} value
            #regsub -all "," $value {%2C} value
            #regsub -all {:} $value {%3A} value
            #regsub -all "@" $value {%40} value
            #return $value

            return [ string map {: %3A # %23} $value ]
    }

    HtmlGenerationLanguage instproc cleanUpId { value } {
            #regsub -all {%} $value {%25} value
            #regsub -all " " $value {%20} value
            #regsub -all "!" $value {%21} value
            #regsub -all {"} $value {%22} value
            #regsub -all {#} $value {%23} value
            #regsub -all "$" $value {%24} value
            #regsub -all {\&} $value {%26} value
            #regsub -all {\(} $value {%28} value
            #regsub -all {\)} $value {%29} value
            #regsub -all " " $value {\+} value
            #regsub -all {\{} $value {%7B} value
            #regsub -all {\}} $value {%7D} value
            #regsub -all {^} $value {%5E} value
            #regsub -all "," $value {%2C} value
            #regsub -all {:} $value {%3A} value
            #regsub -all "@" $value {%40} value
            #return $value

            return [ string map {: _ # _} $value ]
    }

    HtmlGenerationLanguage @doc add {

        Adds a set of commands to the HtmlGenerationLanguage from a class. This only adds the commands for that page or widget.  It must
        be added again for each page or widget that needs to use those commands.
    }

    HtmlGenerationLanguage @arg add class { The class of commands to add to HtmlGenerationLanguage. }

    HtmlGenerationLanguage instproc add { class } {

        my instvar environment

        my mixin add $class

        foreach method [ $class info instprocs ] {
            $environment forward $method [ self ] $method
        }
    }
}


