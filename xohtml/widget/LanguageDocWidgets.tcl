
::xohtml::widgets {

    @@doc LanguageDoc {

        Purpose: Documents an Xodsl language and all its commands.

        Parameter: {
            language The class that defines the Xodsl language.
            tags A set of tags to use to select tagged language commands. If no value is given all \
                methods are assumed to be commands.
        }
    }

    defineWidget LanguageDoc { language { tags "" } } {
    } {
        set languageName [ namespace tail $language ]
        div -class object {
            h1 -class name ' $languageName
            new MetaDoc -object $language -token $languageName 
            h2 ' Commands
            foreach class [ concat $language [ $language info heritage ] ] {
                if { "$class" == "::xotcl::Object" } { continue }
                foreach tag $tags {
                    foreach command [ $class getTagged $tag ] {
                        if [ $class hasTag $command hidden ] { continue }
                        set commands($command) $class 
                    }
                }
                if { "" == "$tags" } {
                    foreach command [ $class info instprocs ] {
                        if [ $class hasTag $command hidden ] { continue }
                        set commands($command) $class 
                    }
                }
            }
            foreach command [ lsort [ array names commands ] ] {
                    a -href "#$command" {
                        '' $command 
                    }
                    ' " , "
            }

            foreach command [ lsort [ array names commands ] ] {

              new MethodDoc -object [ set commands($command) ] -procName $command -doCode 0
              br 
              br
            }
        }
    }
}
