# Created at Sat Aug 09 14:11:56 EDT 2008 by bthomass

namespace eval ::xounit {

    Class TestResultsWriter -superclass ::xotcl::Object

    TestResultsWriter @doc TestResultsWriter {

        Please describe the class TestResultsWriter here.
    }

    TestResultsWriter parameter {
        { green "\x1B\[32;1m" }
        { red "\x1B\[31;1m" }
        { magenta "\x1B\[35;1m" }
        { clear "\x1B\[0m" }
    }

    TestResultsWriter instproc nocolor { } {

        my green ""
        my red ""
        my magenta ""
        my clear ""
    }

    TestResultsWriter instproc countTests { results }  {

        my instvar numberOfTests numberOfFailures numberOfErrors numberOfPasses passed

        set numberOfTests 0
        foreach result $results {
            incr numberOfTests [ $result numberOfTests ]
        }

        set numberOfFailures 0
        foreach result $results {
            incr numberOfFailures [ $result numberOfFailures ]
        }

        set numberOfErrors 0
        foreach result $results {
            incr numberOfErrors [ $result numberOfErrors ]
        }

        set numberOfPasses 0
        foreach result $results {
            incr numberOfPasses [ $result numberOfPasses ]
        }
        set passed 1
        foreach result $results {
            if { ! [ $result passed ] } { set passed 0 }
        }
    }

    TestResultsWriter instproc writeTextResults { results } {

        my instvar green red clear magenta numberOfTests numberOfFailures numberOfErrors numberOfPasses passed

        package require xodsl

        my countTests $results

return [ ::xodsl::buildString { 
    foreach result $results {
        ' "${magenta}[ $result name ]${clear}\n"
         if { "" == "[ $result results ]" } {
             ' "${red} No tests${clear}\n"
        } else {
             foreach childResult [ $result results ] {
                 if [ $childResult passed ] {
                     ' "${green}Pass: [ $result name ] [$childResult test] [$childResult return ]${clear}\n" 
                 } else {
                     ' "${red} Failure: [ $result name ] [ $childResult test ]\n[ $childResult error ] ${clear}\n"
                 } 
             }
        }
    }
' "================================================================================\n"
if $passed { ' $green} else { ' $red}
' "Tests: $numberOfTests
Errors: $numberOfErrors
Failures: $numberOfFailures
Passes: $numberOfPasses
$clear"
} ]

    }

    TestResultsWriter instproc writeEmailResults { results } {

        my instvar numberOfTests numberOfFailures numberOfErrors numberOfPasses passed

        package require xodsl

        my countTests $results

return [ ::xodsl::buildString { 
    ' "Tests: $numberOfTests
Errors: $numberOfErrors
Failures: $numberOfFailures
Passes: $numberOfPasses
================================================================================\n"
    foreach result $results {

        if { "" == "[ $result results ]" } { 
           ' "[ $result name ]\nNo tests\n" 
        } elseif [ $result passed ] {
            ' "[ $result name ]\nAll tests pass: [ $result numberOfTests ]\n"
        } else {
' "[ $result name ]\nTests: [ $result numberOfTests ] Errors: [ $result numberOfErrors ] Failures: [ $result numberOfFailures ] Passes: [ $result numberOfPasses ]\n\n"

            foreach childResult [ $result results ] {
                if [ $childResult passed ] {
                    ' "Pass: [ $result name ] [$childResult test] [$childResult return ]\n"
                } else {
                    ' "Failure: [ $result name ] [ $childResult test ]\n[ $childResult error ]\n"
                } 
            }
        }
    }

} ]

    }

    TestResultsWriter instproc writeWebResults { results } {

        my instvar numberOfTests numberOfFailures numberOfErrors numberOfPasses passed

        package require xohtml

        my countTests $results

        set env [ Object new ]
        $env set numberOfPasses $numberOfPasses
        $env set numberOfErrors $numberOfErrors
        $env set numberOfFailures $numberOfFailures
        $env set numberOfTests $numberOfTests
        $env set results $results

        $env set summaryClass failure
        if $passed {
            $env set summaryClass pass
        }

        return [ ::xohtml::build $env {
            html { 
                head { 
                  title ' "Test Results"
                  style -type "text/css" ' {

                    body {
                        font-family: Helvetica,Arial,Sans-Serif;
                    }

                    table {
                        margin: 0 0 1em;
                        background: #FFF;
                        border-collapse: collapse;
                    }

                    th, td {
                            font-weight: normal;
                            padding: .3em .7em;
                            text-align: left;
                            vertical-align: top;
                    }

                    .pass thead {
                        background: #9C9;
                        border-top: 2px solid #363;
                        border-bottom: 2px solid #363;
                    }

                    .failure thead {
                        background: #F88;
                        border-top: 2px solid #922;
                        border-bottom: 2px solid #922;
                    }

                    .failure .even {
                        background: #FCC;
                    }

                    .pass .even {
                        background: #DFD;
                    }
                    
                } } 
                body {
                    h1 ' "Test Results"

                        div -class $summaryClass {
                            h2 ' "Test Summary"
                                table {
                                    thead { th ' Tests 
                                        th ' Errors 
                                            th ' Failures 
                                            th ' Passes 
                                    }
                                    tbody { 
                                        tr {
                                            td ' $numberOfTests 
                                                td ' $numberOfErrors 
                                                td ' $numberOfFailures 
                                                td ' $numberOfPasses 
                                        } 
                                    } 
                                }
                        }

                    div -class failure {
                        h2 ' "Test Failures"
                            table {
                                thead { 
                                    th ' TestCase 
                                        th ' "Test Method" 
                                        th ' Failure 
                                } 
                                tbody {
                                    set x 0
                                    foreach result $results {
                                        foreach subresult [ $result results ] {
                                            if { ! [ $subresult passed ] } {
                                                incr x
                                                set class odd
                                                if { $x % 2 == 0 } {
                                                    set class even
                                                }
                                                tr -class $class { 
                                                    td , $result name
                                                    td , $subresult test
                                                    td pre , $subresult error
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                    }

                    div -class pass {
                        h2 ' "Test Passes"
                        table {
                            thead { 
                                th ' TestCase
                                th ' "Test Method"
                                th ' Return
                            }
                            tbody {
                                set x 0
                                foreach result $results {
                                    foreach subresult [ $result results ] {
                                        if { [ $subresult passed ] } {
                                            incr x
                                            set class odd
                                            if { $x % 2 == 0 } {
                                                set class even
                                            }
                                            tr -class $class { 
                                                td , $result name
                                                td , $subresult test
                                                td , $subresult return
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } ]
    }
}


