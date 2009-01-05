# Created at Wed Mar 01 01:50:35 PM EST 2006 by bthomass

package require xounit

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    Class TestPackage -superclass ::xounit::TestCase

    TestPackage parameter {

    }

    TestPackage instproc setUp { } {

        #add set up code here
    }

    TestPackage instproc notestExport {} {

         ::xox::Package ::testexportpackage

         ::testexportpackage proc return5 { } { return 5 }

         my assertError { return5 }
         
         my assertNotEquals [info procs return5] return5

         ::testexportpackage export [namespace current]

         my assertEquals [info procs return5] return5

         my assertEquals [ return5 ] 5
    }

    TestPackage instproc notestImport {} {

         ::xox::Package ::testimportpackage

         ::testimportpackage proc return6 { } { return 6 }

         my assertError { return6 }
         
         my assertNotEquals [info procs return6] return6

         ::testimportpackage import

         my assertEquals [info procs return6] return6

         my assertEquals [ return6 ] 6
    }

    TestPackage instproc notestMakeClass { } {

        ::xox::Package makeClass xyz XYZ
        my assert [ file exists XYZ.tcl ]
        source XYZ.tcl
        my assert [ Object isclass ::xyz::XYZ ]
        my assert [ ::xyz::XYZ exists #(XYZ) ]
    }

    TestPackage instproc notestMakeTest { } {

        ::xox::Package makeTest xyz XYZ
        my assert [ file exists TestXYZ.tcl ]
        source TestXYZ.tcl
        my assert [ Object isclass ::xyz::test::TestXYZ ]
    }

    TestPackage instproc notestMakePackage { } {

        ::xox::Package makePackage xyz
        my assert [ file exists xyz ]
        my assert [ file exists xyz/xyz.tcl ]
        my assert [ file exists xyz/test ]
        my assert [ file exists xyz/test/xyz.tcl ]
        my assert [ file exists xyz/pkgIndex.tcl ]

        source xyz/xyz.tcl
        source xyz/test/xyz.tcl

        package require xyz
    }

    TestPackage instproc tearDown { } {

        catch { file delete XYZ.tcl }
        catch { file delete TestXYZ.tcl }
        catch { file delete -force xyz }
    }

    TestPackage instproc testPackageName { } {

        my assertEquals [ ::xox packageName ] xox
    }

    TestPackage instproc testForgetAll { } {

        my assertPackageLoaded xox

        package require abc

        my assertPackageLoaded abc

        package forget abc

        my assertPackageUnknown abc

        my assertFailure {

            my assertPackageLoaded abc
        }

        my assertError { package require notapackage }

        my assertFailure {

            my assertPackageUnknown abc
        }

        package require abc

        my assertPackageLoaded abc

        ::abc forgetAll

        my assertFailure {

            my assertPackageLoaded abc
        }

        my assertPackageUnknown abc
    }

    TestPackage instproc testReloadABC { } {

        package require abc

        my assertPackageLoaded abc

        ::abc reload

        my assertPackageLoaded abc
    }

    TestPackage instproc notestReloadServer { } {

        package require server

        ::server forgetAll

        my assertPackageUnknown server

        ::server findPackages

        my assertFailure { my assertPackageUnknown server }
        my assertFailure { my assertPackageLoaded server }

        ::server loadAll

        ::server reload

        my assertPackageLoaded server::UserInterface
        my assertObject ::server::UserInterface
    }

    TestPackage instproc testIsPackage { } {

        my assert [ ::xox::Package isPackage xox ]
        my assert [ ::xox::Package isPackage xox::test::TestPackage ]
    }

    TestPackage instproc assertPackageLoaded { package } {

        my assertNoError { package present $package } "Package $package is not loaded"
    }

    TestPackage instproc assertPackageUnknown { package } {

        set subs [ ::xox::removeIfNot { 
            string match "${package}" $name 
            } name [ package names ] ]

        my assertEquals $subs "" "Package $package is not unknown"
    }

    TestPackage instproc testNamespaceVariables { } {

        my assertSetEquals [ ::abc namespaceVariables ] \
            "nsA nsB nsC nsD nsE"
    }

    TestPackage instproc testVersion { } {

        my assertEquals [ [ ::xox::Package new ] version ] 1.0

        set package [ ::xox::Package new -id "\$X Y 1.1 Z A\$" ]
        my assertEquals [ $package version ] 1.1
    }
    
    TestPackage instproc testGetID { } {

        my assertEquals [ [ ::xox::Package new ] getID ] "Id:"

        set package [ ::xox::Package new -id "\$X Y 1.1 Z A\$" ]
        my assertEquals [ $package version ] 1.1
        my assertEquals [ $package getID ] "X Y 1.1 Z A"
    }

    TestPackage instproc testDependencies { } {

        set package [ ::xox::Package new -requires xounit ]
        $package requireDependencies 
        $package checkDependencies 

        my assertNoError {
            $package assertDependencies 
        }
    }

    TestPackage instproc testFailedDependencies { } {

        set package [ ::xox::Package new -requires notAPackage ]
        $package requireDependencies 
        my assertEquals [ $package failedDependencies ] notAPackage 
        $package checkDependencies 

        my assertError {
            $package assertDependencies 
        }
    }

    TestPackage instproc testGetClassFile { } {

        my assertEquals [ ::xox::Package getClassFile ::xox::Package ] Package.tcl
        my assertEquals [ ::xox::Package getClassFile ::xox::test::TestPackage ] test/TestPackage.tcl
        my assertEquals [ ::xox::Package getClassFile ::xox::test::TestPackage::XYZ ] test/TestPackage::XYZ.tcl
    }
}

package provide xox::test::TestPackage 1.0

