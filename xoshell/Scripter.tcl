# Created at Tue Apr 08 22:56:39 EDT 2008 by bthomass

namespace eval ::xoshell {

    Class Scripter -superclass ::xotcl::Object

    Scripter @doc Scripter {

        Please describe the class Scripter here.
    }

    Scripter parameter {
        spawn_id
    }

    Scripter instproc init { { file "" } } {

        my startShell

        if { "" == "$file" } {
            my interact
        } else {
            my runFile $file
            my interact
        }

        my sendline "\n\nexit"

        my expect {
            eof
        }

        my close
    }

    Scripter instproc startShell { } {

        my instvar spawn_id 

        spawn [ file join [ ::xoshell packagePath ] xoshell ]
    }

    Scripter instproc send { string } {

        my instvar spawn_id

        catch { send -i $spawn_id "$string" }
    }

    Scripter instproc sendline { line } {

        my instvar spawn_id

        catch { send -i $spawn_id "$line\n" }
    }

    Scripter instproc runFile { file } {

        my runScript "[ ::xox::readFile $file ]"
    }

    Scripter instproc runScript { script } {

        foreach line [ split $script "\n" ] {

            if { "interact" == "[ string trim $line ]" } {
                my interact 
                continue
            }

            my sendline $line
        }
    }

    Scripter instproc expect { code } {


        my instvar spawn_id

        expect "
            -i $spawn_id
            --
            [ string trim $code ]
        "
    }

    Scripter instproc interact { } {

        my instvar spawn_id 
        interact { 
            -i $spawn_id
            -nobuffer
            --
            "exit" { 
                my send "\x8\x8\x8\x8"
                return
            }
        }
    }

    Scripter instproc close { } {

        my instvar spawn_id
        catch { close -i $spawn_id }
    }
}


