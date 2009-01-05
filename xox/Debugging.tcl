
package require XOTcl

namespace eval ::xox {

  Class Debugging

  Debugging parametercmd color
  Debugging parametercmd clear
  Debugging color "\x1B\[36;1m"
  Debugging clear "\x1B\[0m"

  Debugging # Debugging { Mixin that provides the debug method }

  Debugging # debug { 
      Print a short stack trace with a message.

  Debug prepends a short stack trace to a normal debugging message
  written by the user.  This is very useful in telling exactly
  where the debug statement was called and telling what class
  and method called the method where debug was called.  This
  is a two-level stacktrace.

  ::xounit::TestCase->runTest >> ::xox::test::TestObject->testHelpMethods

  }

  Debugging instproc debug { message } {

      set currentLevel [ self callinglevel ]

      if [ string match "#*" $currentLevel ] {

          set numberLevel [ string range $currentLevel 1 end ]
          incr numberLevel -1

          set class [ uplevel #$numberLevel ::xotcl::self class ]
          set method [ uplevel #$numberLevel ::xotcl::self proc ]

          puts "[ ::xox::Debugging color ]$class->$method >> [ self callingclass ]->[ self callingproc ]\n$message[ ::xox::Debugging clear ]"
          flush stdout

      } else {

          set class [ self callingclass ]
          set method [ self callingproc ]

          puts "[ ::xox::Debugging color ]$class->$method $message [::xox::Debugging clear ]"
          flush stdout
      }
  }

  Debugging # stackTrace { 
      Return the full stack trace.
  }

  Debugging instproc stackTrace { } {

      append buffer "\n"

      set currentLevel [ self callinglevel ]

      if [ string match "#*" $currentLevel ] {

          set numberLevel [ string range $currentLevel 1 end ]

      } else {
          return
      }

      for { set loop $numberLevel } { $loop >= 1 } { incr loop -1 } {

          set args ""
          set class [ uplevel #$loop ::xotcl::self class ]
          set method [ uplevel #$loop ::xotcl::self proc ]
          if [ Object isclass $class ] {
              catch {
              set args ""
              set args [ $class info instargs $method ]
              }
          }
          append buffer "#$loop. $class->$method \{$args\}"
          append buffer "\n"
      }

      return $buffer
  }

  Debugging instproc spy { name } {

      if [ my exists $name ] {
          puts "[ self ] $name [ my set $name ]"
      }  else {
          puts "[ self ] $name unset"
      }
  }

  Object instmixin add ::xox::Debugging
}


