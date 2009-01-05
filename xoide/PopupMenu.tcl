# Created at Fri Sep 26 16:06:12 EDT 2008 by bthomass

namespace eval ::xoide {

    Class PopupMenu -superclass ::xoide::TkObject

    PopupMenu @doc PopupMenu {

        Please describe the class PopupMenu here.
    }

    PopupMenu parameter {
        popupMenu
        popupIndex 
    }

    PopupMenu instproc init { } {

        my instvar popupMenu popupIndex name

        set popupMenu [ menu ${name} -tearoff 0 ]

        $popupMenu delete 0 end 
        set popupIndex 0

        my destroyChildren 
    }

    PopupMenu instproc addPopupMenu { name } {

        my instvar popupMenu popupIndex

        set menu [ menu $popupMenu.$popupIndex -tearoff 0 ]

        $popupMenu add cascade -label $name -menu $menu

        my incr popupIndex

        return $menu
    }
}


