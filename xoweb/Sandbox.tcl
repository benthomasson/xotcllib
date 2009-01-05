# Created at Mon Oct 27 17:58:12 EDT 2008 by ben

namespace eval ::xoweb {

    ::xoweb::MultiuserApplicationClass create Sandbox -superclass ::xoweb::AjaxApplication

    Sandbox @doc Sandbox {

        Please describe the class Sandbox here.
    }

    Sandbox parameter {
        shell 
        shellLanguage
        shellEnvironment
        { history "" }
    }

    Sandbox instproc init { } {

        my instvar shellLanguage shellEnvironment 

        set shellLanguage [ ::xodsl::Language newLanguage ]
        set shellEnvironment [ $shellLanguage set environment ]
        my shell [ ::xoshell::Shell new -language $shellLanguage -environment $shellEnvironment ]
    }

    Sandbox instproc initialLoad { } {

        my instvar user history root shell shellEnvironment shellLanguage 
        
        return [ ::xoweb::makePage { } {
            html {
                new XowebCSS -width 80%
                div -class object {
                    h1 -class name ' "Xoshell Sandbox"
                    div -style {  float: right; } {
                        ul foreach var [ $shellEnvironment info vars ] {
                            li { 
                                ' $var
                                ' " : "
                                catch { , $shellEnvironment set $var }
                            }
                        }
                    }
                    form -action "" -method POST {
                        textarea -rows 30 -cols 80 -id output -readonly yes '' $history 
                        br
                        ' xoshell> 
                        input -type text -name command -size 83 -id command
                        input -type hidden -name method -value evaluate
                    }
                    javascript {
                        command.focus();
                        output.scrollTop = output.scrollHeight;
                    }
                }
            }
        } ]
    }

    Sandbox instproc evaluate { -command } { } {

        my instvar shell shellLanguage shellEnvironment 

        if { "" == "$command" } { return [ my initialLoad ] }

        set output ""

        rename ::puts ::oldputs
        proc ::puts { args } [ subst {

            if { \[ llength \$args \] == 1 } {
                append output \[ lindex \$args 0 \]
                append output "\n"
            } else {
                eval ::oldputs \$args
            }
        } ]

        if [ catch {

            set result [ $shellEnvironment eval $command ]

        } result ] {

            set result "$result\n$::errorInfo"
        }

        rename ::puts {}
        rename ::oldputs ::puts

        my append history "xoshell> $command\n"
        my append history $output
        my append history $result
        my append history "\n"

        my initialLoad
    }
}


