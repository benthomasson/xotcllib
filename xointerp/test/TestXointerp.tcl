# Created at Sun Feb 10 19:46:54 EST 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestXointerp -superclass ::xounit::TestCase

    TestXointerp parameter {

    }

    TestXointerp instproc testLevel { } {

        set a 5

        set level [ info level ]

        ::xointerp::if2 1 { 
            incr a
            set newLevel [ info level ]
        }
        
        my assertEquals $a 6
        my assertEquals $level $newLevel
    }

    TestXointerp instproc testReturn { } {

        set a 5

        set return [ ::xointerp::if2 1 { 
            incr a
        } ]
        
        my assertEquals $a 6
        my assertEquals $return 6

        set return [ ::xointerp::if2 0 {
            incr a
        } ]

        my assertEquals $return ""
    }

    TestXointerp instproc testConditionVariable { } {

        set a 5
        set b 1

        set return [ ::xointerp::if2 $b { 
            incr a
        } ]
        
        my assertEquals $a 6
        my assertEquals $return 6
        
        set b 0

        set return [ ::xointerp::if2 { $b } {
            incr a
        } ]

        my assertEquals $return ""
    }

    TestXointerp instproc b { value } {

        return $value
    }

    TestXointerp instproc testConditionCall { } {

        set a 5
        set b 1

        set return [ ::xointerp::if2 [ my b 1 ] { 
            incr a
        } ]
        
        my assertEquals $a 6
        my assertEquals $return 6
        
        set b 0

        set return [ ::xointerp::if2 { [ my b 0 ] } {
            incr a
        } ]

        my assertEquals $return ""
    }

    TestXointerp instproc testBodyCall { } {

        set a 5
        set b 1

        set return [ ::xointerp::if2 [ my b 1 ] { 
            my b 6
        } ]
        
        my assertEquals $a 5
        my assertEquals $return 6
        
        set b 0

        set return [ ::xointerp::if2 { [ my b 0 ] } {
            my b 5
        } ]

        my assertEquals $return ""
    }
}


