
namespace eval ::xotcl {

  Object instproc coverageFilter { args } {

    # don't trace the Coverage object
    if { [ string equal [self] ::xounit::Coverage ] } { 
        return [ next ]
    }
    set class [ self calledclass ]
    set method [ self calledproc ]
    ::xounit::Coverage recordCoverage $class $method
    return [ next ]
  }

}

