# Created at Wed Jun 20 09:11:04 EDT 2007 by bthomass

package require xounit

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    Class TestEnvironment -superclass ::xounit::TestCase

    TestEnvironment instproc setUp { } {

        if { ! [ info exists ::env(TCLLIBPATH) ] } {

            set ::env(TCLLIBPATH) ""
        }
    }

    TestEnvironment instproc test { } {

        set TCLLIBPATH $::env(TCLLIBPATH)

        if { "" == "$TCLLIBPATH" } { return }

        my assertTCLLIBPATHinAutoPath

        lappend ::env(TCLLIBPATH) $::env(HOME)/XYZ
        lappend ::auto_path $::env(HOME)/XYZ

        my assertTCLLIBPATHinAutoPath
    }

    TestEnvironment instproc testAddTclLibPath { } {

        set environment [ ::xox::Environment new ]

        $environment addTclLibPath $::env(HOME)/XYZ123

        my assertFindIn $::env(HOME)/XYZ123 $::env(TCLLIBPATH)
        my assertFindIn $::env(HOME)/XYZ123 $::auto_path
    }

    TestEnvironment instproc assertTCLLIBPATHinAutoPath { } {

        #my debug $::env(TCLLIBPATH)

        #my debug $::auto_path

        foreach path $::env(TCLLIBPATH) {

            my assertFindIn $path $::auto_path
        }
    }

    TestEnvironment instproc testXml { } {

        set reader [ ::xox::XmlNodeReader new ]

        set environment [ ::xox::Environment new ]

        set xml \
"<env>
<tclLibPath>
A456
B789
C123
DXYZ
</tclLibPath>
<packages>
xox
xounit
xoexception
abc
</packages>
</env>"

        $reader buildNodes $environment $xml

        my assertListEquals [ $environment tclLibPath ] "A456 B789 C123 DXYZ"

        #$environment loadPaths

        foreach path [ $environment tclLibPath ] {

            my assertFindIn $path $::env(TCLLIBPATH)
            my assertFindIn $path $::auto_path
        }

        my assertTCLLIBPATHinAutoPath

        #$environment loadPackages

        package present xox
        package present xounit
        package present xoexception
        package present abc
    }
}

package provide xox::test::TestEnvironment 1.0

