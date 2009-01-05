# Created at Mon Mar 31 09:05:00 AM EDT 2008 by bthomass

namespace eval ::xounit {

    Class AssertExpect 

    AssertExpect parameter {
        spawn_id
        { timeout 30 }
        pid
    }

    AssertExpect instproc assertSpawn { args } {

        my instvar spawn_id pid

        my assertNoError {
           set pid [ eval spawn $args  ]
        } "spawn $args failed"
    }

    AssertExpect instproc assertSend { args } {

        my instvar spawn_id

        my assertNoError {
            eval send -i $spawn_id $args 
        } "send $args failed"
    }

    AssertExpect instproc assertExpect { code { message "" } } {

        my instvar spawn_id timeout

        set code "
            -i $spawn_id
            -timeout $timeout
            [ string trim $code ]
            {Bus error} {my fail \"$message\nBus error\"}
            {Segmentation fault} {my fail \"$message\nSegmentation fault\"}
            {command not found} {puts {command not found}; my fail \"$message\ncommand not found\"}
            timeout { puts timeout!; my fail \"$message\nexpect timeout in:\n [ string trim $code ]\" }
            eof { puts eof!; my fail \"$message\nexpect eof in:\n [ string trim $code ]\" }
            default { puts default!; my fail \"$message\nexpect default in:\n [ string trim $code ]\" }
        "

        expect "
        [ string trim $code ]
        "
    }

    AssertExpect instproc assertSendExpect {  send expect { message "" } } {

        my assertSend $send
        my assertExpect $expect $message
    }

    AssertExpect instproc interact { } {

        my instvar spawn_id

        interact -i $spawn_id

    }

    AssertExpect instproc closeExpect { } {

        my instvar spawn_id pid

        catch { close -i $spawn_id }

        exec kill -9 $pid
    }
}
