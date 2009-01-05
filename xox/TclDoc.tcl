
namespace eval ::xox { 

Class create TclDoc -superclass { ::xotcl::Object }

TclDoc id {$Id: TclDoc.tcl,v 1.5 2008/03/13 08:12:02 bthomass Exp $}
  
TclDoc @doc TclDoc {
    TclDoc is a collection of documentation for Tcl procs.
    All of this documentation is borrowed from:
    http://www.tcl.tk/man/tcl8.4/TclCmd/contents.htm
}

TclDoc @doc break {

    Abort looping command.

    Example:

for {set x 0} {$x<10} {incr x} {
    if {$x > 5} {
        break
    }
    puts "x is $x"
}

}

TclDoc @doc after {

    Execute a command after a time delay.

    after ms 
    after ms ?script script script ...? 
    after cancel id 
    after cancel script script script ... 
    after idle ?script script script ...? 
    after info ?id?

    Example:
    
    proc sleep {N} {
           after [expr {int($N * 1000)}]
    }
}

TclDoc @doc append {

    Append to variable.

    append varName ?value value value ...?

    Example:

    set var 0
    for {set i 1} {$i<=10} {incr i} {
           append var "," $i
    }
    puts $var
    # Prints 0,1,2,3,4,5,6,7,8,9,10
}

TclDoc @doc array {

    Manipulate array variables.

    array anymore arrayName searchId 
    array donesearch arrayName searchId 
    array exists arrayName 
    array get arrayName ?pattern? 
    array names arrayName ?mode? ?pattern? 
    array nextelement arrayName searchId 
    array set arrayName list 
    array size arrayName 
    array startsearch arrayName 
    array statistics arrayName 
    array unset arrayName ?pattern? 

}

TclDoc @doc binary {

    Insert and extract fields from binary strings.

    binary format formatString ?arg arg ...? 
    binary scan string formatString ?varName varName ...?
}

TclDoc @doc catch {

    Evaluate script and trap exceptional returns.

    catch script ?varName?

    Example:

    if { [catch {open $someFile w} fid] } {
            puts stderr "Could not open $someFile for writing\n$fid"
                exit 1
    }
}

TclDoc @doc cd {
    
    Change working directory.

    cd ?dirName?

    Example:

    cd ~fred
}

TclDoc @doc clock {
    
    Obtain and manipulate time.

    clock clicks ?-milliseconds? 
    clock format clockValue ?-format string? ?-gmt boolean?
    clock scan dateString ?-base clockVal? ?-gmt boolean?
    clock seconds 
}

TclDoc @doc close {

    Close an open channel.
    
    close channelId

    Example:

    proc withOpenFile {filename channelVar script} {
        upvar 1 $channelVar chan
        set chan [open $filename]
        catch {
            uplevel 1 $script
        } result options
        close $chan
        return -options $options $result
    }
}

TclDoc @doc concat {

    Join lists together.

    concat ?arg arg ...?

    Example:

    concat a b {c d e} {f {g h}}
    returns:
    a b c d e f {g h}
    
}

TclDoc @doc continue {

    Skip to the next iteration of a loop.

    continue

    Example:

    for {set x 0} {$x<10} {incr x} {
        if {$x == 5} {
            continue
        }
        puts "x is $x"
    }
}

TclDoc @doc eof {

    Check for end of file condition on channel.

    eof channelId

    Example:

    set f [open somefile.txt]
    while {1} {
        set line [gets $f]
        if {[eof $f]} {
            close $f
            break
        }
    puts "Read line: $line"
    }

}

TclDoc @doc error {

    Generate an error.

    error message ?info? ?code?
    
    Example:

    if {1+2 != 3} {
            error "something is very wrong with addition"
    }
}

TclDoc @doc eval {

    Evaluate a Tcl script.

    eval arg ?arg ...?

    Example:

    proc lprepend {varName args} {
        upvar 1 $varName var
        # Ensure that the variable exists and contains a list
        lappend var
        # Now we insert all the arguments in one go
        set var [eval [list linsert $var 0] $args]
    }
}

TclDoc @doc exec {

    Invoke subprocesses.

    exec ?switches? arg ?arg ...?

    Example:

    exec uname -a
}

TclDoc @doc exit {

    End the application.

    exit ?returnCode?

    Example:

    exit
}

TclDoc @doc expr {

    Evaluate an expression.

    expr arg ?arg arg ...?

    Example:

    set randNum [expr { int(100 * rand()) }]
}

TclDoc @doc fblocked {

    Test whether the last input operation exhausted all available input.

    fblocked channelId
}

TclDoc @doc fconfigure {

    Set and get options on a channel.

    fconfigure channelId 
    fconfigure channelId name 
    fconfigure channelId name value ?name value ...?

    -blocking boolean 
    -buffering newValue 
    -buffersize newSize 
    -encoding name 
    -eofchar char 
    -eofchar {inChar outChar} 
    -translation mode 
    -translation {inMode outMode}
}

TclDoc @doc fcopy {

    Copy data from one channel to another.

    fcopy inchan outchan ?-size size? ?-command callback?

}

TclDoc @doc file {

    Manipulate file names and attributes.

    file atime name ?time? 
    file attributes name 
    file attributes name ?option? 
    file attributes name ?option value option value...? 
    file channels ?pattern? 
    file copy ?-force? ?- -? source target 
    file copy ?-force? ?- -? source ?source ...? targetDir 
    file delete ?-force? ?- -? pathname ?pathname ... ? 
    file dirname name 
    file executable name 
    file exists name 
    file extension name 
    file isdirectory name 
    file isfile name 
    file join name ?name ...? 
    file link ?-linktype? linkName ?target? 
    file lstat name varName 
    file mkdir dir ?dir ...? 
    file mtime name ?time? 
    file nativename name 
    file normalize name 
    file owned name 
    file pathtype name 
    file readable name 
    file readlink name 
    file rename ?-force? ?- -? source target 
    file rename ?-force? ?- -? source ?source ...? targetDir 
    file rootname name 
    file separator ?name? 
    file size name 
    file split name 
    file stat name varName 
    file system name 
    file tail name 
    file type name 
    file volumes 
    file writable name 

}

TclDoc @doc fileevent {

    Execute a script when a channel becomes readable or writable.

    fileevent channelId readable ?script?
    fileevent channelId writable ?script?

    Example:

    proc GetData {chan} {
        if {![eof $chan]} {
            puts [gets $chan]
        }
    }

    fileevent $chan readable [list GetData $chan]
}

TclDoc @doc flush {

    Flush buffered output for a channel.

    flush channelId

    Example:

    puts -nonewline "Please type your name: "
    flush stdout
    gets stdin name
    puts "Hello there, $name!"
}

TclDoc @doc for {

    For loop

    for start test next body

    Example:

    for {set x 0} {$x<10} {incr x} {
           puts "x is $x"
    }
}

TclDoc @doc foreach {

    Iterate over all elements in one or more lists.

    foreach varname list body
    foreach varlist1 list1 ?varlist2 list2 ...? body

    Example:

    set x {}
    foreach {i j} {a b c d e f} {
            lappend x $j $i
    }
    # The value of x is "b a d c f e"
    # There are 3 iterations of the loop.
}

TclDoc @doc format {

    Format a string in the style of sprintf.

    format formatString ?arg arg ...?
}

TclDoc @doc gets {

    Read a line from a channel.

    gets channelId ?varName?
    
    Example:

    set chan [open "some.file.txt"]
    set lineNumber 0
    while {[gets $chan line] >= 0} {
            puts "[incr lineNumber]: $line"
    }
    close $chan


}

TclDoc @doc glob {

    Return names of files that match patterns.

    glob ?switches? pattern ?pattern ...?

    Example:

    glob *.tcl

}

TclDoc @doc global {

    Access global variables.

    global varname ?varname ...?

    Example:

    proc reset {} {
        global a::x
        set x 0
    }
}

TclDoc @doc if {

    Execute scripts conditionally.

    if expr1 ?then? body1 elseif expr2 ?then? body2 elseif ... ?else? ?bodyN?

    Example:

    if {$vbl == 1} { puts "vbl is one" }
}

TclDoc @doc incr {

    Increment the value of a variable.

    incr varName ?increment?

    Example:

    incr x
}

TclDoc @doc info {

    Return information about the state of the Tcl interpreter.

    info args procname 
    info body procname 
    info cmdcount 
    info commands ?pattern? 
    info complete command 
    info default procname arg varname 
    info exists varName 
    info functions ?pattern? 
    info globals ?pattern? 
    info hostname 
    info level ?number? 
    info library 
    info loaded ?interp? 
    info locals ?pattern? 
    info nameofexecutable 
    info patchlevel 
    info procs ?pattern? 
    info script ?filename? 
    info sharedlibextension 
    info tclversion 
    info vars ?pattern? 

}

TclDoc @doc interp {

    Create and manipulate Tcl interpreters.

    interp alias srcPath srcToken 
    interp alias srcPath srcToken {} 
    interp alias srcPath srcCmd targetPath targetCmd ?arg arg ...? 
    interp aliases ?path? 
    interp create ?-safe? ?- -? ?path? 
    interp delete ?path ...? 
    interp eval path arg ?arg ...? 
    interp exists path 
    interp expose path hiddenName ?exposedCmdName? 
    interp hide path exposedCmdName ?hiddenCmdName? 
    interp hidden path 
    interp invokehidden path ?-global? hiddenCmdName ?arg ...? 
    interp issafe ?path? 
    interp marktrusted path 
    interp recursionlimit path ?newlimit? 
    interp share srcPath channelId destPath 
    interp slaves ?path? 
    interp target path alias 
    interp transfer srcPath channelId destPath 

}

TclDoc @doc join {

    Create a string by joining together list elements.

    join list ?joinString?

    Example:
    set data {1 2 3 4 5}
    join $data ", "
         => 1, 2, 3, 4, 5

}

TclDoc @doc lappend {

    Append list elements onto a variable.

    lappend varName ?value value value ...?

    Example:

    % set var 1
    1
    % lappend var 2
    1 2
    % lappend var 3 4 5
    1 2 3 4 5

}

TclDoc @doc lindex {

    Retrieve an element from a list.

    lindex list ?index...?

    Example:

    lindex {a b c}  => a b c
    lindex {a b c} {} => a b c
    lindex {a b c} 0 => a
    lindex {a b c} 2 => c
    lindex {a b c} end => c
    lindex {a b c} end-1 => b
    lindex {{a b c} {d e f} {g h i}} 2 1 => h
    lindex {{a b c} {d e f} {g h i}} {2 1} => h
    lindex {{{a b} {c d}} {{e f} {g h}}} 1 1 0 => g
    lindex {{{a b} {c d}} {{e f} {g h}}} {1 1 0} => g
}

TclDoc @doc list {

    Create a list.

    list ?arg arg ...?

    Example:

    list a b "c d e  " "  f {g h}"
    =>  a b {c d e  } {  f {g h}}
}

TclDoc @doc llength {

    Count the number of elements in a list.

    llength list

    Example:

    % llength {a b c d e}
    5
    % llength {a b c}
    3
    % llength {}
    0
}

TclDoc @doc lrange {

    Return one or more adjacent elements from a list.

    lrange list first last

    Example:

    % lrange {a b c d e} 0 1
    a b
}

TclDoc @doc lreplace {

    Replace elements in a list with new elements.

    lreplace list first last ?element element ...?

    Example:

    % lreplace {a b c d e} 1 1 foo
    a foo c d e
}

TclDoc @doc lsearch {

    See if a list contains a particular element.

    lsearch ?options? list pattern 
        -all 
        -ascii 
        -decreasing 
        -dictionary 
        -exact 
        -glob 
        -increasing 
        -inline 
        -integer 
        -not 
        -real 
        -regexp 
        -sorted 
        -start index 

    Example:

    lsearch {a b c d e} c => 2
    lsearch -all {a b c a b c} c => 2 5
    lsearch -inline {a20 b35 c47} b* => b35
    lsearch -inline -not {a20 b35 c47} b* => a20
    lsearch -all -inline -not {a20 b35 c47} b* => a20 c47
    lsearch -all -not {a20 b35 c47} b* => 0 2
    lsearch -start 3 {a b c a b c} c => 5
}

TclDoc @doc lset {

    Change an element in a list

    lset varName ?index...? newValue

    Example:

    set x [list [list a b c] [list d e f] [list g h i]]
      => {a b c} {d e f} {g h i}

    lset x {j k l} => j k l
    lset x {} {j k l} => j k l
    lset x 0 j => j {d e f} {g h i}
    lset x 2 j => {a b c} {d e f} j
    lset x end j => {a b c} {d e f} j
    lset x end-1 j => {a b c} j {g h i}
    lset x 2 1 j => {a b c} {d e f} {g j i}
    lset x {2 1} j => {a b c} {d e f} {g j i}
    lset x {2 3} j => list index out of range
}

TclDoc @doc lsort {

    Sort the elements of a list.

    lsort ?options? list 
        -ascii 
        -dictionary 
        -integer 
        -real 
        -command command 
        -increasing 
        -decreasing 
        -index index 
        -unique 

   Example:

   % lsort {a10 B2 b1 a1 a2}
   B2 a1 a10 a2 b1

}

TclDoc @doc namespace {

    Create and manipulate contexts for commands and variables.

    namespace children ?namespace? ?pattern? 
    namespace code script 
    namespace current 
    namespace delete ?namespace namespace ...? 
    namespace eval namespace arg ?arg ...? 
    namespace exists namespace 
    namespace export ?-clear? ?pattern pattern ...? 
    namespace forget ?pattern pattern ...? 
    namespace import ?-force? ?pattern pattern ...? 
    namespace inscope namespace script ?arg ...? 
    namespace origin command 
    namespace parent ?namespace? 
    namespace qualifiers string 
    namespace tail string 
    namespace which ?-command? ?-variable? name 

}

TclDoc @doc open {

    Open a file-based or command pipeline channel.

    open fileName 
    open fileName access 
    open fileName access permissions 

    Example:

    set fl [open "| ls this_file_does_not_exist"]
    set data [read $fl]
    if {[catch {close $fl} err]} {
            puts "ls command failed: $err"
    }
}

TclDoc @doc package {

    Facilities for package loading and version control.

    package forget ?package package ...? 
    package ifneeded package version ?script? 
    package names 
    package present ?-exact? package ?version? 
    package provide package ?version? 
    package require ?-exact? package ?version? 
    package unknown ?command? 
    package vcompare version1 version2 
    package versions package 
    package vsatisfies version1 version2 
}

TclDoc @doc pid {

    Retrieve process identifiers.

    pid ?fileId?
}

TclDoc @doc proc {

    Create a Tcl procedure.

    proc name args body

    Example:

    proc printArguments args {
       foreach arg $args {
         puts $arg
       }
    }
}

TclDoc @doc puts {

    Write to a channel.

    puts ?-nonewline? ?channelId? string

    Example:

    puts "Hello, World!"
}

TclDoc @doc pwd {

    Return the absolute path of the current working directory.

    pwd
}

TclDoc @doc read {

    Read from a channel.

    read ?-nonewline? channelId 
    read channelId numChars 

    Example:

    set fl [open /proc/meminfo]
    set data [read $fl]
    close $fl
    set lines [split $data \n]

}

TclDoc @doc regexp {

    Match a regular expression against a string.

    regexp ?switches? exp string ?matchVar? ?subMatchVar subMatchVar ...?
        -about 
        -expanded 
        -indices 
        -line 
        -linestop 
        -lineanchor 
        -nocase 
        -all 
        -inline 
        -start index 
        - - 
}

TclDoc @doc regsub {

    Perform substitutions based on regular expression pattern matching.

    regsub ?switches? exp string subSpec ?varName?
        -all 
        -expanded 
        -line 
        -linestop 
        -lineanchor 
        -nocase 
        -start index 
        -- 

}

TclDoc @doc rename {

    Rename or delete a command.

    rename oldName newName

    Example:

    rename ::source ::theRealSource
    set sourceCount 0
    proc ::source args {
        global sourceCount
        puts "called source for the [incr sourceCount]'th time"
        uplevel 1 ::theRealSource $args
    }
}

TclDoc @doc return {

    Return from a procedure.

    return ?-code code? ?-errorinfo info? ?-errorcode code? ?string?

    Return codes:
    ok (or 0) 
    error (1) 
    return (2) 
    break (3) 
    continue (4) 

    Example:

    proc myBreak {} {
           return -code break
    }

}

TclDoc @doc scan {

    Parse string using conversion specifiers in the style of sscanf.

    scan string format ?varName varName ...?

    Example:

    set string "#08D03F"
    scan $string "#%2x%2x%2x" r g b
}

TclDoc @doc seek {

    Change the access position for an open channel

    seek channelId offset ?origin?

    Example:

    set f [open file.txt]
    set data1 [read $f]
    seek $f 0
    set data2 [read $f]
    close $f
# $data1 == $data2 if the file wasn't updated

}

TclDoc @doc set {

    Read and write variables.
    
    set varName ?value?

    Example:

    set r [expr rand()]

}

TclDoc @doc socket {

    Open a TCP network connection.

    socket ?options? host port 
    socket -server command ?options? port 

    Example:

    Here is a very simple time server:

    proc Server {channel clientaddr clientport} {
           puts "Connection from $clientaddr registered"
              puts $channel [clock format [clock seconds]]
                 close $channel
    }

    socket -server Server 9900
    vwait forever

    And here is the corresponding client to talk to the server:

    set server localhost
    set sockChan [socket $server 9900]
    gets $sockChan line
    close $sockChan
    puts "The time on $server is $line"

}

TclDoc @doc source {

    Evaluate a file or resource as a Tcl script.

    source fileName
    source -rsrc resourceName ?fileName?
    source -rsrcid resourceId ?fileName?

    Example:

    source foo.tcl
    source bar.tcl

}

TclDoc @doc split {

    Split a string into a proper Tcl list.

    split string ?splitChars?

    Example:

    split "comp.lang.tcl.announce" .
         => comp lang tcl announce

}

TclDoc @doc subst {

    Perform backslash, command, and variable substitutions.

    subst ?-nobackslashes? ?-nocommands? ?-novariables? string

    Example:

    set a 44
    subst {xyz {$a}}
        => {xyz {44}}

}

TclDoc @doc switch {

    Evaluate one of several scripts, depending on a given value.

    switch ?options? string pattern body ?pattern body ...? 
    switch ?options? string {pattern body ?pattern body ...?}

    Example:

    switch -glob aaab {
        a*b     -
        b       {expr 1}
        a*      {expr 2}
        default {expr 3}
    }
}

TclDoc @doc tell {

    Return current access position for an open channel.

    tell channelId
}

TclDoc @doc time {

    Time the execution of a script.

    time script ?count?

    Example:
    time {
        for {set i 0} {$i<1000} {incr i} {
            # empty body
        }
    }

}

TclDoc @doc trace {

    Monitor variable accesses, command usages and command executions.

    See: http://www.tcl.tk/man/tcl8.4/TclCmd/trace.htm
}

TclDoc @doc unknown {

    Handle attempts to use non-existent commands.

    DO NOT USE!
}

TclDoc @doc unset {

    Delete variables.

    unset ?-nocomplain? ?--? ?name name name ...?

    Example:

    set a 5
    unset a


}

TclDoc @doc update {

    Process pending events and idle callbacks.

    update ?idletasks?

}

TclDoc @doc uplevel {

    Execute a script in a different stack frame.

    uplevel ?level? arg ?arg ...?

    USE WITH CAUTION
}

TclDoc @doc upvar {

    Create link to variable in a different stack frame.

    upvar ?level? otherVar myVar ?otherVar myVar ...?

    USE WITH CAUTION
}

TclDoc @doc variable {

    Create and initialize a namespace variable.

    variable ?name value...? name ?value?

    Example:

    namespace eval foo {
            variable bar 12345
    }

    namespace eval foo {
        proc spong {} {
            # Variable in this namespace
            variable bar
            puts "bar is $bar"
        }
    }
}

TclDoc @doc vwait {

    Process events until a variable is written.

    vwait varName
}

TclDoc @doc while {

    Execute script repeatedly as long as a condition is met.

    while test body

    Example:

    set lineCount 0
    while {[gets $chan line] >= 0} {
            puts "[incr lineCount]: $line"
    }
}


}


