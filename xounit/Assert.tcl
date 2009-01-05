

namespace eval xounit {

    namespace import -force ::xotcl::*

    Class create Assert

    Assert # Assert {
        Assert is a library of assert methods.  Each
        assert methods checks some condition and simply
        returns if true, otherwise and error is thrown. 
        This error is an object reference.  Specifically
        a new AssertionError instance.  This allows messages
        to be carried along with the error and a common
        way to specific types of errors so that errors
        can be handled in the correct way. 

        Example:

        package require xounit
        namespace import -force ::xounit::*

        set a [ Assert new ]

        $a assert 1  "This will pass"
        $a assert 0  "This will fail"

        Asserts are simple procedures.  They replace
        two commads:

        if { ! $condition } {

            error $message
        }

        However the simplification of code is dramatic especially
        when checking many test variables. 

        Assert also works well with TestCase and TestRunner. It
        allows tests to be stopped at a point and a message can
        be returned to the TestCase to be analyzed and stored
        in a TestResult.
    }

    Assert # assert { 
        assert simply checks "condition" and throws
        a new AssertionError if false.  The AssertionError
        will contain the optional "message" string.

        condition - The condition to check for true ( 1 is true in Tcl )

        message A message to send on failure.
        
        set a [ ::xounit::Assert new ]

        $a assert 1  "This will pass"
        $a assert 0  "This will fail"

        #The failure will cause a Tcl error.
        #You should catch the error using a catch block and handle the error:

        if [ catch {

            $a assert 0 "Catch me"

        } result ] {

            puts [ $result message ]
        }

        #Assert failures throw an Exception. Use the message method
        #to get the message from the failure.
    }

    Assert instproc assert { condition { message  "" } } {

        if { $condition } {

            return 
            } else {

            error [ ::xounit::AssertionError new "$message" ]
        }
    }

    Assert # assertTrue {

        Equivalent to assert. Use to be explicit about
        what you are testing.

        condition - The condition to check for true ( 1 is true in Tcl ).

        message - A message to send on failure.
    }

    Assert instproc assertTrue { condition { message  "" } } {

        my assert $condition $message
    }

    Assert # assertFalse {

        Checks for the negative condition and throws
        and error on the positive condition.
    }

    Assert instproc assertFalse { condition { message  "" } } {

        if { $condition } { 

            error [ ::xounit::AssertionError new "$message" ]
        }
    }

    Assert # assertEquals {

        Compares the values, actual and expected, and the assert fails
        if they ARE NOT equal and throws an AssertionError.

        actual - the first value to compare 
        expected - the second value to compare
        message - failure message 
    }

    Assert instproc assertEquals { actual expected { message  "" } } {

        my assert [ expr { "$actual" == "$expected" } ] \
            "$message\nActual:   $actual\nExpected: $expected"
    }

    Assert # assertEqualsTrim {

        Compares the string trimmed values, actual and expected and the assert fails
        if they ARE NOT equal and throws an AssertionError.

        valueOne - the first value to compare 
        valueTwo - the second value to compare
        message - failure message 
    }

    Assert instproc assertEqualsTrim { actual expected { message  "" } } {

        set actual [ string trim $actual ]
        set expected [ string trim $expected ]

        my assert [ expr { "$actual" == "$expected" } ] \
            "$message\nActual:   $actual\nExpected: $expected"
    }

    Assert instproc assertEqualsByLine { actual expected { message  "" } } {

        set lineMessage "Expected equal by line
Actual: {$actual}
Expected: {$expected}
"
        
        set actualLines [ split [ string trim $actual ] "\n" ]
        set expectedLines [ split [ string trim $expected ] "\n" ] 

        set done 0

        while { ! $done } {

            if { [ llength $actualLines ] == 0 } {
                set done 1
                continue
            }

            if { [ llength $expectedLines ] == 0 } {
                set done 1
                continue
            }

            set currentAcutal [ string trim [ lindex $actualLines 0 ] ]
            set currentExpected [ string trim [ lindex $expectedLines 0 ] ]

            if { "$currentAcutal" == "" } {
                set actualLines [ lrange $actualLines 1 end ]
                continue 
            }

            if { "$currentExpected" == "" } {
                set expectedLines [ lrange $expectedLines 1 end ]
                continue 
            }

            #my debug "actual $currentAcutal"
            #my debug "expected $currentExpected"

            my assertEquals $currentAcutal $currentExpected "$message\n$lineMessage"
            
            set actualLines [ lrange $actualLines 1 end ]
            set expectedLines [ lrange $expectedLines 1 end ]
        }

        if { [ llength $actualLines ] > 0 } {

            my fail "Unexpected lines: $actualLines\n$lineMessage"
        }

        if { [ llength $expectedLines ] > 0 } {

            my fail "Lines not found: $expectedLines\n$lineMessage"
        }
    }

    Assert # assertNotEquals {

        Compares expected and actual and throws
        an error if they ARE equal.  
    }

    Assert instproc assertNotEquals { actual expected { message  "" } } {

        my assert [ expr { "$actual" != "$expected" } ] \
            "$message\nActual: $actual\nNot Expected: $expected"
    }

    Assert # assertNotEqualsTrim {

        Compares the trimmed values expected and actual and throws
        an error if they ARE equal.  
    }

    Assert instproc assertNotEqualsTrim { actual expected { message  "" } } {

        set actual [ string trim $actual ]
        set expected [ string trim $expected ]

        my assert [ expr { "$actual" != "$expected" } ] \
            "$message\nActual: $actual\nNot Expected: $expected"
    }

    Assert # fail {

        Throw an error with a message.  This is good
        for explicitly failing a testcase.  
    }

    Assert instproc fail { message } {

        error [ ::xounit::AssertionError new $message ]
    }

    Assert # assertFindIn {

        Try to find a string, tofind, in another string, string.
        If the string is not found throw error. 
    }

    Assert instproc assertFindIn { tofind string {message "" } } {

        set index [ string first $tofind $string ]

        my assert [ expr $index != -1 ] \
            "$message\nExpected to find $tofind in:\n$string"
        
        return $index
    }

    Assert # assertDoNotFindIn {

        Try not to find a string, tofind, in another string, string.
        If the string is found throw error. 
    }
    
    Assert instproc assertDoNotFindIn { tofind string {message "" } } {

        my assert [ expr [ string first $tofind $string ] == -1 ] \
            "$message\nExpected not to find $tofind in:\n$string"
    }

    Assert # assertRegex {

        Try to match a pattern, regex, to a string, string.
        If the pattern does not match throw an error. 
    }

    Assert instproc assertRegex { regex string {message "" } } {

        my assertNotEquals  [ regexp $regex $string all ] 0  \
            "$message\nExpected regex $regex to match string $string"

        if [ info exists all ] {

            return $all
        }

        return
    }

    Assert # assertObject {

        Checks object is a valid object
    }

    Assert instproc assertObject { object { message "" } } {

        my assertTrue [ my isobject $object ] "$message\nExpected $object to be an object"
    }

    Assert # assertClass {

        Checks object is a valid class
    }

    Assert instproc assertClass { class { message "" } } {

        my assertObject $class $message
        my assertTrue [ my isclass $class ] "$message\nExpected $class to be a class"
    }

    Assert # assertExists {

        Checks if varName exists on this object. 
    }

    Assert instproc assertExists { varName { message "" } } {

        my assertTrue [ my exists $varName ] "$message\nExpected $varName to exist"
    }

    Assert # assertValueInList {

        Asserts that a list on the current object has value
        in that list.
    }
    
    Assert instproc assertValueInList { list value { message "" } } {

        my assertNotEquals [ lsearch $list $value ] -1 \
            "$message\nDid not find $value in list $list"
    }

    Assert # assertObjectInList {

        Asserts that a list on the current object has object
        in that list.
    }
    
    Assert instproc assertObjectInList { list object { message "" } } {

        my assertObject $object $message

        my assertNotEquals [ lsearch $list $object ] -1 \
            "$message\nDid not find $object in list $list"
    }

    Assert # assertExistsObject {

        Asserts that the variable, varName, has a valid
        object handle as its value.
    }

    Assert instproc assertExistsObject { varName { message "" } } {

        my assertTrue [ my exists $varName ] "$message\nExpected $varName to exist"
        my assert [ Object isobject [ my set $varName ] ] \
            "$message\nExpected $varName to be an object"
    }

    Assert # assertValue {

        Asserts that value has a non-empty value.
    }

    Assert instproc assertValue { value { message "" } } {

        my assertNotEquals "" $value \
            "$message\nExpected value to have a value"
    }

    Assert # assertInteger {

        Asserts that number is an integer.
    }

    Assert instproc assertInteger { number { message "" } } {

        my assertValue $number \
            "$message\nExpected input to be an integer, but was empty"

        if [ Object isobject $number ] {

        my assertFalse [ Object isobject $number ] \
            "$message\nExpected $number to be an integer, but found object [ $number info class]"

        }

        my assert [ string is integer $number ] \
            "$message\nExpected $number to be an integer"
    }
    
    Assert # assertIntegerInRange {

        Asserts that number is greater-than-or-equal-to low and
        less-than-or-equal-to high.
    }

    Assert instproc assertIntegerInRange { number low high { message "" } } {

        my assertInteger $number $message

        my assert [ expr { $number >= $low } ] \
            "$message\nExpected $number to be at least than $low."

        my assert [ expr { $number <= $high } ] \
            "$message\nExpected $number to be no greater than $high."
    }

    Assert # assertInfoExists {
        
        Asserts that a variable, varName, exists and has a non-empty value on the current object.
    }

    Assert instproc assertInfoExists { varName { message "" } } {

        my assertTrue [ uplevel [ self callinglevel ] [ list info exists $varName ] ] \
            "$message\n Expected $varName to exist in [ self callingclass ]->[ self callingproc ]"
    }

    Assert # assertExistsValue {
        
        Asserts that a variable, varName, exists and has a non-empty value on the current object.
    }

    Assert instproc assertExistsValue { varName { message "" } } {

        my assertTrue [ my exists $varName ] "$message\nExpected $varName to exist"
        my assertNotEquals "" [ my set $varName ] \
            "$message\nExpected $varName to have a value"
    }

    Assert # assertNotExists {

        Checks if varName does not exist on this
        object.  
    }


    Assert instproc assertNotExists { varName { message "" } } {

        my assertFalse [ my exists $varName ] "$message\nExpected $varName to exist"
    }

    Assert # assertError {
        
        Asserts that a error will happend in script.
    }

    Assert instproc assertError { script { message "" } } {

        my assert [ catch { uplevel [ self callinglevel ] $script } error ] \
            "$message\nExpected to find an error in $script"

        return $error
    }

    Assert # assertNoError {
        
        Asserts that no error will happend in script.
    }

    Assert instproc assertNoError { script { message "" } } {

        set result ""

        my assertFalse [ catch { uplevel [ self callinglevel ] $script } result ] \
            "$message\nExpected not to find error in $script\n[ ::xoexception::Throwable extractMessage $result ]"
    }

    Assert # assertFailure {
        
        Asserts that a failure will happend in script.
    }

    Assert instproc assertFailure { script { message "" } } {

        my assert [ catch { uplevel [ self callinglevel ] $script } result ] \
            "$message\nExpected to find a failure in $script"

        my assert [ Object isobject $result ] \
            "$message\nExpected failure.  Error was found instead: $result"

        my assert [ $result hasclass ::xounit::AssertionError ] \
            "$message\nExpected to find a failure. Found object instead:\n$result is a [ $result info class ]"

        return $result
    }

    Assert # assertNoFailure {
        
        Asserts that no failure will happend in script.
    }

    Assert instproc assertNoFailure { script { message "" } } {

        set result ""

        my assertFalse [ catch { uplevel [ self callinglevel ] $script } result ] \
            "$message\nExpected not to find a failure in $script\n[ ::xoexception::Throwable extractMessage $result ]"
    }

    Assert # assertListLengthEquals {

        Asserts that the length of list is equal to length. The 
        assert fails with message if the length of list is different than length.
    }

    Assert instproc assertListLengthEquals { list length { message "" } } {

        my assertEquals [ llength $list ] $length \
            "Expected list length: $length\n\
            Acutal list length: [ llength $list ]\n\
            List: $list"
    }

    Assert # ?assert {

        Finds all assert methods on the current object.
        This is useful in a debugger or xotclsh.  Can
        also be used with debug in TestCases.

        my debug [ my ?assert ]
    }

    Assert instproc ?assert { { prefix "" } } {

        return [ my ?methods "assert$prefix" ]
    }

    Assert instproc assertSetEquals { listA listB { message "" } } {

        set setA [ lsort $listA ]
        set setB [ lsort $listB ]

        my assertListEquals $setA $setB \
            "$message\n \
            Actual Set: $listA \n \
            Expect Set: $listB \n"
    }

    Assert instproc assertListEquals { listA listB { message "" } } {


        for { set index 0 } { $index < [ llength $listA ] } { incr index } {

            my assertEquals [ lindex $listA $index ] \
                            [ lindex $listB $index ] \
                            "$message \n \
                             Actual List: $listA \n \
                             Expect List: $listB \n"

        }
    }

    Assert instproc assertListEqualsTrim { listA listB { message "" } } {


        for { set index 0 } { $index < [ llength $listA ] } { incr index } {

            my assertEqualsTrim [ lindex $listA $index ] \
                            [ lindex $listB $index ] \
                            "$message \n \
                             Actual List: $listA \n \
                             Expect List: $listB \n"

        }
    }

    Assert instproc assertEmpty { value { message "" } } {

        my assertEquals $value "" "$message\nValue was not empty"
    }

    Assert instproc assertFileExists { file { message "" } } {

        my assert [ file exists $file ] "$message\nCannot find file $file"
    }
    
    Assert # assertObjectValues {

        Checks object is a valid object
    }

    Assert instproc assertObjectValues { object valuesPairs { message "" } } {

        my assertObject $object $message

        foreach { name value } $valuesPairs {

            my assertTrue [ $object exists $name ] "Variable $name is not set\n$message"
            my assertEquals [ $object set $name ] $value "$message\n$name on $object incorrect"
        }
    }

    
    Assert # assertObjectTreeValues {

        Checks object is a valid object
    }

    Assert instproc assertObjectTreeValues { object valuesPairs { message "" } } {

        my assertObject $object $message

        foreach { name value } $valuesPairs {

            if { ! [ $object exists $name ] } {
                catch { 
                    set child ""
                    set child [ $object $name ] 
                }
                my assertObject $child "Cannot find object or variable named $name\n$name $message"
                my assertObjectTreeValues $child $value "$name $message"
            } else {
                my assertEquals [ $object set $name ] $value "$name in $message"
            }
        }
    }

    Assert instproc hasNoChildren { node } { 

        return [ expr { [ llength [ $node childNodes ] ] == 0 } ]
    }

    Assert instproc assertXmlEquals { x y { ignore "" } { message "" } { textTestFunction assertEquals } } {

        my assertDomEquals [ [ dom parse $x ] documentElement ] [ [ dom parse $y ] documentElement ] $ignore $message $textTestFunction
    }

    Assert instproc assertDomEquals { x y { ignore "" } { message "" } { textTestFunction assertEquals } } {

        if { "" != "$ignore" && ( [ regexp $ignore [ $x nodeName ] ] || [ regexp $ignore [ $y nodeName ] ] ) } { return }

        my assertEquals [ $x nodeName ] [ $y nodeName ] "$message\nNode name difference: [ $x toXPath ]"

        if { [ my hasNoChildren $x ] && [ my hasNoChildren $y ] } {

            my $textTestFunction [ $x asText ] [ $y asText ] "$message\nText difference: [ $x toXPath ]"
            return
        }

        set xChildren [ $x childNodes ]
        set yChildren [ $y childNodes ]

        while { [ llength $xChildren ] > 0 && [ llength $yChildren ] > 0 } {

            set xChild [ lindex $xChildren 0 ]
            set yChild [ lindex $yChildren 0 ]

            while { "" != "$ignore" && [ regexp $ignore [ $xChild nodeName ] ] } {

                #puts "Ignoring: [ $xChild nodeName ]"
                set xChildren [ lrange $xChildren 1 end ]
                set xChild [ lindex $xChildren 0 ]
                if { "" == "$xChild" } { break }
            }

            while { "" != "$ignore" && [ regexp $ignore [ $yChild nodeName ] ] } {
                
                #puts "Ignoring: [ $yChild nodeName ]"
                set yChildren [ lrange $yChildren 1 end ]
                set yChild [ lindex $yChildren 0 ]
                if { "" == "$yChild" } { break }
            }

            if { "" == "$xChild" } { break }
            if { "" == "$yChild" } { break }

            my assertDomEquals $xChild $yChild $ignore $message $textTestFunction

            set xChildren [ lrange $xChildren 1 end ]
            set yChildren [ lrange $yChildren 1 end ]
        }

        set xChild [ lindex $xChildren 0 ]
        set yChild [ lindex $yChildren 0 ]

        if { "" != "$xChild" } {
            while { "" != "$ignore" && [ regexp $ignore [ $xChild nodeName ] ] } {

                #puts "Ignoring: [ $xChild nodeName ]"
                set xChildren [ lrange $xChildren 1 end ]
                set xChild [ lindex $xChildren 0 ]
                if { "" == "$xChild" } { break }
            }
        }

        if { "" != "$yChild" } {
            while { "" != "$ignore" && [ regexp $ignore [ $yChild nodeName ] ] } {
                
                #puts "Ignoring: [ $yChild nodeName ]"
                set yChildren [ lrange $yChildren 1 end ]
                set yChild [ lindex $yChildren 0 ]
                if { "" == "$yChild" } { break }
            }
        }
        set paths ""
        foreach child $xChildren {
            lappend paths [ $child toXPath ]
        }

        my assertEmpty $xChildren "$message\nExtra X nodes: $paths"

        set paths ""
        foreach child $xChildren {
            lappend paths [ $child toXPath ]
        }

        my assertEmpty $yChildren "$message\nExtra Y nodes: $paths"
    }
}

