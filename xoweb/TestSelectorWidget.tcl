# Created at Fri Nov 14 23:59:25 EST 2008 by ben

namespace eval ::xoweb {

    Class TestSelectorWidget -superclass ::xoweb::AjaxWidget

    TestSelectorWidget @doc TestSelectorWidget {

        Please describe the class TestSelectorWidget here.
    }

    TestSelectorWidget parameter {

    }

    TestSelectorWidget instproc initialLoad { } {

        my instvar url id

        return [ ::xoweb::makePage { } {

            form -action $url -method POST {

                select -name package -id package -onChange "o=new Object();o.package=this.options\[this.selectedIndex\].value;ajaxWidgetCall('class','$url','$id','getPackageClassOptions',o);" {
                    option ' Select Package
                    foreach package [ ::xox::Package info instances ] {
                        option ' $package
                    }
                }
                select -name class -id class -onChange "o=new Object();o.class=this.options\[this.selectedIndex\].value;ajaxWidgetCall('test','$url','$id','getClassTestOptions',o);" {
                    option ' Select Class
                }
                select -name test -id test {
                    option ' Select Test

                }
                input -name "method" -value Run_Package_Tests -type submit
                input -name "method" -value Run_Class_Tests -type submit
                input -name "method" -value Run_Single_Test -type submit
            }
        } ]
    }

    TestSelectorWidget instproc getPackageClassOptions { -package } {

        if { ! [ my isobject $package ] } { 
            return [ ::xoweb::makePage { } { option ' Select Class } ]
        }

        return [ ::xoweb::makePage { } { 

            option ' Select Class
            foreach class [ ::xox::ObjectGraph findAllInstances ::xotcl::Class ${package}::test ] {
                option ' $class
            }
        } ]
    }

    TestSelectorWidget instproc getClassTestOptions { -class } {

        if { ! [ my isclass $class ] } { 

            return [ ::xoweb::makePage { } { option ' Select Test } ]
        }

        return [ ::xoweb::makePage { } { 

            option ' Select Test
            foreach test [ $class info instprocs test* ] {
                option ' $test
            }
        } ]
    }
}


