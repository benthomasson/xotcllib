# Created at Fri Jun 01 08:18:21 EDT 2007 by bthomass

package require xotcl

namespace eval ::xounit {

    namespace import -force ::xotcl::*

    Class XounitTemplates -superclass ::xotcl::Object

    XounitTemplates # XounitTemplates {

        XounitTemplates is a set of templates used
        to create source code for projects that use
        xounit.
    }

    XounitTemplates # makeSuite {

        makeSuite creates a suite.xml file that 
        contains all the tests found in the test
        subpackage of a package named by the 
        current working directory.
    }

    XounitTemplates proc makeSuite { {suiteClass ::xounit::TestSuiteContinuous} } {

        set name suite

        set package [ file tail [ pwd ] ]

        if [ catch {

            package require $package
            package require ${package}::test

        } ] {

            puts "Cannot load package $package"
            puts "Please create package $package with: makePackage $package"
            exit
        }

        set tests [ glob -nocomplain [ file join [ pwd ] test *.tcl ] ]
        
        #my debug $tests

        set tests [ ::xox::mapcar { file tail $x } x $tests ]

        #my debug $tests
        set tests [ ::xox::removeIf { expr { "${package}.tcl" == "$x" } } \
            x $tests ]
        #my debug $tests
        set tests [ ::xox::mapcar { string range $x 0 end-4 } x $tests ]
        #my debug $tests

        set tests [ ::xox::mapcar { subst "::${package}::test::${test}" } test $tests ]

        #my debug $tests

        set tests [ ::xox::removeIfNot { ::xotcl::Object isclass $test } test $tests ]
        set tests [ ::xox::removeIfNot { ::xox::ObjectGraph hasSuperclass $test ::xounit::TestCase } test $tests ]

        #my debug $tests
        set testSuite [ $suiteClass new ]

        $testSuite name "$package Unit Tests"
        $testSuite location "/var/www/html/$package/"
        $testSuite webPath "http://$::env(HOST)/$package/"
        $testSuite title "$package Continuous Testing"
        $testSuite url "http://xotcllib.sourceforge.net"
        $testSuite packages $package

        if [ file exists ${name}.xml ] {

            [ ::xox::XmlNodeReader new ] buildTree $testSuite ${name}.xml
        }

        foreach child [ $testSuite nodes ] {

            $child destroy
        }

        foreach test $tests {

            $testSuite createAutoNamedChild $test
        }

        puts "Writing ${name}.xml"

        [ ::xox::SimpleXmlNodeWriter new ] writeXmlFile $testSuite "${name}.xml"

    }

    XounitTemplates # makeMultipleSuite {

        Creates a suite.xml file for multiple packages.
    }

    XounitTemplates proc makeMultipleSuite { suiteName args } {

        set packages $args

        set suiteTests ""

        foreach package $packages {

            if [ catch {

                package require $package
                package require ${package}::test

            } ] {

                puts "Cannot load package $package"
                puts "Please create package $package with: makePackage $package"
                exit
            }

            set tests [ glob -nocomplain [ file join [ "::$package" packagePath ] test *.tcl ] ]
            
            #my debug $tests

            set tests [ ::xox::mapcar { file tail $x } x $tests ]

            my debug $tests
            set tests [ ::xox::removeIf { expr { "${package}.tcl" == "$x" } } \
                x $tests ]
            my debug $tests
            set tests [ ::xox::mapcar { string range $x 0 end-4 } x $tests ]
            #my debug $tests

            set tests [ ::xox::mapcar { subst "::${package}::test::${test}" } test $tests ]

            #my debug $tests

            set tests [ ::xox::removeIfNot { ::xotcl::Object isclass $test } test $tests ]
            set tests [ ::xox::removeIfNot { ::xox::ObjectGraph hasSuperclass $test ::xounit::TestCase } test $tests ]

            #my debug $tests

            set suiteTests [ concat $suiteTests $tests ]
        }

        set testSuite [ ::xounit::TestSuiteContinuous new ]

        $testSuite name "$suiteName Unit Tests"
        $testSuite location "/var/www/html/$suiteName/"
        $testSuite webPath "http://$::env(HOST)/$suiteName/"
        $testSuite title "$suiteName Continuous Testing"
        $testSuite url "http://xotcllib.sourceforge.net"
        $testSuite packages "$packages"

        if [ file exists ${suiteName}.xml ] {

        [ ::xox::XmlNodeReader new ] buildTree $testSuite ${suiteName}.xml

        }
        
        foreach child [ $testSuite nodes ] {

            $child destroy
        }

        foreach test $suiteTests {

            $testSuite createAutoNamedChild $test
        }

        [ ::xox::SimpleXmlNodeWriter new ] writeXmlFile $testSuite "${suiteName}.xml"
    }
}


