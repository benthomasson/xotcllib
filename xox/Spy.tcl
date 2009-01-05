
package require XOTcl

namespace eval ::xox {

  Object create Spy

  Spy proc countAllInstances { } {

        set classes [ ::xox::ObjectGraph findAllInstances ::xotcl::Class ]

        foreach class $classes {

            set objects [ ::xox::ObjectGraph findAllInstances $class ] 
            set length [ llength $objects ]
            if { $length < 10 } { continue }

            lappend numberObjects($length) $class 
        }

        foreach number [ lsort -integer [ array names numberObjects ] ] {


            set class $numberObjects($number)
            puts "$number - $numberObjects($number)"
        }
  }

  Spy proc countInstances { } {

        set classes [ ::xox::ObjectGraph findAllInstances ::xotcl::Class ]

        foreach class $classes {

            set objects [ $class info instances ]
            set length [ llength $objects ]
            if { $length < 10 } { continue }

            lappend numberObjects($length) $class 
        }

        foreach number [ lsort -integer [ array names numberObjects ] ] {

            set class $numberObjects($number)
            puts "$number - $numberObjects($number)"
        }
  }
}


