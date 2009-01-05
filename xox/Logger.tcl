
package require XOTcl

namespace eval ::xox::log {

}

namespace eval ::xox {

  Class Logger

  Logger @doc Logger {

      Logger handles calls to log.
  }

  Logger parameter {
      { logLevel ::xox::LogError }
      { logClasses }
      { logStream stdout }
      { useColor 1 }
  }

  Logger instproc nocolor { } {

      my useColor 0
  }

  Logger instproc setLogLevel { level } {

      set logLevel "::xox::Log[string totitle $level]"

      if [ my isclass $logLevel ] {
          my logLevel $logLevel
      } else {
          error "Invalid log level: $level\nPlease choose one of: debug, info, notice, warn, error, critical.\n"
      }
  }

  Logger instproc addLogClass { class } {

      my lappend logClasses $class
  }

  Logger instproc log { object class method level message { type log } } {

      my instvar logLevel logClasses logStream

      set checkLevel "::xox::log::${level}"

      if { ! [ my isobject $checkLevel ] } { 

          error "Invalid log level: $level\nPlease choose one of: debug, info, notice, warn, error, critical.\n"
      }

      if [ my isobject $object ] {
          if { ! [ my exists logClasses ] } { return }
          set foundClass 0
              foreach logClass [ my logClasses ] {
                  if [ $object hasclass $logClass ] { set foundClass 1 }
              }
          if { ! $foundClass } { return }
      }
      if { ! [ $checkLevel hasclass $logLevel ] } { return }

      my writeLog $checkLevel $class $method $level $message $type
  }

  Logger instproc writeLog { checkLevel class method level message { type log } } {

      my instvar logLevel logClasses logStream

      if [ my useColor ] {
          set color [ $checkLevel color ]
      } else {
          set color ""
      }

      if { "$type" == "log" } {

      puts $logStream "$color\[$level\] $class $method $message\x1B\[0m"

      } else {

      puts $logStream "$color\[$level\] $class $method $message\x1B\[0m"

      }
  }

  Logger create ::xox::logger

  ::xox::logger @doc {

      The default logger for handling log calls.
  }

  Class Logging

  Logging # Logging {

      Mixin that gives classes access to the logging facility via
      my log $level $message
  }

  Logging # log {

      The logging facility.  The level may be one of 
      debug, info, notice, warn, error, or critical.
  }

  Logging instproc log { level message { type log } } {

      set class [ self callingclass ]
      set method [ self callingproc ]
      set object [ self callingobject ]

      ::xox::logger log $object $class $method $level $message $type
  }

  Class LoggingLevel

  LoggingLevel # LoggingLevel {

      The subclasses of LoggingLevel determine the color of
      the logging message.
  }

  LoggingLevel # color { the color of the logging message }

  LoggingLevel parameter {
      color
  }
  Class LogDebug     -superclass ::xox::LoggingLevel
  LogDebug # LogDebug { The logging level for debugging messages }
  LogDebug create ::xox::log::debug
  #green
  ::xox::log::debug color "\x1B\[32;1m"
  Class LogInfo      -superclass ::xox::LogDebug
  LogInfo # LogInfo { The logging level for information messages }
  LogInfo create ::xox::log::info
  #cyan
  ::xox::log::info color "\x1B\[36;1m"
  Class LogNotice    -superclass ::xox::LogInfo
  LogNotice # LogNotice { The logging level for notices }
  LogNotice create ::xox::log::notice
  #magnenta
  ::xox::log::notice color "\x1B\[35;1m"
  Class LogWarn      -superclass ::xox::LogNotice
  LogWarn # LogWarn { The logging level for warnings }
  LogWarn create ::xox::log::warn
  #blue
  ::xox::log::warn color "\x1B\[34;1m"
  Class LogError     -superclass ::xox::LogWarn
  LogError # LogError { The logging level for errors }
  LogError create ::xox::log::error
  #yellow
  ::xox::log::error color "\x1B\[33;1m"
  Class LogCritical  -superclass ::xox::LogError
  LogCritical # LogCritical { The logging level for critical errors }
  LogCritical create ::xox::log::critical
  #red
  ::xox::log::critical color "\x1B\[31;1m"
}


