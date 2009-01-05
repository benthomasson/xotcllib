namespace eval ::server { 

Class create Application -superclass { ::xox::Node }
  
Application @doc Application {
Please describe Application here.
}
  
Application instmixin add ::server::UserAuthentication 
  
Application @doc title { }

Application @doc head { }

Application @doc web { }
   
Application parameter {
   { title "" }
   { head "" }
   {web}

} 
        

Application @doc ajaxLoad { 
ajaxLoad does ...
}

Application instproc ajaxLoad { -target -method -argIds } {  } {
        set jsArgIds ""

        foreach { arg id } $argIds {

            append jsArgIds "${arg}:'${id}',"
        }

        set jsArgIds "{[ string range $jsArgIds 0 end-1]}"

        my debug $jsArgIds

        uplevel "\$response puts {
<script language=\"Javascript\"> 
    ajaxLoad('$target','[my web]','$method',$jsArgIds);
</script>}"

    
}


Application @doc appLink { 
appLink does ...
            response - 
            app - 
            method - 
            arguments - 
            content -
}

Application instproc appLink { response app method arguments content } {

        set formattedArgs ""

        foreach arg $arguments {

            append formattedArgs &
            append formattedArgs [ ::xox::first $arg ]
            append formattedArgs =
            append formattedArgs [ ::xox::second $arg ]
        }

        set formattedArgs [ my cleanUpLink $formattedArgs ]

        my rputs  "<a href=\"/${app}?method=${method}$formattedArgs\">"
        my rputs $content
        my rputs {</a>}
}


Application @doc br { 
br does ...
            response - 
            times -
}

Application instproc br { response { times "1" } } {
        for { set i 0 } { $i < $times } { incr i } {

            my rputs {<br />}
        }
    
}


Application @doc cleanUpLink { 
cleanUpLink does ...
            value -
}

Application instproc cleanUpLink { value } {
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


Application @doc divClass { 
divClass does ...
            class - 
            text -
}

Application instproc divClass { class text } {
        uplevel "\$response puts {<div class=$class>$text</div>}"
    
}


Application @doc divID { 
divID does ...
            id - 
            text -
}

Application instproc divID { id text } {
        uplevel "\$response puts {<div id=$id>$text</div>}"
    
}


Application @doc execute { 
execute does ...
            method - 
            dashedArgs - 
            response - 
            otherArgs -
}

Application instproc execute { method dashedArgs response otherArgs } {
       eval "[ self ] $method $dashedArgs $response $otherArgs"
    
}


Application @doc h1 { 
h1 does ...
            text -
}

Application instproc h1 { text } {
        uplevel "\$response puts {<h1>$text</h1>}"
    
}


Application @doc h2 { 
h2 does ...
            text -
}

Application instproc h2 { text } {
        uplevel "\$response puts {<h2>$text</h2>}"
    
}


Application @doc h3 { 
h3 does ...
            text -
}

Application instproc h3 { text } {
        uplevel "\$response puts {<h3>$text</h3>}"
    
}


Application @doc hiddenBox { 
hiddenBox does ...
            name - 
            value -
}

Application instproc hiddenBox { name value } {
            uplevel "my rputs  {<input type=\"hidden\" name=\"$name\" value=\"$value\" />}
                    "
    
}


Application @doc hiddenBoxId { 
hiddenBoxId does ...
            id - 
            value -
}

Application instproc hiddenBoxId { id value } {
            uplevel "my rputs  {<input type=\"hidden\" id=\"$id\" value=\"$value\" />}
                    "
    
}


Application @doc initialLoad { 
initialLoad does ...
            response -
}

Application instproc initialLoad { response } {
        $response send200
    
}


Application @doc inspectLink { 
inspectLink does ...
            response - 
            object - 
            text -
}

Application instproc inspectLink { response object { text "" } } {
        if { "" == "$text" } {

            set text $object
        }

        my appLink $response inspect inspect  "{object $object}" $text
}


Application @doc menu { 
menu does ...
            response - 
            linkNamePairs -
}

Application instproc menu { response linkNamePairs } {
        foreach pair $linkNamePairs {

            set link [ ::xox::first $pair ]
            set name [ ::xox::second $pair ]

            #my debug "pair: $pair link: $link name: $name"

            my rputs "<a href=\"$link\">\[ $name \]</a>"
        }
}


Application @doc rputs { 
rputs does ...
            text -
}

Application instproc rputs { text } {
        uplevel "\$response puts {$text}"
    
}


Application @doc sendMessages { 
sendMessages does ...
}

Application instproc sendMessages {  } {
    
}


Application @doc textBox { 
textBox does ...
            response - 
            name - 
            value -
}

Application instproc textBox { response name value } {
            my rputs  "<input type=\"text\" name=\"$name\" value=\"$value\" />"
    
}


Application @doc textBoxId { 
textBoxId does ...
            response - 
            id - 
            value -
}

Application instproc textBoxId { response id value } {
            my rputs  "<input type=\"text\" id=\"$id\" value=\"$value\" />"
    
}


Application @doc uniqueId { 
uniqueId does ...
            var -
}

Application instproc uniqueId { var } {
        uplevel "set $var [ my autoname $var ]"
    
}


Application @doc with { 
with does ...
            type - 
            script -
}

Application instproc with { type script } {
        uplevel "\$response puts {<$type>}"
        uplevel $script
        uplevel "\$response puts {</$type>}"
    
}


Application @doc withAjaxForm { 
withAjaxForm does ...
            script -
}

Application instproc withAjaxForm { -target -method -argIds -submit } { script } {
        set jsArgIds ""

        foreach { arg id } $argIds {

            append jsArgIds "${arg}:${id},"
        }

        set jsArgIds "{[ string range $jsArgIds 0 end-1]}"

        #my debug $jsArgIds

        uplevel "\$response puts  {<form action=\"javascript:ajaxUpdate('$target','[my web]','$method',$jsArgIds)\" method=\"post\" >}"

        uplevel "$script"

        uplevel "\$response puts  {<input type=\"submit\" value=\"$submit\"/>}"

        uplevel "\$response puts {</form>}"
    
}


Application @doc withAjaxScript { 
withAjaxScript does ...
            out - 
            script -
}

Application instproc withAjaxScript { out script } {
        uplevel "
        \$$out contentType text/javascript
        $script
        \$$out send200
        "
    
}


Application @doc withCheckbox { 
withCheckbox does ...
            out - 
            name - 
            value - 
            script -
}

Application instproc withCheckbox { out name value script } {
        uplevel "
            \$$out puts  {<input type=\"checkbox\" name=\"$name\" value=\"$value\" >}
            $script 
            \$$out puts {</input>}
            "
    
}


Application @doc withDivId { 
withDivId does ...
            out - 
            id - 
            script -
}

Application instproc withDivId { out id script } {
        uplevel "
            \$$out puts {<div id=$id>}
            $script
            \$$out puts {</div>}
            "
    
}


Application @doc withHeadHtml { 
withHeadHtml does ...
            head - 
            body -
}

Application instproc withHeadHtml { head body } {
        my instvar title

        uplevel "
        
        \$response puts {<html><head><title>$title</title>}
        \$response puts {<script language=\"Javascript\" src=\"prototype.js\"></script>}
        \$response puts {<script language=\"Javascript\" src=\"xopro.js\"></script>}
        \$response puts {<LINK REL =\"stylesheet\" TYPE=\"text/css\" HREF=\"/stylesheet.css\" TITLE=\"Style\">}
        
        $head
        
        \$response puts {</head>}
        \$response puts {<body>}

        $body

        \$response puts {</body></html>}
        \$response send200
        "
    
}


Application @doc withHtml { 
withHtml does ...
            out - 
            script -
}

Application instproc withHtml { out script } {
        my instvar title head

        uplevel "
        
        \$$out puts {<html><head><title>$title</title>}
        \$$out puts {<script language=\"Javascript\" src=\"prototype.js\"></script>}
        \$$out puts {<script language=\"Javascript\" src=\"xopro.js\"></script>}
        \$$out puts {<LINK REL =\"stylesheet\" TYPE=\"text/css\" HREF=\"/stylesheet.css\" TITLE=\"Style\">}
        \$$out puts {$head</head>}
        \$$out puts {<body>}

        $script

        \$$out puts {</body></html>}
        \$$out send200
        "
    
}


Application @doc withMyWebForm { 
withMyWebForm does ...
            out - 
            method - 
            submits - 
            script -
}

Application instproc withMyWebForm { out method submits script } {
        uplevel "\$$out puts  {<form action=\"[ my web ]\" method=\"post\" >}"

        if { "" != "$method" } {
            uplevel "\$$out puts  {<input type=\"hidden\" name=\"method\" value=\"$method\" />}"

        }

        uplevel "$script"

        foreach submit $submits {

            if { [ llength $submit ] == 2 } {

            uplevel "\$$out puts  {<input type=\"submit\" name=\"[ lindex $submit 0 ]\" value=\"[lindex $submit 1]\" />}"
            } else {

            uplevel "\$$out puts  {<input type=\"submit\" value=\"$submit\" />}"

            }
        } 

        uplevel "\$$out puts {</form>}"

    
}


Application @doc withOL { 
withOL does ...
            out - 
            script -
}

Application instproc withOL { out script } {
        uplevel "
            \$$out puts {<ol>}
            $script
            \$$out puts {</ol>}
            "
    
}


Application @doc withOLList { 
withOLList does ...
            out - 
            args -
}

Application instproc withOLList { out args } {
        uplevel "\$$out puts {<ol>}"

        foreach script $args {

            uplevel "\$$out puts {<li>}"
            uplevel "$script"
            uplevel "\$$out puts {</li>}"
        }

        uplevel "\$$out puts {</ol>}"
    
}


Application @doc withScript { 
withScript does ...
            out - 
            script -
}

Application instproc withScript { out script } {
        uplevel "
            \$$out puts  {<script language=\"Javascript\">}
            $script
            \$$out puts {</script>}
            "
    
}


Application @doc withUL { 
withUL does ...
            out - 
            script -
}

Application instproc withUL { out script } {
        uplevel "
            \$$out puts {<ul>}
            $script
            \$$out puts {</ul>}
            "
    
}


Application @doc withULList { 
withULList does ...
            out - 
            args -
}

Application instproc withULList { out args } {
        uplevel "\$$out puts {<ul>}"

        foreach script $args {

            uplevel "\$$out puts {<li>}"
            uplevel "$script"
            uplevel "\$$out puts {</li>}"
        }

        uplevel "\$$out puts {</ul>}"
}


Application @doc withWebForm { 
withWebForm does ...
            out - 
            app - 
            method - 
            submit - 
            script -
}

Application instproc withWebForm { out app method submit script } {
        uplevel "\$$out puts  {<form action=\"/$app\" method=\"post\" >}"

        if { "" != "$method" } {
            uplevel "\$$out puts  {<input type=\"hidden\" name=\"method\" value=\"$method\" />}"
        }

        uplevel "$script"

        uplevel "\$$out puts  {<input type=\"submit\" value=\"$submit\" />}"

        uplevel "\$$out puts {</form>}"
    
}


Application @doc workingDirectory { 
workingDirectory does ...
}

Application instproc workingDirectory {  } {
        return [ ::server packagePath ]
    
}
}


