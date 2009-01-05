# Created at Sat Jan 12 16:13:45 EST 2008 by bthomass

namespace eval ::xointerp {

    Class TestableScheduler -superclass ::xointerp::Scheduler

    TestableScheduler # TestableScheduler {

        Please describe the class TestableScheduler here.
    }

    TestableScheduler parameter {
        { callBackCounter 0 }
        { scheduleCounter 0 }
        { maxSteps -1 }
        { step 0 }
    }

    TestableScheduler instproc callBack { interpreter } {

        my instvar callBackCounter 

        my checkStep 

        incr callBackCounter

        set thisCallBack $callBackCounter

        puts "callBack start $thisCallBack"
        set return [ next ]
        puts "callBack end  $thisCallBack"
        return $return
    }

    TestableScheduler instproc checkStep { } {

        my instvar maxSteps step

        incr step

        puts "Step: $step"

        if { $maxSteps > 0 } {
            if { $step > $maxSteps } {
                error "max steps"
            }
        }
    }

    TestableScheduler instproc schedule { } {

        my instvar scheduleCounter 

        my checkStep 

        incr scheduleCounter

        set thisSchedule $scheduleCounter
       
        puts "schedule start $thisSchedule"
        set return [ next ]
        puts "schedule end  $thisSchedule"
        return $return
    }
}


