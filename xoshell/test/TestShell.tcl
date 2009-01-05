
namespace eval ::xoshell::test { 

Class create TestShell -superclass { ::xounit::TestCase }

TestShell id {$Id: TestShell.tcl,v 1.11 2008/10/19 18:54:55 bthomass Exp $}
  
TestShell @doc TestShell {
Please describe TestShell here.
}
       
TestShell parameter {

} 

TestShell instproc setUp { } {

    my instvar shell objectInterp environment

    set language [ ::xodsl::Language newLanguage ]
    set environment [ $language set environment ]
    set shell [ ::xoshell::Shell new -environment $environment -language $language -doHistory 0 ]

    cd [ ::xoshell packagePath ]
}
        

TestShell @doc testAddPrompt { 
testAddPrompt does ...
}

TestShell instproc testAddPrompt {  } {

    my instvar shell

    $shell addPrompt
}


TestShell @doc testCheckInput { 
testCheckInput does ...
}

TestShell instproc testCheckInput {  } {

    my instvar shell 

    ::xox::withOpenFile test/checkInput.input r input {

    $shell connectCli $input

    my assertFalse [ $shell done ]

    $shell checkInput

    my assert [ $shell done ]

    }
}


TestShell @doc testEputs { 
testEputs tests printing an error message
}

TestShell instproc testEputs {  } {

    my instvar shell

    $shell eputs "An error message"
}



TestShell @doc testProcessCommand { 
testProcessCommand does ...
}

TestShell instproc testProcessCommand {  } {

    my instvar shell

    my assertFalse [ $shell done ]

    $shell processCommand exit

    my assert [ $shell done ]
}


TestShell @doc testPrompt { 
testPrompt does ...
}

TestShell instproc testPrompt {  } {
    my instvar shell

    $shell prompt
}


TestShell @doc testPuts { 
testPuts tests printing a message
}

TestShell instproc testPuts {  } {

    my instvar shell

    $shell puts "A message"
}


TestShell @doc testShell { 
testShell does ...
}

TestShell instproc testShell {  } {

    my instvar shell 

    ::xox::withOpenFile test/checkInput.input r input {

        $shell input $input
        $shell 

    my assertFalse [ $shell done ]

    $shell shell

    my assert [ $shell done ]

    }
}


TestShell instproc testDefaultMethod {  } {
    my instvar shell 

    $shell defaultMethod
}



TestShell instproc testExit1 { } {
    my instvar shell 

    my assertFalse [ $shell done ]

    $shell exit

    my assert [ $shell done ]
}


TestShell @doc testAddAbilities { 
testAddAbilities does ...
}

TestShell @doc testExit { 
testExit does ...
}

TestShell instproc testExit2 {  } {
    my instvar shell 

    my assertFalse [ $shell done ]

    $shell exit

    my assert [ $shell done ]
}


TestShell @doc testGetShortComment { 
testGetShortComment does ...
}

TestShell instproc testGetShortComment {  } {
    my instvar shell
    my assertEquals [ $shell getShortComment ? ] "Help method"
}


TestShell instproc testSet {  } {

    my instvar shell environment

    my readShellFile test/set.input

    my assert [ $environment exists a ] "A does not exist"
    my assertEquals [ $environment set a ] 5 a
}

TestShell instproc readShellFile { file } {

    my instvar shell environment

    ::xox::withOpenFile $file r input {

        puts "Running $file"
        $shell connectCli $input
        $shell shell
    }

    my assert [ $shell done ]
}

TestShell instproc testForeach {  } {

    my instvar shell environment

    my readShellFile test/foreach.input

    my assert [ $environment exists sum ] "Sum does not exist"
    my assertEquals [ $environment set sum ] 15 sum

    my assertEqualsByLine [ join [$shell history] "\n" ] \
{
    set sum 0
    foreach x {1 2 3 4 5} {
            incr sum $x
    }
}
}

TestShell instproc testFor {  } {

    my instvar shell environment

    my readShellFile test/for.input

    my assert [ $environment exists sum ] "Sum does not exist"
    my assertEquals [ $environment set sum ] 45 sum

    my assertEqualsByLine [ join [$shell history] "\n" ] \
{
set sum 0
for {set i 0} {$i < 10} {incr i} {
puts $sum
incr sum $i
}
}

}

TestShell instproc testWhile {  } {

    my instvar shell environment

    my readShellFile test/while.input

    my assert [ $environment exists sum ] "Sum does not exist"
    my assertEquals [ $environment set sum ] 45 sum

    my assertEqualsByLine [ join [$shell history] "\n" ] \
{
set sum 0
set i 0
while { $i < 10 } {
puts $sum
incr sum $i
incr i
}
}

}

TestShell instproc testIfFor {  } {

    my instvar shell environment

    my readShellFile test/iffor.input

    my assert [ $environment exists sum ] "Sum does not exist"
    my assertEquals [ $environment set sum ] 45 sum

    my assertEqualsByLine [ join [$shell history] "\n" ] \
{
set sum 0
if 1 {
for {set i 0} {$i < 10} {incr i} {
puts $sum
incr sum $i
}
}
}
}


TestShell instproc testWriteFile {  } {

    my instvar shell environment

    my readShellFile test/iffor.input

    my assert [ $environment exists sum ] "Sum does not exist"
    my assertEquals [ $environment set sum ] 45 sum

    cd /tmp

    $shell fileName /tmp/[clock seconds]
    $shell doHistory 1

    set file [ $shell writeHistory ]

    my assert [ file exists $file ]

    my assertEqualsByLine [ ::xox::readFile $file ] \
{
set sum 0
if 1 {
for {set i 0} {$i < 10} {incr i} {
puts $sum
incr sum $i
}
}
}
    file delete $file
}
}

