package provide xox::test::TestLogger 1.0

package require XOTcl
package require xox
package require xounit

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    Class TestLogger -superclass ::xounit::TestCase

    TestLogger instproc tearDown {} {

        ::xox::logger setLogLevel critical
        catch { ::xox::logger unset logClasses }
        ::xox::logger useColor 1
    }

    TestLogger instproc testExists {} {

        my assertObject ::xox::logger

        my assert [ Object isclass ::xox::LogDebug ]
        my assert [ Object isclass ::xox::LogInfo ]
        my assert [ Object isclass ::xox::LogNotice ]
        my assert [ Object isclass ::xox::LogWarn ]
        my assert [ Object isclass ::xox::LogError ]
        my assert [ Object isclass ::xox::LogCritical ]

        my assert [ Object isobject ::xox::log::debug ]
        my assert [ Object isobject ::xox::log::info ]
        my assert [ Object isobject ::xox::log::notice ]
        my assert [ Object isobject ::xox::log::warn ]
        my assert [ Object isobject ::xox::log::error ]
        my assert [ Object isobject ::xox::log::critical ]
    }

    TestLogger instproc testSetLogLevel { } {

        ::xox::logger setLogLevel debug
        my assertEquals [ ::xox::logger logLevel ] ::xox::LogDebug
        ::xox::logger setLogLevel info
        my assertEquals [ ::xox::logger logLevel ] ::xox::LogInfo
        ::xox::logger setLogLevel notice
        my assertEquals [ ::xox::logger logLevel ] ::xox::LogNotice
        ::xox::logger setLogLevel warn
        my assertEquals [ ::xox::logger logLevel ] ::xox::LogWarn
        ::xox::logger setLogLevel error
        my assertEquals [ ::xox::logger logLevel ] ::xox::LogError
        ::xox::logger setLogLevel critical
        my assertEquals [ ::xox::logger logLevel ] ::xox::LogCritical
    }

    TestLogger instproc testSetLogClass { } {

        ::xox::logger addLogClass ::xotcl::Object
        my assertEquals [ ::xox::logger logClasses ] ::xotcl::Object
    }

    TestLogger instproc testLevelHierachy { } {

        my assert [ ::xox::log::critical hasclass ::xox::LogCritical ]
        my assert [ ::xox::log::critical hasclass ::xox::LogDebug ]
        my assertFalse [ ::xox::log::error hasclass ::xox::LogCritical ]
        my assert [ ::xox::log::error hasclass ::xox::LogError ]
        my assert [ ::xox::log::error hasclass ::xox::LogDebug ]
        my assert [ ::xox::log::warn hasclass ::xox::LogWarn ]
        my assert [ ::xox::log::warn hasclass ::xox::LogDebug ]
        my assert [ ::xox::log::notice hasclass ::xox::LogNotice ]
        my assert [ ::xox::log::notice hasclass ::xox::LogDebug ]
        my assert [ ::xox::log::info hasclass ::xox::LogInfo ]
        my assert [ ::xox::log::info hasclass ::xox::LogDebug ]
        my assert [ ::xox::log::debug hasclass ::xox::LogDebug ]
    }

    TestLogger instproc testCheckLogClass { } {

        ::xox::logger addLogClass ::xotcl::Object

        set o [ ::xotcl::Object new ]
        set t [ ::xounit::Test new ]

        my assert [ $o hasclass [ ::xox::logger logClasses ] ]
        my assert [ $t hasclass [ ::xox::logger logClasses ] ]

        ::xox::logger addLogClass ::xounit::Test

        my assertFalse [ $o hasclass [ ::xox::logger logClasses ] ]
        my assert [ $t hasclass [ ::xox::logger logClasses ] ]
    }

    TestLogger instproc testCheckLogClass { } {

        ::xox::logger setLogLevel debug

        set level debug
        set level "::xox::log::${level}"

        my assert [ $level hasclass [ ::xox::logger logLevel ] ]

        set level critical
        set level "::xox::log::${level}"

        my assert [ $level hasclass [ ::xox::logger logLevel ] ]

        ::xox::logger setLogLevel warn

        set level critical
        set level "::xox::log::${level}"
        my assert [ $level hasclass [ ::xox::logger logLevel ] ]

        set level debug
        set level "::xox::log::${level}"
        my assertFalse [ $level hasclass [ ::xox::logger logLevel ] ]
    }

    TestLogger instproc testLog { } {

        ::xox::logger addLogClass ::xotcl::Object
        ::xox::logger setLogLevel debug

        set o [ ::xotcl::Object new ]

        ::xox::logger log $o ::xotcl::Object something debug hey
    }

    TestLogger instproc testLogging { } {

        ::xox::logger addLogClass ::xotcl::Object
        ::xox::logger setLogLevel debug

        set o [ ::xotcl::Object new ]
        $o mixin ::xox::Logging

        $o log debug hey
        $o log info hi
        $o log notice log
        $o log warn "oh no!"
        $o log error "argg!"
        $o log critical "im dead"

        ::xox::logger setLogLevel warn

        $o log debug debug
        $o log info info
        $o log notice notice
        $o log warn warn
        $o log error error
        $o log critical critical
    }

    TestLogger instproc testLoggingNoColor { } {

        ::xox::logger addLogClass ::xotcl::Object
        ::xox::logger setLogLevel debug
        ::xox::logger nocolor

        set o [ ::xotcl::Object new ]
        $o mixin ::xox::Logging

        $o log debug hey
        $o log info hi
        $o log notice log
        $o log warn "oh no!"
        $o log error "argg!"
        $o log critical "im dead"

        ::xox::logger setLogLevel warn

        $o log debug debug
        $o log info info
        $o log notice notice
        $o log warn warn
        $o log error error
        $o log critical critical
    }

    TestLogger instproc testLogging2 { } {

        ::xox::logger addLogClass ::xotcl::Object
        ::xox::logger setLogLevel debug

        set o [ ::xox::Logging new ]

        $o log debug hey
        $o log info hi
        $o log notice log
        $o log warn "oh no!"
        $o log error "argg!"
        $o log critical "im dead"

        ::xox::logger setLogLevel warn

        $o log debug debug
        $o log info info
        $o log notice notice
        $o log warn warn
        $o log error error
        $o log critical critical
    }

    TestLogger instproc notestLoggingAndTracing { } {

        Class ::xox::test::LoggerTestClass

        set o [ ::xox::test::LoggerTestClass new ]
        $o mixin ::xox::Logging

        ::xox::logger addLogClass ::xotcl::Object
        ::xox::logger setLogLevel debug
        ::xox::Trace add ::xox::test::LoggerTestClass

        $o set a 5
        $o log debug hey

        ::xox::Trace remove ::xotcl::Object
    }

    TestLogger instproc notestScaleObject { } {

        set o [ ::xotcl::Object new ]

        #::xox::logger addLogClass ::xotcl::Object
        #::xox::logger setLogLevel debug
        #$o mixin ::xox::Logging


        set start [ clock clicks -milliseconds ]
        for { set loop 0 } { $loop < 1000000 } { incr loop } {

            $o set a 5
        }
        set end [ clock clicks -milliseconds ]

        set time [ expr { $end - $start } ]

        my assert [ expr { $time < 2000 } ] "$time"
    }

    TestLogger instproc notestScaleMixin { } {

        set o [ ::xotcl::Object new ]

        ::xox::logger addLogClass ::xotcl::Object
        ::xox::logger setLogLevel debug
        $o mixin ::xox::Logging

        set start [ clock clicks -milliseconds ]
        for { set loop 0 } { $loop < 1000000 } { incr loop } {

            $o set a 5
        }
        set end [ clock clicks -milliseconds ]

        set time [ expr { $end - $start } ]

        my assert [ expr { $time < 2000 } ] "$time"
    }

    TestLogger instproc notestScaleNoLog { } {

        set o [ ::xotcl::Object new ]

        #::xox::logger addLogClass ::xotcl::Object
        #::xox::logger setLogLevel debug
        $o mixin ::xox::Logging

        set start [ clock clicks -milliseconds ]
        for { set loop 0 } { $loop < 1000000 } { incr loop } {

            $o log debug hey
        }
        set end [ clock clicks -milliseconds ]

        set time [ expr { $end - $start } ]

        #assert less than 20 micro seconds
        #for turned off
        my assert [ expr { $time < 20000 } ] "Too slow: $time"
    }

    TestLogger instproc notestScaleWrongClass { } {

        set o [ ::xotcl::Object new ]

        ::xox::logger addLogClass ::xounit::Test
        #::xox::logger setLogLevel debug
        $o mixin ::xox::Logging

        set start [ clock clicks -milliseconds ]
        for { set loop 0 } { $loop < 1000000 } { incr loop } {

            $o log debug hey
        }
        set end [ clock clicks -milliseconds ]

        set time [ expr { $end - $start } ]

        #assert less than 20 micro seconds
        #for turned off
        my assert [ expr { $time < 20000 } ] "Too slow: $time"
    }

    TestLogger instproc notestScaleWrongLevel { } {

        set o [ ::xotcl::Object new ]

        ::xox::logger addLogClass ::xotcl::Object
        ::xox::logger setLogLevel warn
        $o mixin ::xox::Logging

        set start [ clock clicks -milliseconds ]
        for { set loop 0 } { $loop < 1000000 } { incr loop } {

            $o log debug hey
        }
        set end [ clock clicks -milliseconds ]

        set time [ expr { $end - $start } ]

        #assert less than 20 micro seconds
        #for turned off
        my assert [ expr { $time < 20000 } ] "Too slow: $time"
    }

    TestLogger instproc testProcLog { } {

        ::xox::logger addLogClass ::xotcl::Object
        ::xox::logger setLogLevel info

        ::xox::log info hey
    }
}

