

namespace eval xounit {

    Class create TestResultsWebFormatter \
        -superclass ::xounit::TestResultsTextFormatter

    TestResultsWebFormatter # TestResultsWebFormatter {

        Format test results for display on a web page.
    }

    TestResultsWebFormatter # styleSheet { CSS stylesheet to use in html file }
    TestResultsWebFormatter # location { location to write html file to }
    TestResultsWebFormatter # webPath { url where html file will be served }
    TestResultsWebFormatter # title { title to use in html file  }
    TestResultsWebFormatter # url { url to more project information }
    TestResultsWebFormatter # textFormatter { text formatter to use }
    TestResultsWebFormatter # apiDoc { url to API documentation }

    TestResultsWebFormatter parameter {
        { styleSheet style.css }
        location
        webPath
        title
        url
        textFormatter
        { apiDoc http://xotcllib.sourceforge.net/xodoc/ }
    }

    TestResultsWebFormatter # init { 

        Initalizes the TestResultsWebFormatter with a new textFormatter.
    }     

    TestResultsWebFormatter instproc init { } {

        my textFormatter [ ::xounit::TestResultsTextFormatter new ]
    }

    TestResultsWebFormatter # organizeResults { 

        Comparison method that will compare two test results to organize
        them by TestResult name.
    }

    TestResultsWebFormatter instproc organizeResults { resultOne resultTwo } {

        set nameOne [ $resultOne name ]
        set nameTwo [ $resultTwo name ]

        return [ string compare $nameOne $nameTwo ]
    }

    TestResultsWebFormatter instproc formatResults { results } {

        my instvar styleSheet


        set text [ my formatWebResults $results ]


        append buffer "<html><head>"
        append buffer "<LINK REL=StyleSheet HREF=\"$styleSheet\" TYPE=\"text/css\" />\n"
        append buffer "</head><body>\n"
        append buffer "<a href=\"index.html\">\[ Index \]</a><br/>\n"
        append buffer "$text\n"
        append buffer "</body></html>\n"
        
        return $buffer
    }

    TestResultsWebFormatter instproc testSummary { results } {

        set buffer ""

        append buffer "<div class=\"summary\">"
        append buffer "<h1>Test Summary</h1><a name=\"summary\" />"
        append buffer "<table class=\"SummaryTable\"><tbody>"
        append buffer "<tr><td class=\"SummaryTableHeader\">Timestamp</td>"
        append buffer "<td class=\"SummaryTableHeader\">Tests</td>"
        append buffer "<td class=\"SummaryTableHeader\">Failures</td>"
        append buffer "<td class=\"SummaryTableHeader\">Passes</td>"
        append buffer "<td class=\"SummaryTableHeader\">Graph</td>"
        append buffer "</tr><tr>"
        append buffer "<td class=\"SummaryTable\"><span class=\"time\">[ clock format  [ clock seconds ]  -format "%b %d %H:%M:%S" ]</span></td>"
        append buffer "<td class=\"SummaryTable\">[ my numberOfTests $results ]</td>"
        set failures [ expr { [ my numberOfErrors $results ] + [ my numberOfFailures $results ] } ]
        append buffer "<td class=\"SummaryTable\">$failures</td>"
        append buffer "<td class=\"SummaryTable\">[ my numberOfPasses $results ]</td>"
        append buffer "<td class=\"SummaryTable\">"
        append buffer [ my barGraph [ my numberOfPasses $results ] [ my numberOfTests $results ]  ]
        append buffer "</td></tr></tbody></table>"

        set index 0

        append buffer "<h1>Failures</h1><a name=\"failures\" />"
        append buffer "<tr>"
        append buffer "<table class=\"SummaryTable\"><tbody>"
        append buffer "<td class=\"SummaryTableHeader\">Test Name</td>"
        append buffer "<td class=\"SummaryTableHeader\">Failure</td>"
        foreach result $results {
        foreach failure [ concat [ $result errors ] [ $result failures ] ] {
            
            append buffer "</tr><tr>"
            append buffer "<td class=\"SummaryTable\"><a href=\"#[ my cleanUpLink $failure ]\">[ $failure name ]</a></td>"
            append buffer "<td class=\"SummaryTable\"><a href=\"#[ my cleanUpLink $failure ]\">[ $failure test ]</a></td>"
            incr index
        }
        }
        append buffer "</td></tr></tbody></table>"

        append buffer "</div>"

        return $buffer
    }

    TestResultsWebFormatter # barGraph {

        Creates the html code for a bar graph that measures
        the number of passes out of a total number of tests.
    }


    TestResultsWebFormatter instproc barGraph { passed total } {

        if { $total == 0 } {

            set passWidth 0
            set failWidth 200
            set failed 0 
            set passed 0

        } else {

            set failed [ expr { $total - $passed } ]
            set passWidth [ expr { int( 200 * $passed / $total ) } ]
            set failWidth [ expr { int( 200 * $failed / $total ) } ]
        }

        if { $passed == $total && $total > 0 } {

        append buffer "
<TABLE class=barGraph cellspacing=0>
<TBODY>
<TR>
<TD class=covered><img src=\"spacer.gif\"
width=\"$passWidth\" height=\"12\"></TD>
</TR>
</TBODY>
</TABLE>"

        } elseif { $passed == 0 } {

        append buffer "
<TABLE class=barGraph cellspacing=0>
<TBODY>
<TR>
<TD class=uncovered><img src=\"spacer.gif\"
width=\"$failWidth\" height=\"12\"></TD>
</TR>
</TBODY>
</TABLE>"

        } else {

        append buffer "
<TABLE class=barGraph cellspacing=0>
<TBODY>
<TR>
<TD class=covered><img src=\"spacer.gif\"
width=\"$passWidth\" height=\"12\"></TD>
<TD class=uncovered><img src=\"spacer.gif\"
width=\"$failWidth\" height=\"12\"></TD>
</TR>
</TBODY>
</TABLE>"

        }

        return $buffer

    }

    TestResultsWebFormatter # formatWebResults {

        Format a list of results for display on a web page.
    }

    TestResultsWebFormatter instproc formatWebResults { results } {

        set results [ lsort -command "[ self ] organizeResults" $results ]

        foreach result $results {

            puts "[ $result name ]"
        }

        set buffer ""

        append buffer [ my testSummary $results ]

        foreach result $results {

            if [ $result passed ] { continue }
            append buffer [ my printResult $result ]
        }

        append buffer "<h1>Passes</h1>"
        append buffer "<a href=\"#summary\">\[Summary\]</a> <br />"
        append buffer "
<table class=\"FailureTable\"><tbody>
<tr>
<td class=\"FailureTableHeader\" >Test</td>
<td class=\"FailureTableHeader\" >Message</td>
</tr>"
        foreach result $results {

            append buffer [ my printPasses $result ]
        }
        append buffer "</tbody><table>"

        return $buffer
    }

    TestResultsWebFormatter # passed { 

        Returns true if all results passed.
    }

    TestResultsWebFormatter instproc passed { results } {

        foreach result $results {

            if { ! [ $result passed ] } { return 0 }
        }

        return 1
    }

    TestResultsWebFormatter instproc printResult { aResult } {

        set buffer ""

        append buffer "<a href=\"#summary\">\[Summary\]</a> <br />"

        append buffer "
<table class=\"FailureTable\"><tbody>
<tr>
<td class=\"FailureTableHeader\" >Failure</td>
<td class=\"FailureTableHeader\" >Message</td>
</tr>"

        foreach error [ $aResult errors ] {
            
            append buffer [ my printError $aResult $error ]
        }

        foreach failure [ $aResult failures ] {

            append buffer [ my printFailure $aResult $failure ]
        }

        #foreach subResult [ $aResult results ] {

        #    if [ $subResult hasclass ::xounit::TestPass ] { continue }
        #    if [ $subResult hasclass ::xounit::TestFail ] { continue }
        #    if [ $subResult hasclass ::xounit::TestError ] { continue }
        #    if [ $subResult passed ] { continue }

        #    append buffer [ my printSubResult $aResult $subResult ]
        #}

        append buffer "</tbody><table>"

        return $buffer
    }

    TestResultsWebFormatter # printPasses { 

        Formats all passing sub-results in a TestResult.
    }

    TestResultsWebFormatter instproc printPasses { aResult } {

        set buffer ""

        foreach pass [ $aResult passes ] {

            append buffer [ my printPass $aResult $pass ]
        }

        return $buffer
    }

    TestResultsWebFormatter instproc printPass { result aPass } {

        set return "<tr>
<td class=\"PassTable\">[ my makeClassLink $aPass ] [ my makeClassMethodLink $aPass ] </td>
<td class=\"PassTable\">
<pre> [ my cleanUpData [$aPass message] ]</pre>
</td></tr>"

        return $return
    }

    TestResultsWebFormatter # cleanUpData { 

        Cleans up data for presentation in html
    }

    TestResultsWebFormatter instproc cleanUpData { data } {

        regsub -all {\&} "$data" {\&amp;} data
        regsub -all < "$data" {\&lt;} data
        regsub -all > "$data" {\&gt;} data

        return $data
    }


    TestResultsWebFormatter instproc printSubResult { result subResult } {

        my instvar textFormatter

        set return "<tr>
<td class=\"FailureTable\">[ $result name ] [ $subResult name ] </td>
<td class=\"FailureTable\">
<a name=\"[ my cleanUpLink $subResult ]\"/>
<pre>[ $textFormatter printSubResult $subResult ]</pre>
</td></tr>"

        return $return
    }

    TestResultsWebFormatter instproc printFailure { result aFailure } {


        set return "<tr>
<td class=\"FailureTable\">[ my makeClassLink $aFailure ] [ my makeClassMethodLink $aFailure ] </td>
<td class=\"FailureTable\">
<a name=\"[ my cleanUpLink $aFailure ]\"/>
<pre>[ my cleanUpData [$aFailure error] ]</pre>
</td></tr>"

        return $return
    }

    TestResultsWebFormatter instproc printError { result anError } {


        set return "<tr>
<td class=\"ErrorTable\">
<a name=\"[ my cleanUpLink $anError ]\"/>
[ my makeClassLink $anError ] [ my makeClassMethodLink $anError ]
</td>
<td class=\"ErrorTable\">Error stacktrace below</td>
<tr><td class=\"ErrorTable\" colspan=\"2\">
<pre>[ my formatClassMethodsInError [ $anError error] ]</pre>
</td></tr>"

        return $return
    }

    TestResultsWebFormatter # formatClassMethodsInError { 

        Parse the Tcl/XOTcl stack trace and find instances
        of XOTcl method calls and add a link to the Class/Method
        in stack trace.
    }

    TestResultsWebFormatter instproc formatClassMethodsInError { error } {

        set newError ""

        foreach line [ split $error "\n" ] {

            if { [ string first "->" $line ] != -1 } {

                append newError [ my formatObjectClassMethodLine $line ]

            } else {
            append newError [ my cleanUpData $line ]
            append newError "\n"
            }
        }

        return $newError
    }

    TestResultsWebFormatter # formatObjectClassMethodLine { 

        In a stack trace line find a class and method and create
        a link to the API documentation from that class and method.
    }

    TestResultsWebFormatter instproc formatObjectClassMethodLine { line } {

        my instvar apiDoc

        if { ! [ my exists apiDoc ] } { return $line }

        set newError $line

        catch {


        set object [ lindex $line 0 ]
        set classMethod [ lindex $line 1 ]

        set class [ lindex [ split $classMethod "->" ] 0 ]
        set method [ lindex [ split $classMethod "->" ] 2 ]

        if { ! [ Object isclass $class ] } { return $line }

        set cleanClass [ my cleanUpLink $class ]

        set index [ string first $class $line ]
        incr index -1
        set newError ""

        append newError [ string range $line 0 $index ]
        append newError "<a href=\"$apiDoc$cleanClass.html#$method\">[ my cleanUpData $classMethod ] </a>"
        append newError "\n"

        }

        return $newError
    }

    TestResultsWebFormatter # rssItem {

        Create an RSS item that describes how many tests failed
        in this test report.
    }

    TestResultsWebFormatter instproc rssItem { results link } {

        set failures [ expr { [ my numberOfErrors $results ] + [ my numberOfFailures $results ] } ]
        set tests [ my numberOfTests $results ]

        set summary "[ clock format [ clock seconds ] -format "%b %d %H:%M:%S" ] Tests fail: $failures/$tests"
        
return "
<item>
<title>$summary</title>
<description>$summary</description>
<link>$link</link>
</item>"

    }

    TestResultsWebFormatter # writeWebResults {

        Write the formatted TestResults to location and update
        the RSS feed and the html index.html. If the number
        of old test runs is greater than 100 then delete the
        oldest ones over 100.
    }

    TestResultsWebFormatter instproc writeWebResults { results } {

        my instvar location webPath title url

        global env

        if { ! [ file exists $location ] } {
            file mkdir $location
        }

        set xounit [ ::xounit packagePath ]

        if { ! [ file exists [ file join $location rss.gif ] ] } {
            file copy $xounit/test/rss.gif $location
        }

        if { ! [ file exists [ file join $location spacer.gif ] ] } {
            file copy $xounit/test/spacer.gif $location
        }

        file copy -force $xounit/test/style.css $location

        set resultsName "results[ clock seconds ].html"
        set rssName "rss[ clock seconds ].xml"

        set file [ open [ file join $location $resultsName ] w ] 
        puts $file [ [ ::xounit::TestResultsWriter new ] writeWebResults $results ]
        flush $file
        close $file
        puts "Wrote [ file join $location $resultsName ]"

        set file [ open [ file join $location $rssName ] w ] 
        puts $file [ my rssItem $results "$webPath/$resultsName" ]
        flush $file
        close $file
        puts "Wrote [ file join $location $rssName ]"


        set feed [ open [ file join $location feed.xml ] w ]

            puts $feed \
            "<rss version=\"2.0\">

            <channel>

            <title>$title</title>
            <description>Tests</description>
            <link>$url</link>

            "

            set rssFiles [ lsort -decreasing [ glob -nocomplain -directory $location rss*.xml ] ]

            foreach rssFile [ lrange $rssFiles 0 5 ] {

            puts $feed [ ::xox::readFile [ file join $location $rssFile ] ]
            }

            puts $feed \
            "
            </channel>

            </rss>

            "
        flush $feed
        close $feed
        puts "Wrote [ file join $location feed.xml ]"

        set index [ open [ file join $location index.html ] w ]

            puts $index "<html><body><a href=\"$url\"><h1>$title</h1></a>"

            set resultsFiles [ lsort -decreasing [ glob -nocomplain -directory $location results*.html ] ]

            puts $index {
            100 Most Recent Test Runs:<br />
            }

            foreach resultsFile [ lrange $resultsFiles 100 end ] {

                set webFile [ file tail $resultsFile ]
                set path [ file dirname $resultsFile ]
                regexp {results(\d+)} $webFile dummy time
                set rssFileName [ file join $path "rss$time.xml" ]


                puts "deleting old results $resultsFile"
                file delete $resultsFile
                puts "deleting old results $rssFileName"
                file delete $rssFileName
            }

            foreach resultsFile [ lrange $resultsFiles 0 100 ] {

               if [ catch {

                    set webFile [ file tail $resultsFile ]

                    regexp {results(\d+)} $webFile dummy time

                    set rssFileName "rss$time.xml"

                    if [ file exists [ file join $location $rssFileName ] ] {

                        set rssDom [ [ dom parse [ ::xox::readFile [ file join $location $rssFileName ] ] ] documentElement ]
                        set failures [ [ $rssDom getElementsByTagName description ] text ]
                        puts $index "<a href=\"$webFile\" > $failures </a><br/>"
                    }

                } writeError ] {
                    puts "Write Error: $writeError\n$::errorInfo"
                }
            }

            puts $index \
            {<link rel="alternate" type="application/rss+xml"
             title="Test Results Feed"
             href="feed.xml">}

            puts $index {
            <a href="feed.xml" alt="help!" ><img src="rss.gif" /></a>
            }

            puts $index "</body></html>"

        flush $index
        close $index
        puts "Wrote [ file join $location index.html ]"
    }


    TestResultsWebFormatter # cleanUpLink { 

        Cleans up a string for use as an html link.
    }

   TestResultsWebFormatter instproc cleanUpLink { link } {

        regsub -all {::} "$link" {_} link
        regsub -all {#} "$link" {_} link

        return $link
   }

   TestResultsWebFormatter # makeClassLink { 

       Make an html link from the testedClass in a TestResult.
   }

   TestResultsWebFormatter instproc makeClassLink { result } {

       my instvar apiDoc

       set class [ $result testedClass ]

       if { ! [ my exists apiDoc ] || ( "$class" == "" ) } {

           return [ $result name ]
       }

       set cleanClass [ my cleanUpLink $class ]
       return "<a href=\"$apiDoc$cleanClass.html\">[ $result name ]</a>"
   }

   TestResultsWebFormatter # makeClassMethodLink { 

       Make an html linke from the testedClass and testedMethod in
       a TestResult.
   }

   TestResultsWebFormatter instproc makeClassMethodLink { result } {

       my instvar apiDoc

       set class [ $result testedClass ]
       set method [ $result testedMethod ]

       if { ! [ my exists apiDoc ] || ( "$class" == "" ) || ( "$method" == "" ) } {

           return [ $result test ]
       }

       set cleanClass [ my cleanUpLink $class ]
       return "<a href=\"$apiDoc$cleanClass.html#$method\">[ $result test ]</a>"
   }
}

