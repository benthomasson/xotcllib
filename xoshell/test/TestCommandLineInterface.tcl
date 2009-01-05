
namespace eval ::xoshell::test { 

Class create TestCommandLineInterface -superclass { ::xounit::TestCase }

TestCommandLineInterface id {$Id: TestCommandLineInterface.tcl,v 1.1 2007/08/05 14:27:11 bthomass Exp $}
  
TestCommandLineInterface @doc TestCommandLineInterface {
::xoshell::test::TestCommandLineInterface tests ::xoshell::CommandLineInterface
}
       
TestCommandLineInterface parameter {

}

TestCommandLineInterface instproc setUp { } {

    my instvar cli

    set cli [ ::xoshell::CommandLineInterface new -channel stdin ]
    $cli enableRaw
}

TestCommandLineInterface instproc notestReadCharacter { } {

    my instvar cli
    my assertEquals [ $cli readCharacter ] "a"
}

TestCommandLineInterface instproc notestReadline { } {

    my instvar cli
    my assertEquals [ $cli readLine ] "abcdef"
}

TestCommandLineInterface instproc tearDown { } {

    my instvar cli

    $cli disableRaw
}
}


