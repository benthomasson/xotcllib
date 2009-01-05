# Created at Sat Nov 15 11:05:09 EST 2008 by ben

namespace eval ::xoweb {

    ::xoweb::MultiuserApplicationClass create XodeWeb -superclass ::xoweb::AjaxApplication

    XodeWeb @doc XodeWeb {

        Please describe the class XodeWeb here.
    }

    XodeWeb parameter {
        xodeEnvironment
        xodeLanguage
        { result "" }
        { output "" }
    }

    XodeWeb instproc init { } {
        my instvar xodeEnvironment xodeLanguage

        package require xode

        set xodeLanguage [ ::xode::XodeLanguage newLanguage ]
        set xodeEnvironment [ $xodeLanguage set environment ]
    }

    XodeWeb instproc initialLoad { } {

        my instvar url result output xodeEnvironment xodeLanguage

        return [ ::xoweb::makePage { } {

            html {
                head {
                    script -language "Javascript" -src "/files/prototype.js"
                    script -language "Javascript" -src "/files/xopro.js"
                }
                new XowebCSS -width 80%
                body {
                    div -class object {

                        h1 -class name ' XOTcl Development Environment

                        form -action "javascript:o=new Object();;o.command=\$('command').getValue();ajaxLoad('result','$url','evaluate',o);" {
                            ' xode>
                            input -type text -size 100 -id command -name command
                        }
                        form {
                            select -id commands -onChange "\$('command').value = \$('commands').options\[\$('commands').selectedIndex\].value + ' ';\$('command').focus();o=new Object();o.command=this.options\[this.selectedIndex\].value;ajaxLoadSilent('firstArgs','$url','getArguments',o);" {
                                option ' Select Command
                                foreach command [ $xodeLanguage getCommands ] {
                                    option ' $command
                                }
                            }
                            span -id firstArgs {
                            }
                        }
                        javascript {
                            $('command').focus();
                        }

                        div -id result {

                        }
                    }
                }
            }
        } ]
    }

    XodeWeb instproc evaluate { -command } {

        my instvar xodeEnvironment result output

        if { "" == "$command" } { return "" }

        my set output ""

        rename ::puts ::oldputs
        proc ::puts { args } [ subst {

            if { \[ llength \$args \] == 1 } {
                [ self ] append output \[ lindex \$args 0 \]
                [ self ] append output "\n"
            } else {
                eval ::oldputs \$args
            }
        } ]

        if [ catch {

            my result [ $xodeEnvironment eval $command ]

        } result ] {

            my result "$result\n$::errorInfo"
        }

        rename ::puts {}
        rename ::oldputs ::puts

        return [ ::xoweb::makePage { } {
            h4 ' Command
            pre ' $command
            h4 ' Result
            pre ' $result
            h4 ' Output
            pre ' $output
            javascript {
                $('command').setValue('');
            }
        } ]
    }

    XodeWeb instproc getArguments { -command } {

        my instvar xodeLanguage 

        set argNumber 0

        set argumentNames [ [ ::xox::ObjectGraph findFirstImplementation $xodeLanguage $command ] info instargs $command ]
        set currentArgName [ lindex $argumentNames $argNumber ]
        if { $argNumber >= [ llength $argumentNames ] && "[ lindex $argumentNames end ]" == "args" } {
            set currentArgName args
        }

        set getter "getValues@${command}@${currentArgName}"

        if { "[ $xodeLanguage info methods $getter ]" == "" } { return }

        return [ ::xoweb::makePage { } {
            select -id args -onChange "\$('command').value = \$('commands').options\[\$('commands').selectedIndex\].value + ' ' + \$('args').options\[\$('args').selectedIndex\].value;\$('command').focus();" {
                option ' Select Value
                foreach value [ $xodeLanguage $getter ] {
                    option ' $value
                }
            }
        } ]
    }
}


