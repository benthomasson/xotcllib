# Created at Fri Sep 26 16:13:59 EDT 2008 by bthomass

namespace eval ::xoide {

    Class ObjectPopup -superclass ::xoide::PopupMenu

    ObjectPopup @doc ObjectPopup {

        Please describe the class ObjectPopup here.
    }

    ObjectPopup parameter {
        object
    }

    ObjectPopup instproc init {  } {

        my instvar popupMenu object

        if {![ Object isobject $object ]} { return }

        next

        set inspectMenu [ my addPopupMenu Inspect ]
        set childrenMenu [ my addPopupMenu Children ]
        set assertMenu [ my addPopupMenu Assert ]
        set testMenu [ my addPopupMenu Test ]
        set actionMenu [ my addPopupMenu Action ]
        set methodMenu [ my addPopupMenu Method ]

        $inspectMenu add command -label "?" -command "[ self ] insertRunCommand {$object ? $object}"

        foreach var [ lsort -dictionary [ $object info vars ] ] {

            catch {
                $inspectMenu add command -label "$var" -command "[ self ] insertEdit {${object} set $var}"
                set methodsUsed($var) 1
            }
        }

        foreach child [ lsort -dictionary [ $object info children ] ] {

            catch {
                $childrenMenu add command -label "$child" -command "[ self ] insertEdit $child"
            }
        }

        foreach method [ lsort -dictionary [ $object info methods assert* ]  ] {

            catch {
                $assertMenu add command -label "$method" -command "[ self ] insertMethod $object $method"
                set methodsUsed($method) 1
            }
        }

        foreach method [ lsort -dictionary [ $object info methods test* ]  ] {

            catch {
                $testMenu add command -label "$method" -command "[ self ] insertMethod $object $method"
                set methodsUsed($method) 1
            }
        }

        foreach method [ lsort -dictionary [ $object info methods ]  ] {

            catch {
                set class [ ::xox::ObjectGraph findFirstImplementationClass $object $method ]
                if { [ $class info instargs $method ] != "" } { continue }
                $actionMenu add command -label "$method" -command "[ self ] insertMethod $object $method"
                set methodsUsed($method) 1
            } 
        }

        foreach method [ lsort -dictionary [ $object info methods ]  ] {

            if [ info exists methodsUsed($method) ] { continue }

            catch {
                $methodMenu add command -label "$method" -command "[ self ] insertMethod $object $method"
            }
        }
    }

    ObjectPopup instproc insertEdit { script } {

    }

    ObjectPopup instproc insertRunCommand { script } {

    }

    ObjectPopup instproc insertMethod { object method } {

    }

}


