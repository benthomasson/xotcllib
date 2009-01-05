# Created at Thu Oct 30 09:16:18 EDT 2008 by ben

namespace eval ::xoweb {

    ::xoweb::ApplicationClass create JSTest -superclass ::xoweb::Application

    JSTest @doc JSTest {

        Please describe the class JSTest here.
    }

    JSTest parameter {

    }

    JSTest instproc init { } {

        my set count 0

    }

    JSTest instproc initialLoad { } {

        my instvar url count

        my incr count

        return [ ::xoweb::makePage { } {
            html {
                head {
                    script -language "Javascript" -src "/files/prototype.js"
                    script -language "Javascript" -src "/files/xopro.js"
                }
                body {

                    h1 ' JSTest $count

                    div -id items {
                        ' Stuff
                    }


                    set donotrun {


                    javascript "

new Ajax.PeriodicalUpdater('items','${url}?method=ajax2', {
method: 'get',
insertion: Insertion.Top,
frequency: 1,
decay: 2
});

                    "
                    }

                    form -action "javascript:o=new Object();o.name='Ben';ajaxLoad('items','$url','ajax2',o);" {
                        input -type submit -value Go 
                    }

                    javascript {
                        alert('hi' + isNaN(parseInt("x")));
                    }
                }
            }
        } ]
    }

    JSTest instproc ajax2 { -name } {

        puts ajax2-called

        after 5000

        return [ ::xoweb::makePage { } { h1 ' "$name says 'Mwhahaha'" } ]
    }
}


