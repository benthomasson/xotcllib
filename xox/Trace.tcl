
package require XOTcl

namespace eval ::xox {

  Object create Trace
  Trace set traceStream stdout

  Trace proc openTraceFile { name } {
    my set traceStream [open $name w]
  }

  Trace proc puts { line } {
    puts $::xox::Trace::traceStream $line
  }

  Trace proc add { className } {
    $className instfilter [ concat [ $className info filter ] traceFilter]
  }

  Trace proc remove { className } {
    catch { $className instfilter delete traceFilter }
  }


  Object instproc traceFilter { args } {
    # don't trace the Trace object
    if {[string equal [self] ::xox::Trace ]} {return [next]}
    if {[string equal [self] ::xox::Logger ]} {return [next]}
    if {[string equal [self calledproc ] log ]} {return [next]}
    set context "[ self callingclass ]->[ self callingproc ]"
    set method [ self calledproc ]
    switch -- $method {
      proc -
      instproc {::set dargs [list [lindex $args 0] [lindex $args 1] ...] }
      default  {::set dargs $args }
    }
    ::xox::Trace::puts "CALL $context> [self]\([ self calledclass ]\)->$method $dargs"
    set result [next]
    ::xox::Trace::puts "EXIT $context> [self]\([ self calledclass ]\)->$method ($result)"
    return $result
  }

}


