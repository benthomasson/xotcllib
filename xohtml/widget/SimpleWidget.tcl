# Created at Tue Jul 22 09:54:41 EDT 2008 by bthomass

::xohtml::widgets {

    defineWidget SimpleWidget { { aTitle SimpleWidget } } {

        
    } {

        html {
            head {
               title ' $aTitle
            }
            body {
                my formatChildWidgets
            }
        }
    }
}


