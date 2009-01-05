# Created at Fri Nov 14 22:58:48 EST 2008 by ben

namespace eval ::xoweb {

    ::xoweb::ApplicationClass create TestRunner -superclass ::xoweb::AjaxApplication

    TestRunner @doc TestRunner {

        Please describe the class TestRunner here.
    }

    TestRunner parameter {
        testSelector

    }

    TestRunner instproc init { } {

        my testSelector [ my registerWidget [ ::xoweb::TestSelectorWidget new ] ]
    }

    TestRunner instproc initialLoad { } {

        my instvar url testSelector

        return [ ::xoweb::makePage { } {

            html {
                head {
                    script -language "Javascript" -src "/files/prototype.js"
                    script -language "Javascript" -src "/files/xopro.js"
                }
                new XowebCSS -width 80%
                body {
                    div -class object {
                        h1 -class name ' Test Runner

                        my useExternal $testSelector
                    }
                }
            }
        } ] 
    }

    TestRunner instproc Run_Package_Tests { { -package {} }  { -class {} } { -test {} } } {
 
        my instvar url testSelector

        return [ ::xoweb::makePage { } {

            html {
                head {
                    script -language "Javascript" -src "/files/prototype.js"
                    script -language "Javascript" -src "/files/xopro.js"
                }
                new XowebCSS -width 80%
                body {
                    div -class object {
                        h1 -class name ' Test Runner

                        my useExternal $testSelector

                        hr

                        if [ my isobject $package ] {

                            new RunTests -package [ string range $package 2 end ]

                        } else {

                            ' Please select a package and press Run_Package_Tests again.
                        }
                    }
                }
            }
        } ] 
    }

    TestRunner instproc Run_Class_Tests { { -package {} }  { -class {} } { -test {} } } {
 
        my instvar url testSelector

        return [ ::xoweb::makePage { } {

            html {
                head {
                    script -language "Javascript" -src "/files/prototype.js"
                    script -language "Javascript" -src "/files/xopro.js"
                }
                new XowebCSS -width 80%
                body {
                    div -class object {
                        h1 -class name ' Test Runner

                        my useExternal $testSelector

                        hr

                        if { [ my isobject $package ] && [ my isclass $class ] } {

                            new RunTest -package [ string range $package 2 end ] -testClass [ namespace tail $class ]

                        } else {

                            ' Please select a package and a class and press Run_Class_Tests again.
                        }
                    }
                }
            }
        } ] 
    }

    TestRunner instproc Run_Single_Test { { -package {} }  { -class {} } { -test {} } } {
 
        my instvar url testSelector

        return [ ::xoweb::makePage { } {

            html {
                head {
                    script -language "Javascript" -src "/files/prototype.js"
                    script -language "Javascript" -src "/files/xopro.js"
                }
                new XowebCSS -width 80%
                body {
                    div -class object {
                        h1 -class name ' Test Runner

                        my useExternal $testSelector

                        hr

                        if { [ my isobject $package ] && [ my isclass $class ] && "[ $class info instprocs $test ]" != "" } {

                            new RunATest -package [ string range $package 2 end ] -testClass [ namespace tail $class ] -testMethod $test

                        } else {

                            ' Please select a package, a class, and a test and press Run_Single_Test again.
                        }
                    }
                }
            }
        } ] 
    }
}
