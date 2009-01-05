# Created at Thu Jan 03 20:24:16 EST 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestTclInterpreter -superclass ::xounit::TestCase

    TestTclInterpreter parameter {

    }

    TestTclInterpreter instproc setUp { } {

        my instvar interpreter

        set interpreter [ ::xointerp::TclInterpreter new ]
    }

    TestTclInterpreter instproc testNew { } {

        my instvar interpreter

        my assertEquals [ $interpreter info class ] ::xointerp::TclInterpreter
    }

    TestTclInterpreter instproc testEval { } {

        set value 0
        eval {
            incr value
        }
        my assertEquals $value 1
        eval {
            set value abc
        }
        my assertEquals $value abc
        eval {
            set value abc
            set value [ expr 1 + 1 ]
        }
        my assertEquals $value 2
    }

    TestTclInterpreter instproc testTclEval { } {

        my instvar interpreter

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            incr value
        }
        my assertEquals $value 1
    }

    TestTclInterpreter instproc testString { } {

        my instvar interpreter

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value "abc"
        }
        my assertEquals $value abc
    }

    TestTclInterpreter instproc testCurlyBrace { } {

        my instvar interpreter

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value {abc}
        }
        my assertEquals $value abc
    }

    TestTclInterpreter instproc testSquareBracket { } {

        my instvar interpreter

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value [ expr 1 + 1 ]
        }
        my assertEquals $value 2
    }

    TestTclInterpreter instproc testMultiLine { } {

        my instvar interpreter

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value [ expr 1 + 1 ]
            set value abc
        }
        my assertEquals $value abc
    }

    TestTclInterpreter instproc testCompleteCommand { } {

        my instvar interpreter

        my assertEquals [ $interpreter getCompleteCommand {{set a 5}} ] \
                        {{set a 5} {}}

        my assertEquals [ $interpreter getCompleteCommand {{set a {
5}}} ] \
                        {{set a {
5}} {}}
    }

    TestTclInterpreter instproc testCommandlist { } {

        set command {set a [ expr 1 + 1 ]}

        my assertEquals [ llength $command ] 8
    }

    TestTclInterpreter instproc testInfoLevel { } {

        set level [ info level ]

        set o [ Object new ]

        $o proc do { } {
            my set level [ info level ]
            my set levelm1 [ self callinglevel ]
        }

        $o do

        my assertEquals [ $o set level ] [ expr { $level + 1 } ]
        my assertEquals [ $o set levelm1 ] #$level

    }

    TestTclInterpreter instproc testCurlyBraces { } {

        my instvar interpreter

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value {[ expr 1 + 1 ]}
            puts $value
        }
        my assertEquals $value {[ expr 1 + 1 ]}
    }

    TestTclInterpreter instproc testString { } {

        my instvar interpreter

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value "{[ expr 1 + 1 ]}"
            puts $value
        }
        my assertEquals $value {{2}}
    }

    TestTclInterpreter instproc testEscape { } {

        my instvar interpreter

        set value0 "{\[ expr 1 + 1 \]}"
        my assertEquals $value0 {{[ expr 1 + 1 ]}} 1

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value "{\[ expr 1 + 1 \]}"
            puts $value
        }
        my assertEquals $value {{[ expr 1 + 1 ]}} 2
    }

    TestTclInterpreter instproc testNestedBrackets {} {

        my instvar interpreter

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value [ expr 1 + [ expr 1 + 1 ] ]
            puts $value
        }
        my assertEquals $value 3
    }

    TestTclInterpreter instproc testNestedBrackets2 {} {

        my instvar interpreter

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value [ list 1 + { [ expr 1 + 1 ] } ]
            puts $value
        }
        my assertListEquals $value { 1 + { [ expr 1 + 1 ] } }
    }

    TestTclInterpreter instproc testHiddenBrackets {} {

        my instvar interpreter

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value { [ } 
            puts $value
        }
        my assertEquals $value { [ }
    }

    TestTclInterpreter instproc testHiddenBrackets2 {} {

        my instvar interpreter

        set value0 [ list { [ } ]
        my assertEquals $value0 [ list { [ } ] 1
        

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value [ list { [ } ]
            puts $value
        }
        my assertEquals $value [ list { [ } ] 2
    }

    TestTclInterpreter instproc testHiddenBrackets2a {} {

        my instvar interpreter

        set value 0
        my assertEquals $value 0
        eval {

            set value [ list { [ } ]
            puts $value
        }
        my assertEquals $value [ list { [ } ]
    }


    TestTclInterpreter instproc testHiddenBrackets3 {} {

        my instvar interpreter

        set value0 [ list \[  ]
        my assertEquals $value0 [ list \[ ] 1

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value [ list \[ ]
            puts $value
        }
        my assertEquals $value [ list \[ ] 2
    }

    TestTclInterpreter instproc testSpaceInReturnNormal {} {

        set value a[ list b c ]
        my assertEquals $value "ab c"
    }

    TestTclInterpreter instproc testSpaceInReturn {} {

        my instvar interpreter

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value a[ list b c ]
            puts $value
        }
        my assertEquals $value "ab c"
    }

    TestTclInterpreter instproc testSimple {} {

        my instvar interpreter

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value [ list a ]
            puts $value
        }
        my assertEquals $value [ list a ]
    }


    TestTclInterpreter instproc testSimple2 {} {

        my instvar interpreter

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value [ ::xox::identity a ]
            puts $value
        }
        my assertEquals $value a
        my assertEquals $value [ list a ]
        my assertEquals $value [ ::xox::identity a ]
    }

    TestTclInterpreter instproc testReturnBrace {} {

        my instvar interpreter

        proc do { } {

            return "\{"
        }

        set value0 [ do ]
        my assertEquals $value0 "\{" 1

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value [ do ]
            puts $value
        }
        my assertEquals $value "\{" 2
    }

    TestTclInterpreter instproc testReturnBrace2 {} {

        my instvar interpreter

        proc do { } {

            return "{}"
        }

        set value0 [ do ]
        my assertEquals $value0 "{}" 1

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value [ do ]
            puts $value
        }
        my assertEquals $value "{}" 2
    }


    TestTclInterpreter instproc testReturnBrace3 {} {

        my instvar interpreter

        proc do { } {

            return " {}"
        }

        set value0 [ do ]
        my assertEquals $value0 " {}" 1

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value [ do ]
            puts $value
        }
        my assertEquals $value " {}" 2
    }

    TestTclInterpreter instproc testReturnBrace4 {} {

        my instvar interpreter

        proc do { } {

            return "\t{}"
        }

        set value0 [ do ]
        my assertEquals $value0 "\t{}" 1

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value [ do ]
            puts $value
        }
        my assertEquals $value "\t{}" 2
    }

    TestTclInterpreter instproc testReturnBrace5 {} {

        my instvar interpreter

        proc do { } {

            return "\n{}"
        }

        set value0 [ do ]
        my assertEquals $value0 "\n{}" 1

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value [ do ]
            puts $value
        }
        my assertEquals $value "\n{}" 2
    }

    TestTclInterpreter instproc testReturnBrace6 {} {

        my instvar interpreter

        proc do { } {

            return "\"{}"
        }

        set value0 [ do ]
        my assertEquals $value0 "\"{}" 1

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value [ do ]
            puts $value
        }
        my assertEquals $value "\"{}" 2
    }

    TestTclInterpreter instproc testReturnBrace7 {} {

        my instvar interpreter

        proc do { } {

            return "\[{}"
        }

        set value0 [ do ]
        my assertEquals $value0 "\[{}" 1

        set value 0
        my assertEquals $value 0
        $interpreter tclEval {

            set value [ do ]
            puts $value
        }
        my assertEquals $value "\[{}" 2
    }

    TestTclInterpreter instproc testError {} {

        my instvar interpreter

        catch {

        $interpreter tclEval {

            error "an error"
            set x 0
        } 
        } error

        my assertObject $error error
        my assertEqualsTrim [ $error command ] {error "an error"}
        my assertEqualsByLine [ $error script ] \
{error "an error"
set x 0}
        my assertEqualsByLine [ $error getScriptErrorMessage ] \
"
an error
while executing
\"error \"an error\"\"
in script {
error \"an error\"
set x 0
} 
"
    }

    TestTclInterpreter instproc testTclError {} {

        my instvar interpreter

        catch {

        eval {

            error "an error"
        } } error

        my assertEquals $error "an error"
        my assertEqualsByLine $::errorInfo \
{
an error
while executing
"error "an error""
("eval" body line 3)
invoked from within
"eval {
error "an error"
} "
}
    }

    TestTclInterpreter instproc testNoRunInnerBracket { } {

        my instvar interpreter

        set a 5

        $interpreter tclEval {

            set b {
               [ incr a ]
            }
        }

        my assertEquals $a 5
    }

    TestTclInterpreter instproc testNoRunInnerBracket2 { } {

        my instvar interpreter

        set a 5

        $interpreter tclEval {

            set "b" {
               [ incr a ]
            }
        }

        my assertEquals $a 5
    }
    

    TestTclInterpreter instproc testLevel { } {

        my instvar interpreter

        set level [ info level ]

        my assertEquals [ $interpreter currentLevel ] none

        $interpreter tclEval {

            set innerLevel [ $interpreter currentLevel ]

        }

        my assertEquals [ $interpreter currentLevel ] none
        my assertEquals #${level} $innerLevel

    }

    TestTclInterpreter instproc testSubst { } {

        my instvar interpreter

        set command set

        $interpreter tclEval {

            $command a 5
            set newCommand $command
        }

        my assert [ info exists a ] a
        my assertEquals $a 5
        my assertEquals $command set
        my assertEquals $newCommand set
    }

    TestTclInterpreter instproc testEvalSubCommandsEmpty { } {

        my instvar interpreter

        set string [ $interpreter evalSubCommands #[ info level ] {

        } 1 ]

        my assertEqualsByLine $string \
"
"
    }

    TestTclInterpreter instproc testEvalSubCommandsBasic { } {

        my instvar interpreter

        set string [ $interpreter evalSubCommands #[ info level ] {

            set a 1
            set b 2

        } 1 ]

        my assertEqualsByLine $string \
"
set a 1
set b 2
"
    }

    TestTclInterpreter instproc testEvalSubCommandsCommands { } {

        my instvar interpreter

        set string [ $interpreter evalSubCommands #[ info level ] {

            [ set a 1 ]
            [ set b 2 ]
            [ set c [ expr { $a + $b } ] ]

        } 1 ]

        my assertEqualsByLine $string \
"
1
2
3
"
    }

    TestTclInterpreter instproc testEvalSubCommandsDynamic { } {

        my instvar interpreter

        set command set

        set string [ $interpreter evalSubCommands #[ info level ] {

            $command
            [ $command a 1 ]
            [ $command b 2 ]

        } 1 ]

        my assertEqualsByLine $string \
"
\$command
1
2
"
    }

    TestTclInterpreter instproc testEvalSubCommandsVariables { } {

        my instvar interpreter

        set a 1
        set b 2

        set string [ $interpreter evalSubCommands #[ info level ] {

            set a $a
            set b $b
            [ set c $a ]

        } 1 ]

        my assertEqualsByLine $string \
"
set a \$a
set b \$b
1
"
    }

    TestTclInterpreter instproc testEvalSubCommandsVariableNames { } {

        my instvar interpreter

        set a \$a
        set b 2

        set string [ $interpreter evalSubCommands #[ info level ] {

            [ set a $a ]

        } 1 ]

        my assertEqualsByLine $string \
"
\$a
"
    }

    TestTclInterpreter instproc testTclMultilineCommand { } {


        set a [ set a 5
                set b 6
                set c 7 ]

        my assertEquals $a 7 a
        my assertEquals $b 6 b
        my assertEquals $c 7 c
    }

    TestTclInterpreter instproc testTclInterpreterMultilineCommand { } {

        my instvar interpreter 

        $interpreter tclEval {

            set a [ set a 5
                    set b 6
                    set c 7 ]

        }

        my assertEquals $a 7 a
        my assertEquals $b 6 b
        my assertEquals $c 7 c
    }

    TestTclInterpreter instproc testIncompleteSubCommand { } {

        my instvar interpreter 

        my assertError {

        $interpreter tclEval {

            set a [ set a 5
                    set b 6
                    set c 7 
        }

        }

        my assertFalse [ info exists a ] a
        my assertFalse [ info exists b ] b
        my assertFalse [ info exists c ] c
    }

    TestTclInterpreter instproc testBadBracket { } {

        my instvar interpreter 

        set error [ my assertError {

            $interpreter tclEval {

                set a ] set a 5
                        set b 6
                        set c 7 
            }
        } ]
        my assertEqualsTrim [ $error message ] {wrong # args: should be "set varName ?newValue?"}
    }

    TestTclInterpreter instproc testBadBrace { } {

        my instvar interpreter 

        set error [ my assertError {

            $interpreter tclEval "

                set a \} set a 5
                        set b 6
                        set c 7 
            "
        } ]
        my assertEqualsTrim [ $error message ] {wrong # args: should be "set varName ?newValue?"}
    }

    TestTclInterpreter instproc testBadBracketInEvalSubst { } {

        my instvar interpreter 

        my assertError {

        $interpreter evalSubst {

            set a [ set a 5
                    set b 6
                    set c 7 
        }

        }

        my assertFalse [ info exists a ] a
        my assertFalse [ info exists b ] b
        my assertFalse [ info exists c ] c

        my assertEqualsTrim [ lindex [ split $::errorInfo "\n" ] 0 ] {Missing closing bracket in:}
    }

    TestTclInterpreter instproc testComment { } {

        my instvar interpreter 

        $interpreter tclEval {

            #set a 5
            #[ set b 6 ]
#\
            set c 7
            set d 8;# set e 9
        }

        my assertFalse [ info exists a ] a
        my assertFalse [ info exists b ] b
        my assertFalse [ info exists c ] c
        my assertTrue [ info exists d ] d
        my assertFalse [ info exists e ] e
    }


    TestTclInterpreter instproc testSemiColon { } {

        my instvar interpreter 

        $interpreter tclEval {

            set a 5; set b 6
        }

        my assertTrue [ info exists a ] a
        my assertTrue [ info exists b ] b 
    }

    TestTclInterpreter instproc testCurlyBrackets { } {

        my instvar interpreter 

        $interpreter tclEval {

            set a {5}
        }

        my assertTrue [ info exists a ] a
    }
}


