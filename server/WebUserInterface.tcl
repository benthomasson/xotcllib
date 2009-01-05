
namespace eval ::server { 

Class create WebUserInterface -superclass { ::server::UserInterface }
  
WebUserInterface @doc WebUserInterface {
Please describe WebUserInterface here.
}
  
WebUserInterface instmixin add ::server::mixin::MessagePublisher 
  
WebUserInterface @doc id { }

WebUserInterface @doc application { }
   
WebUserInterface parameter {
   {id}
   {application}

} 
        

WebUserInterface @doc checkInput { 
checkInput does ...
}

WebUserInterface instproc checkInput {  } {
        my . application . sendMessages
    
}


WebUserInterface @doc close { 
close does ...
}

WebUserInterface instproc close {  } {
        catch {

            [ my application ] removeMessageListener [ self ]
            [ CharacterManager getInstance ] addCharacter [ my application ] 

        }
        [ WebUIFactory getInstance ] removeSession [ my id ]
        my destroy
    
}


WebUserInterface @doc getApplication { 
getApplication does ...
            web -
}

WebUserInterface instproc getApplication { web } {
        my debug $web

        set applicationName  [ [ ApplicationWebMap getInstance ] application $web ]
        package require [ ::xox::Package getMainPackage $applicationName ]
        if {  ![ my exists "applications($applicationName $web)" ] } {

            my set "applications($applicationName $web)" [ $applicationName new -web $web ]
        }

        return [ my set "applications($applicationName $web)" ]
}


WebUserInterface @doc init { 
init does ...
}

WebUserInterface instproc init {  } {
        puts "new WebUserInterface"
        next --noArgs
        my application ""
    
}


WebUserInterface @doc processRequest { 
processRequest does ...
            request - 
            response -
}

WebUserInterface instproc processRequest { request response } {
        $response ui [ self ]

        set url [ lindex [ $request set action ] 1 ]
        puts "url:$url"
        set web [ lindex [ split $url ? ] 0 ]
        puts "web:$web"

        my application [ my getApplication $web ]

        set application [ my application ]

        cd [ $application workingDirectory ]

        set method [ Object new ]

        $method set args ""
        $method set method ""

        if { [ string first POST [ $request set action ] ] == 0 } {

        puts "POST"

        puts "body:[ $request set body]"

        foreach nameEqualsValue [ split [ $request set body ] "&" ] {

            puts "nameEqualsValue $nameEqualsValue"
            set nameValue [ split [ string trim $nameEqualsValue ] "=" ]
            puts "nameValue $nameValue"
            set name [ string trim [ lindex $nameValue 0 ] ]
            if { "" == "$name" } { continue }
            set value [ string trim [ lrange $nameValue 1 end ] ]

            set value [ my translateValue $value ]

            puts "name $name"
            puts "value $value"

            $method lappend $name $value
        }

        }

        if { [ string first GET [ $request set action ] ] == 0 } {

            set query [ lindex [ split [ $request set action ] ] 1 ]
            
            set nameEqualsValues [ split [ lindex [ split $query ? ] 1 ] & ]
            foreach nameEqualsValue $nameEqualsValues "&" ] {

                set nameValue [ split $nameEqualsValue "=" ]
                set name [ string trim [ lindex $nameValue 0 ] ]
                if { "" == "$name" } { continue }
                set value [ string trim [ lrange $nameValue 1 end ] ]

                set value [ my translateValue $value ]
                $method lappend $name $value
            }
        }

        set methodName [ string trim [ lindex [ $method set method ] 0 ] ]
        set args [ string trim [ lindex [ $method set args ] 0 ] ]

        puts "Method vars: [ $method info vars ]"

        set dashedArgs ""

        foreach var [ $method info vars ] {

            if { "args" == "$var" } { continue }
            if { "method" == "$var" } { continue }

            lappend dashedArgs "-$var"
            lappend dashedArgs [ $method set $var ]
        }

        puts "Dashed: $dashedArgs"

        #puts "Method: $methodName"
        #puts "args: $args"
        #puts "full: my $methodName $args"

        puts "MethodName: $methodName"

        if { "" == "$methodName" } { 

            set methodName initialLoad
        }

        $response request $request

        if [ catch {

            $application execute $methodName $dashedArgs $response $args

        } result ] {

            global errorInfo

            $response puts "<pre>$errorInfo</pre>"
            $response send404
        }

        $response destroy
        $request destroy
        $method destroy
    
}


WebUserInterface @doc translateValue { 
translateValue does ...
            value -
}

WebUserInterface instproc translateValue { value } {
        regsub -all {%20} $value " " value
        regsub -all {%21} $value "!" value
        regsub -all {%22} $value {"} value
        regsub -all {%23} $value "#" value
        regsub -all {%24} $value "$" value
        regsub -all {%25} $value {%} value
        regsub -all {%26} $value {\&} value
        regsub -all {%28} $value {(} value
        regsub -all {%29} $value {)} value
        regsub -all {%2F} $value {/} value
        regsub -all {%3C} $value {<} value
        regsub -all {%3E} $value {>} value
        regsub -all {\+} $value " " value
        regsub -all {%7B} $value "\{" value
        regsub -all {%7D} $value "\}" value
        regsub -all {%5B} $value "\[" value
        regsub -all {%5C} $value "\\" value
        regsub -all {%5D} $value "\]" value
        regsub -all {%5E} $value {^} value
        regsub -all {%2C} $value "," value
        regsub -all {%3A} $value ":" value
        regsub -all {%3D} $value "=" value
        regsub -all {%40} $value "@" value
        regsub -all {%0D%0A} $value "\n" value

        return $value
    
}
}


