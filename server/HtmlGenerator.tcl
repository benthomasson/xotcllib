# Created at Fri Feb 08 17:53:30 EST 2008 by bthomass

namespace eval ::server {

    Class HtmlGenerator -superclass ::xointerp::LibraryInterpreter

    HtmlGenerator # HtmlGenerator {

        Please describe the class HtmlGenerator here.
    }

    HtmlGenerator parameter {

    }

    HtmlGenerator instmixin add ::xointerp::StringBuilding

    HtmlGenerator instproc init { } {

        my library [ self ]
    }

    HtmlGenerator instproc img { src {title "" } { script ""} } {

        return "<img src=\"$src\" title=\"$title\" $script>"
    }

    HtmlGenerator instproc pre { script } {

        return [ my evalSubstCurrentLevel "<pre>$script</pre>" ]
    }

    HtmlGenerator instproc td { script } {

        return [ my evalSubstCurrentLevel "<td>$script</td>" ]
    }

    HtmlGenerator instproc tr { script } {

        return [ my evalSubstCurrentLevel "<tr>$script</tr>" ]
    }

    HtmlGenerator instproc table { script } {

        return [ my evalSubstCurrentLevel "<table>$script</table>" ]
    }

    HtmlGenerator instproc html { script } {

        return [ my evalSubstCurrentLevel "<html>$script</html>" ]
    }

    HtmlGenerator instproc link { href script } {

        return [ my evalSubstCurrentLevel "<a href=\"$href\">$script</a>" ]
    }

    HtmlGenerator instproc name { name } {

        return "<a name=\"$name\" />"
    }

    HtmlGenerator instproc h1 { script } {

        return [ my evalSubstCurrentLevel "<h1>$script</h1>" ]
    }
    HtmlGenerator instproc h2 { script } {

        return [ my evalSubstCurrentLevel "<h2>$script</h2>" ]
    }
    HtmlGenerator instproc h3 { script } {

        return [ my evalSubstCurrentLevel "<h3>$script</h3>" ]
    }

    HtmlGenerator instproc br { } {

        return "<br>"
    }

    HtmlGenerator instproc divClass { class script } {

        return [ my evalSubstCurrentLevel "<div class=\"$class\">$script</div>" ]
    }

    HtmlGenerator instproc divId { id script } {

        return [ my evalSubstCurrentLevel "<div id=\"$id\">$script</div>" ]
    }

    HtmlGenerator instproc hiddenBox { name value } {

        return "<input type=\"hidden\" name=\"$name\" value=\"$value\">" 
    }

    HtmlGenerator instproc hiddenBoxId { id value } {

        return "<input type=\"hidden\" id=\"$id\" value=\"$value\" />" 
    }

    HtmlGenerator instproc textBox { name value } {

        return  "<input type=\"text\" name=\"$name\" value=\"$value\" />"
    }

    HtmlGenerator instproc textBoxId { id value } {

        return  "<input type=\"text\" id=\"$id\" value=\"$value\" />"
    }

    HtmlGenerator instproc ol { script } {

        return [ my evalSubstCurrentLevel "<ol>$script</ol>" ]
    }

    HtmlGenerator instproc ul { script } {

        return "<ul>[ my evalSubstCurrentLevel $script ]</ul>"
    }

    HtmlGenerator instproc li { script } {

        return "<li>[ my evalSubstCurrentLevel $script ]</li>"
    }

    HtmlGenerator instproc javascript { script } {

        return [ my evalSubstCurrentLevel "<script language=\"Javascript\">$script</script>" ]
    }

    HtmlGenerator instproc webForm { app method submit script } {

        return [ my evalSubstCurrentLevel "
            <form action=\"$app\" method=\"post\" >
            [ ::xointerp::if2 { "" != "$method" } {
                ::xox::identity "<input type=\"hidden\" name=\"method\" value=\"$method\" />"
            } ]
            $script
            <input type=\"submit\" value=\"$submit\" />
            </form>
        " ]
    }

    HtmlGenerator instproc menu { args } {

        set return ""

        foreach { link name } $args {

            append return "<a href=\"$link\">\[ $name \]</a>\n"
        }

        return $return
    }

    HtmlGenerator instproc checkbox { name value script } {

        return [ my evalSubstCurrentLevel "
            <input type=\"checkbox\" name=\"$name\" value=\"$value\">
            $script
            </input>
        " ]
    }

    HtmlGenerator instproc inspectLink { object { text "" } } {

        if { "" == "$text" } {

            set text $object
        }

        my appLink inspect inspect "{object $object}" $text
    }

    HtmlGenerator instproc appLink { app method arguments content } {

        set formattedArgs ""

        foreach arg $arguments {

            append formattedArgs &
            append formattedArgs [ ::xox::first $arg ]
            append formattedArgs =
            append formattedArgs [ ::xox::second $arg ]
        }

        set formattedArgs [ my cleanUpLink $formattedArgs ]

        return "<a href=\"/${app}?method=${method}$formattedArgs\"> $content </a>"
    }

    HtmlGenerator instproc cleanUpLink { value } {
            #regsub -all {%} $value {%25} value
            #regsub -all " " $value {%20} value
            #regsub -all "!" $value {%21} value
            #regsub -all {"} $value {%22} value
            regsub -all {#} $value {%23} value
            #regsub -all "$" $value {%24} value
            #regsub -all {\&} $value {%26} value
            #regsub -all {\(} $value {%28} value
            #regsub -all {\)} $value {%29} value
            #regsub -all " " $value {\+} value
            #regsub -all {\{} $value {%7B} value
            #regsub -all {\}} $value {%7D} value
            #regsub -all {^} $value {%5E} value
            #regsub -all "," $value {%2C} value
            regsub -all {:} $value {%3A} value
            #regsub -all "@" $value {%40} value

            return $value
    }

    HtmlGenerator instproc withHeadHtml2 { title head body } {

        return [ my evalSubstCurrentLevel "
            <html><head><title>$title</title>
            <script language=\"Javascript\" src=\"prototype.js\"></script>
            <script language=\"Javascript\" src=\"xopro.js\"></script>
            <LINK REL =\"stylesheet\" TYPE=\"text/css\" HREF=\"/stylesheet.css\" TITLE=\"Style\">
            $head
            </head>
            <body>
            $body
            </body></html>
        " ]
    }

    HtmlGenerator instproc listLines { block } {

        set completeList ""

        set completeLine ""

        foreach line [ string trim [ split $block "\n" ] ] {

            if { "" == "$line" } continue 

            append completeLine "$line\n"

            if { ! [ info complete $completeLine ] } continue

            set completeLine [ string trim $completeLine ]

            if { "" == "$completeLine" } continue 

            append completeList "<li>"
            append completeList [ my evalSubstCurrentLevel $completeLine ]
            append completeList "</li>"

            set completeLine ""
        }

        return $completeList 
    }

}


