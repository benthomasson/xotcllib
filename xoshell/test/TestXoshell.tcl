# Created at Wed Mar 12 11:39:59 AM EDT 2008 by bthomass

namespace eval ::xoshell::test {

    Class TestXoshell -superclass { ::xounit::TestCase ::xounit::AssertExpect }

    TestXoshell parameter {
    }

    TestXoshell instproc setUp { } {

        package require Expect

        cd [ ::xoshell packagePath ]
        my assertSpawn ./xoshell notAFile.tcl 0
        my assertExpect {
            notAFile { }
        }
    }

    TestXoshell instproc testBasic { } {

        my assertSendExpect "exit\n" {
            eof {}
        }
    }

    TestXoshell instproc testTabComplete { } {


        my assertSendExpect "se\t" {
            set {}
        }

        my assertSendExpect "t\n" {
            "wrong # args" {} 
        }

        my assertSendExpect "exit\n" {
            eof {}
        }
    }

    TestXoshell instproc testGetHelp { } {

        my assertSendExpect "Object create o\n" {
            ::o {}
        }

        my assertSendExpect "o set ?" {
            "Read and write variables" { }
        }

        my assertSendExpect "5\n" {
            notAFile {}
        }

        my assertSendExpect "exit\n" {
            eof {}
        }
    }

    TestXoshell instproc testSegFault { } {

        my assertSendExpect "Object create o\n" {
            ::o {}
        }

        my assertSendExpect "o set ?" {
            "Read and write variables" { }
        }

        my assertSendExpect "\n" {
            notAFile {}
        } 1

        my assertSendExpect "\n" {
            notAFile {}
        } "Segfault occurs here if press enter after ?"

        my assertSendExpect "exit\n" {
            eof {}
        }
    }

    TestXoshell instproc testTabCompleteVariables { } {


        my assertSendExpect "set a 5\n" {
            notAFile {}
        }

        my assertSendExpect "puts $\t" {
            {puts $a} {}
        }

        my assertSendExpect "a\n" {
            5 {}
        }

        my assertSendExpect "exit\n" {
            eof {}
        }
    }

    TestXoshell instproc testQuestionMark { } {


        my assertSendExpect "set a 5??\n" {
            5? {}
        }

        my assertSendExpect "exit\n" {
            eof {}
        }
    }

    TestXoshell instproc tearDown { } {

        #add tear down code here
        catch { my closeExpect }
    }
}


