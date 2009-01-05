
package require XOTcl

namespace eval ::xox {

  Object create Profiler

  Profiler proc clear { } {
      
      catch { my unset profileCount }
      catch { my unset profileTime }
      catch { my unset profileTotalTime }
  }

  Profiler proc add { className } {
    $className instfilter [ concat [ $className info filter ] profileFilter ]
  }

  Profiler proc remove { className } {
    catch { $className instfilter delete profileFilter  }
  }

  Profiler proc recordProfile { class method } {

      if { ! [ my exists "profileCount($class $method)" ] } {

          my set "profileCount($class $method)" 1
          return
      }

      my incr "profileCount($class $method)"
  }

  Profiler proc recordProfileTime { class method time } {

      if { ! [ my exists "profileTime($class $method)" ] } {

          my set "profileTime($class $method)" $time
          my set "profileTotalTime($class $method)" $time
          return
      }

      my incr "profileTotalTime($class $method)" $time

      set lastTime [ my set "profileTime($class $method)" ]
      my set "profileTime($class $method)" [ expr { int(ceil(($lastTime+$time)/2)) } ]
  }

  Profiler proc getProfile { class method } {

      if { ! [ my hasProfile $class $method ] } { return 0 }
      return [ my set "profileCount($class $method)" ]
  }

  Profiler proc hasProfile { class method } {

      return [ my exists "profileCount($class $method)" ]
  }

  Profiler proc printReport { { depth 50 } } {

      my printReportTotalTime $depth
      my printReportTime $depth
      my printReportCount $depth
  }

  Profiler proc printReportCount { depth } {

      puts "\n\n::xox::Profiler Count Report"
      puts "=========================================\n"

      foreach classMethod [ my array names profileCount ] {

          set count [ my set profileCount($classMethod) ]
          lappend reverseArray($count) $classMethod
      }

      foreach count [ lrange [ lsort -integer [ array names reverseArray ] ] end-$depth end  ] {

          foreach classMethod $reverseArray($count) {

              puts "$count: $classMethod"
          }
      }
  }

  Profiler proc printReportTotalTime { depth } {

      puts "\n\n::xox::Profiler Total Time Report"
      puts "=========================================\n"

      foreach classMethod [ my array names profileTotalTime ] {

          set count [ my set profileTotalTime($classMethod) ]
          lappend reverseArray($count) $classMethod
      }

      foreach count [ lrange [ lsort -integer [ array names reverseArray ] ] end-$depth end  ] {

          foreach classMethod $reverseArray($count) {

              puts "$count ms: $classMethod"
          }
      }
  }

  Profiler proc printReportTime { depth } {

      puts "\n\n::xox::Profiler Time Report"
      puts "=========================================\n"

      foreach classMethod [ my array names profileTime ] {

          set count [ my set profileTime($classMethod) ]
          lappend reverseArray($count) $classMethod
      }

      foreach count [ lrange [ lsort -integer [ array names reverseArray ] ] end-$depth end  ] {

          foreach classMethod $reverseArray($count) {

              puts "$count ms: $classMethod"
          }
      }
  }

  Object instproc profileFilter  { args } {

    # don't profile the Profiler object
    if { [ string equal [self] ::xox::Profiler ] } { return [ next ] }
    set class [ self calledclass ]
    if { [ string equal $class ::xotcl::Object ] } { return [ next ] }
    set method [ self calledproc ]
    ::xox::Profiler recordProfile $class $method
    set start [ clock clicks -milliseconds ]
    set return [ next ]
    set end [ clock clicks -milliseconds ]
    set time [ expr { $end - $start } ]
    ::xox::Profiler recordProfileTime $class $method $time
    return $return
  }
}


