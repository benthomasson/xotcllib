# Created at Tue Jan 29 04:01:43 PM EST 2008 by bthomass

namespace eval ::xodocument {

    Class SimpleDoc -superclass ::xotcl::Object

    SimpleDoc # SimpleDoc {

        Please describe the class SimpleDoc here.
    }

    SimpleDoc parameter {

    }

    SimpleDoc @command init simpleDoc

    SimpleDoc instproc init { args } {

       #Please add some implementation here.

        if [ catch {

            set file [ lindex $args 0 ]
            set xmlFile "${file}.xml"


            set easyDoc [ ::xodocument::SimpleDocLanguage newLanguage ]
            set environment [ $easyDoc set environment ]
            ::xox::ParseArgs configureObject $environment $::argv
            set xml [ $easyDoc evaluateDoc [ ::xox::readFile [ lindex $args 0 ] ] ]
            ::xox::writeFile $xmlFile $xml
            puts "Wrote $xmlFile"

            set doc [ dom parse $xml ]
            set root [ $doc documentElement ]

            if { [ llength $args ] == 1 } {

                set xsls [ list [ file join [ ::xodocument packagePath ] simpledoc.xsl ] html ]

            } else {

                set xsls [ lrange $args 1 end ]
            }

            set file [ lindex $args 0 ]

            foreach { xsl suffix } $xsls {

                set xslFile ${file}.${suffix}

                set text [ [ $root xslt [ dom parse [ ::xox::readFile $xsl ] ] ] asXML ]
                ::xox::writeFile $xslFile $text
                puts "Wrote $xslFile"
            }

        } error ] {

            puts "simpleDoc error: [ ::xoexception::Throwable extractMessage $error ]"
        }
    }

    SimpleDoc instproc unknown {  args } {

    }

}


