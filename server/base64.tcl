#Borrowed from http://wiki.tcl.tk/_revision/11035?V=0&A=1
#until I decide I really need to deal with tcllib

namespace eval server::base64 {
variable base64 {}
variable base64_en {}

# We create the auxiliary array base64_tmp, it will be unset later.

set i 0
foreach char {A B C D E F G H I J K L M N O P Q R S T U V W X Y Z \
a b c d e f g h i j k l m n o p q r s t u v w x y z \
0 1 2 3 4 5 6 7 8 9 + /} {
set base64_tmp($char) $i
lappend base64_en $char
incr i
}

#
# Create base64 as list: to code for instance C<->3, specify
# that [lindex $base64 67] be 3 (C is 67 in ascii); non-coded
# ascii chars get a {}. we later use the fact that lindex on a
# non-existing index returns {}, and that [expr {} < 0] is true
#

# the last ascii char is 'z'
scan z %c len
for {set i 0} {$i <= $len} {incr i} {
set char [format %c $i]
set val {}
if {[info exists base64_tmp($char)]} {
set val $base64_tmp($char)
} else {
set val {}
}
lappend base64 $val
}

# code the character "=" as -1; used to signal end of message
scan = %c i
set base64 [lreplace $base64 $i $i -1]

# remove unneeded variables
unset base64_tmp i char len val

namespace export encode decode
}

# ::server::base64::encode --
#
#    Base64 encode a given string.
#
# Arguments:
#    args    ?-maxlen maxlen? ?-wrapchar wrapchar? string
#
#        If maxlen is 0, the output is not wrapped.
#
# Results:
#    A Base64 encoded version of $string, wrapped at $maxlen characters
#    by $wrapchar.

proc ::server::base64::encode {args} {
set base64_en $::server::base64::base64_en

# Set the default wrapchar and maximum line length to match the output
# of GNU uuencode 4.2.  Various RFC's allow for different wrapping
# characters and wraplengths, so these may be overridden by command line
# options.
set wrapchar "\n"
set maxlen 60

if { [llength $args] == 0 } {
error "wrong # args: should be \"[lindex [info level 0] 0]\
?-maxlen maxlen? ?-wrapchar wrapchar? string\""
}

set optionStrings [list "-maxlen" "-wrapchar"]
for {set i 0} {$i < [llength $args] - 1} {incr i} {
set arg [lindex $args $i]
set index [lsearch -glob $optionStrings "${arg}*"]
if { $index == -1 } {
error "unknown option \"$arg\": must be -maxlen or -wrapchar"
}
incr i
if { $i >= [llength $args] - 1 } {
error "value for \"$arg\" missing"
}
set val [lindex $args $i]

# The name of the variable to assign the value to is extracted
# from the list of known options, all of which have an
# associated variable of the same name as the option without
# a leading "-". The [string range] command is used to strip
# of the leading "-" from the name of the option.
#
# FRINK: nocheck
set [string range [lindex $optionStrings $index] 1 end] $val
}

# [string is] requires Tcl8.2; this works with 8.0 too
if {[catch {expr {$maxlen % 2}}]} {
error "expected integer but got \"$maxlen\""
}

set string [lindex $args end]

set result {}
set state 0
set length 0

# Process the input bytes 3-by-3

binary scan $string c* X
foreach {x y z} $X {
# Do the line length check before appending so that we don't get an
# extra newline if the output is a multiple of $maxlen chars long.
if {$maxlen && $length >= $maxlen} {
append result $wrapchar
set length 0
}

append result [lindex $base64_en [expr {($x >>2) & 0x3F}]]
if {$y != {}} {
append result [lindex $base64_en [expr {(($x << 4) & 0x30) | (($y >> 4) & 0xF)}]]
if {$z != {}} {
append result \
[lindex $base64_en [expr {(($y << 2) & 0x3C) | (($z >> 6) & 0x3)}]]
append result [lindex $base64_en [expr {($z & 0x3F)}]]
} else {
set state 2
break
}
} else {
set state 1
break
}
incr length 4
}
if {$state == 1} {
append result [lindex $base64_en [expr {(($x << 4) & 0x30)}]]==
} elseif {$state == 2} {
append result [lindex $base64_en [expr {(($y << 2) & 0x3C)}]]=
}
return $result
}

# ::server::base64::decode --
#
#    Base64 decode a given string.
#
# Arguments:
#    string  The string to decode.  Characters not in the base64
#        alphabet are ignored (e.g., newlines)
#
# Results:
#    The decoded value.

proc ::server::base64::decode {string} {
if {[string length $string] == 0} {return ""}

set base64 $::server::base64::base64

binary scan $string c* X
foreach x $X {
set bits [lindex $base64 $x]
if {$bits >= 0} {
if {[llength [lappend nums $bits]] == 4} {
foreach {v w z y} $nums break
set a [expr {($v << 2) | ($w >> 4)}]
set b [expr {(($w & 0xF) << 4) | ($z >> 2)}]
set c [expr {(($z & 0x3) << 6) | $y}]
append output [binary format ccc $a $b $c]
set nums {}
}
} elseif {$bits == -1} {
# = indicates end of data.  Output whatever chars are left.
# The encoding algorithm dictates that we can only have 1 or 2
# padding characters.  If x=={}, we have 12 bits of input
# (enough for 1 8-bit output).  If x!={}, we have 18 bits of
# input (enough for 2 8-bit outputs).

foreach {v w z} $nums break
set a [expr {($v << 2) | (($w & 0x30) >> 4)}]

if {$z == {}} {
append output [binary format c $a ]
} else {
set b [expr {(($w & 0xF) << 4) | (($z & 0x3C) >> 2)}]
append output [binary format cc $a $b]
}
break
} else {
# RFC 2045 says that line breaks and other characters not part
# of the Base64 alphabet must be ignored, and that the decoder
# can optionally emit a warning or reject the message.  We opt
# not to do so, but to just ignore the character.
continue
}
}
return $output
}



package provide server::base64 1.0
