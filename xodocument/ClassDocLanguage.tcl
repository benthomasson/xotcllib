# Created at Wed Jan 23 08:13:24 EST 2008 by bthomass

namespace eval ::xodocument {

    ::xodsl::LanguageClass create ClassDocLanguage -superclass ::xodsl::Language

    ClassDocLanguage @doc ClassDocLanguage {

        ClassDocLanguage is a Domain Specific Language for documenting XOTcl classes.  ClassDocLanguage is accessible inside
        ClassName @@doc blocks.
    }

    ClassDocLanguage @example ClassDocLanguage {

        #ClassDocLanguage is accessible from the @@doc method on a class.
        #Syntax:
        ?Class Name? @@doc ?Class Name or Method name?
        {

        }

        #Start using the ClassDocLanguage from the @@doc method on Classes.

        Class XYZ

        XYZ @@doc XYZ {

            Purpose: To demonstrate ClassDocLanguage
        }
    }


    ClassDocLanguage parameter {
        docClass
        { method "" }
    }

    ClassDocLanguage @tag fixArgs hidden
    
    ClassDocLanguage instproc fixArgs { arguments } {

        if { [ llength $arguments ] == 1 } {

            return [ lindex $arguments 0 ]
        }

        return $arguments
    }

    ClassDocLanguage instproc Author: { args } {

        my instvar docClass method
        $docClass @author [ my fixArgs $args ]
    }

    ClassDocLanguage instproc Date: { args } {

        my instvar docClass method
        $docClass @date [ my fixArgs $args ]
    }

    ClassDocLanguage instproc Purpose: { args } {

        my instvar docClass method
        $docClass @doc $method [ my fixArgs $args ]
    }

    ClassDocLanguage instproc Arguments: { block } {

        my instvar docClass method

        set completeLine ""

        foreach line [ string trim [ split $block "\n" ] ] {

            if { "" == "$line" } continue 

            append completeLine "$line\n"

            if { ! [ info complete $completeLine ] } continue

            set completeLine [ string trim $completeLine ]

            if { "" == "$completeLine" } continue 

            set arg [ lindex $completeLine 0 ]
            set text [ my fixArgs [ lrange $completeLine 1 end ] ]

            $docClass @arg $method $arg $text

            set completeLine ""
        }
    }

    ClassDocLanguage instproc Args: { args } {

        my instvar docClass method

        $docClass @args $method [ my fixArgs $args ]
    }

    ClassDocLanguage instproc Parameter: { block } {

        my instvar docClass method

        if { "[ namespace tail $docClass ]" != "$method" } {

            error "Parameter not valid on token $method, please change to [ namespace tail $docClass ] for $docClass"
        }

        set completeLine ""

        foreach line [ string trim [ split $block "\n" ] ] {

            if { "" == "$line" } continue 

            append completeLine "$line\n"

            if { ! [ info complete $completeLine ] } continue

            set completeLine [ string trim $completeLine ]

            if { "" == "$completeLine" } continue 

            set parameter [ lindex $completeLine 0 ]
            set text [ my fixArgs [ lrange $completeLine 1 end ] ]

            $docClass @parameter $parameter $text

            set completeLine ""
        }
    }


    ClassDocLanguage instproc Returns: { block } {

        my instvar docClass method

        set completeLine ""

        foreach line [ string trim [ split $block "\n" ] ] {

            if { "" == "$line" } continue 

            append completeLine "$line\n"

            if { ! [ info complete $completeLine ] } continue

            set completeLine [ string trim $completeLine ]

            if { "" == "$completeLine" } continue 

            set text [ my fixArgs $completeLine ]

            $docClass @return $method $text

            set completeLine ""
        }
    }

    ClassDocLanguage instproc Example: { block } {

        my instvar docClass method
        $docClass @example $method $block
    }

    ClassDocLanguage instproc See: { link } {

        my instvar docClass method

        $docClass @see $method $link ]
    }

    ClassDocLanguage instproc Tags: { args } {

        my instvar docClass method
        foreach tag $args {
            $docClass @tag $method $tag
        }
    }

    ClassDocLanguage instproc Change: { date args } {

        my instvar docClass
        $docClass @changes $date [ my fixArgs $args ]
    }

    ClassDocLanguage @tag Command: hidden

    ClassDocLanguage instproc Command: { args } {

        my instvar docClass method
        $docClass @command $method [ my fixArgs $args ]
    }
}


