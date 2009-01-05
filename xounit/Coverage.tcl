#Created at Thu Jul 05 13:52:05 -0400 2007 by ben using ::xox::Template

namespace eval ::xounit { 

    Object create Coverage 
          
    Coverage # Coverage {
        Please describe Coverage here.
    }
          
    Coverage set record 0   
    
    Coverage # add { 
        Add does ...
            className -
    }
        
    Coverage proc add { className } {
        $className instfilter [concat [$className info instfilter] coverageFilter ]
      my lappend classes $className
    }
        
    
    Coverage # clear { 
        Clear does ...
    }
        
    Coverage proc clear {  } {
        catch { my unset coverageCount }
      if [ my exists classes ] {
      foreach class [ my set classes ] {

          catch { $class instfilter delete coverageFilter }
      }
      }
      catch { my unset classes}
    }
        
    
    Coverage # getCoverage { 
        GetCoverage does ...
            class - 
            method -
    }
        
    Coverage proc getCoverage { class method } {
        if { ! [ my hasCoverage $class $method ] } { return 0 }

      return [ my set "coverageCount($class $method)" ]
    }
        
    
    Coverage # hasCoverage { 
        HasCoverage does ...
            class - 
            method -
    }
        
    Coverage proc hasCoverage { class method } {
        return [ my exists "coverageCount($class $method)" ]
    }
        
    
    Coverage # isWatching { 
        IsWatching does ...
            class -
    }
        
    Coverage proc isWatching { class } {
        if { ! [ my exists classes ] } { return 0 }

      puts "$class in [ my set classes ]"

      return [ expr { [ lsearch [ my set classes ] $class ] != -1 } ]
    }
        
    
    Coverage # recordCoverage { 
        RecordCoverage does ...
            class - 
            method -
    }
        
    Coverage proc recordCoverage { class method } {
        #puts "recordCoverage $class $method"

      if { ![ my set record ] } { return }
      
      if { ! [ my exists "coverageCount($class $method)" ] } {

          my set "coverageCount($class $method)" 1
          return
      }

      my incr "coverageCount($class $method)"
    }
        
    
    Coverage # start { 
        Start does ...
    }
        
    Coverage proc start {  } {
        my set record 1
    }
        
    
    Coverage # stop { 
        Stop does ...
    }
        
    Coverage proc stop {  } {
        my set record 0
    }
}


        
