# Created at Tue Jul 03 08:05:46 -0400 2007 by ben

package require xounit

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    Class TestTemplate -superclass ::xounit::TestCase

    TestTemplate instproc setUp { } {

        my instvar template

        set template [ ::xox::Template new ]

        catch {package require abc}

        set abcPath [ file join [ file dirname [ ::xox packagePath ] ] abc ]

        $template createPackage ::abc $abcPath

        ::abc imports {
            ::xoexception::*
        }

        namespace eval ::abc {

            variable nsA 5
            variable nsB ""

            set nsC 7
            set nsD "value with spaces"

            set nsE(a) 1
            set nsE(b) 2

            ::abc @doc nsProc {
                nsProc does ...
                arg -
            }

            proc nsProc { arg } {
                puts "doing something"
            }
        }

        catch { ::abc::ABCD destroy }

        Class create ::abc::ABCD -superclass ::xox::Node
        
        ::abc::ABCD @doc ABCD {
            Please describe ABCD here.
        }
    
        ::abc::ABCD instmixin add ::xox::Logging

        ::abc::ABCD parameter {
            {a 5}
            b
            {c "d"}
        }

        ::abc::ABCD parametercmd yada
    
        ::abc::ABCD instproc otherMethod { { arg default } { other "" } } {
#body
        }

        ::abc::ABCD instproc someMethod { someArg } {
            variable nsA 

            return $nsA
        }

        ::abc::ABCD instproc nonPosMethod { -abc { -def xyz } } {} {
#yada
        }

        ::abc::ABCD proc classProc { { something default } } {
set a 5
        }

        catch { ::abc::Doer destroy }

        Object create ::abc::Doer

        ::abc::Doer parametercmd a

        ::abc::Doer set a 5
        ::abc::Doer set anArray(a) 5
        ::abc::Doer set anArray(b) 6
        ::abc::Doer set anArray(c) 7
        ::abc::Doer set anArray(d) "value with spaces"
    }

    TestTemplate instproc testGeneateObjectFileCode { } {

        my instvar template
        my assertEqualsByLine \
            [ $template generateFileCode ::abc::Doer ] \
{
    namespace eval ::abc {

        Object create Doer

        Doer @doc Doer {
            Please describe Doer here.
        }
        
        Doer parametercmd a

        Doer set a 5
        Doer set anArray(a) 5
        Doer set anArray(b) 6
        Doer set anArray(c) 7
        Doer set anArray(d) {value with spaces}
    }
}
    }

    TestTemplate instproc testGenerateClassFileCode { } {

        my instvar template

        set cvsId "Id:"

        my assertEqualsByLine \
            [ $template generateFileCode ::abc::ABCD ] \
"
namespace eval ::abc {
    Class create ABCD -superclass { ::xox::Node }

    ABCD id {\$$cvsId \$}

    ABCD @doc ABCD {
        Please describe ABCD here.
    }

    ABCD instmixin add ::xox::Logging

    ABCD @doc a { }
    ABCD @doc b { }
    ABCD @doc c { }

    ABCD parameter {
        {a 5}
        {b}
        {c \"d\"}
    }

    ABCD parametercmd yada

    ABCD @doc classProc { 
    classProc does ...
        something - 
    }

    ABCD proc classProc { { something \"default\" } } {
        set a 5
    }

    ABCD @doc nonPosMethod { 
    nonPosMethod does ...
    }

    ABCD instproc nonPosMethod { -abc {-def xyz} } {  } {
#yada
    }

    ABCD @doc otherMethod {
        otherMethod does ...
        arg - 
        other -
    }

    ABCD instproc otherMethod { { arg \"default\" } { other \"\" } } {
#body
    }

    ABCD @doc someMethod {
        someMethod does ...
        someArg -
    }

    ABCD instproc someMethod { someArg } {
        variable nsA
        return \$nsA
    }
}
"
    }

    TestTemplate instproc testClassCreate { } {

        my instvar template

        set cvsId "Id:"

        my assertEqualsByLine \
            [ $template generateClassCreate ::abc::ABCD ] \
"Class create ABCD -superclass { ::xox::Node }
ABCD id {\$$cvsId \$}

"
    }
    
    TestTemplate instproc testClassParameter { } {

        my instvar template

        my assertEqualsByLine \
            [ $template generateClassParameter ::abc::ABCD ] \
{ABCD parameter {
        {a 5}
        {b}
        {c "d"}
    }}
    }

    TestTemplate instproc testMethods { } {
        
        my instvar template

        my assertEqualsByLine \
            [ $template generateMethod ::abc::ABCD someMethod instproc ] \
{ABCD @doc someMethod {
    someMethod does ...
    someArg -
    }
    ABCD instproc someMethod { someArg } {
        variable nsA
        return $nsA
    }}
    }

    TestTemplate instproc testMethodDefaultArg { } {
        
        my instvar template

        my assertEqualsByLine \
            [ $template generateMethod ::abc::ABCD otherMethod instproc ] \
{   ABCD @doc otherMethod { 
    otherMethod does ...
    arg - 
    other -
    }
    ABCD instproc otherMethod { { arg "default" } { other "" } } {
        #body
    }}
    }


    TestTemplate instproc testMethodNonPosArgDefault { } {
        
        my instvar template

        my assertEqualsTrim [ ::abc::ABCD info instnonposargs nonPosMethod ] "-abc {-def xyz}"

        my assertEqualsByLine \
            [ $template generateMethod ::abc::ABCD nonPosMethod instproc ] \
{   ABCD @doc nonPosMethod { 
    nonPosMethod does ...
    }
    ABCD instproc nonPosMethod { -abc {-def xyz} } {  } {
#yada
    }}
    }

    TestTemplate instproc testGeneratePackageFile { } {

        my instvar template

        my assert [ ::abc array exists nsE ] "nsE is not an array"

        my assertSetEquals [ ::abc info vars ] "# requires packageFile executables packagePath nsA nsB nsC nsD nsE id loadFirst versions imports exports "

        my assertSetEquals [ info vars ::abc::* ] "::abc::# ::abc::requires ::abc::packageFile ::abc::executables ::abc::packagePath ::abc::nsA ::abc::nsB ::abc::nsC ::abc::nsD ::abc::nsE ::abc::id ::abc::loadFirst ::abc::versions ::abc::imports ::abc::exports "

        my assertSetEquals [ ::abc namespaceVariables ] "nsA nsB nsC nsD nsE"

        my assertEquals $::abc::nsA 5
        my assertEquals [ ::abc set nsA ] 5

        #my assertEquals [ info procs ::abc::* ] "::abc::nsProc"
        my assertEquals [ ::abc info procs ] nsProc

        set cvsId "Id:"

        return

        my assertEqualsByLine [ $template generatePackageFile ::abc ] \
"
package require xox
::xox::Package create ::abc
::abc id {\$$cvsId $}
::abc @doc abc {
Please describe abc here.
}
::abc @doc UsersGuide {

}
::abc requires {
}
::abc imports {
    ::xoexception::*
}
::abc loadFirst {
}
::abc executables {
}
namespace eval ::abc {
variable nsA 5
variable nsB {}
variable nsC 7
variable nsD {value with spaces}
variable nsE
set nsE(a) 1
set nsE(b) 2
}
::abc @doc nsProc {
    nsProc does ...
    arg -
}
proc ::abc::nsProc { arg } {
    puts \"doing something\"
}
::abc loadAll
"

    }

    TestTemplate instproc testInstMixins { } {

        my instvar template

    }

    TestTemplate instproc testWriteFiles { } {

        my instvar template

        $template writeFile ::abc::ABCD
        $template writePackageFile ::abc
        $template buildPackage ::abc
        $template writeNewFile ::abc::ABCD
        $template buildClass ::abc::ABCD
        $template writeFile ::abc::test::TestABCD
        $template writeNewFile ::abc::Doer
    }

    TestTemplate instproc testBuildTests { } {

        my instvar template

        $template buildTests ::abc
    }

    TestTemplate instproc testNamespaceVariables { } {

        my assertEquals [ [ ::abc::ABCD new ] someMethod XYZ ] 5
    }

    TestTemplate instproc tearDown { } {

        set pwd [ pwd ]
        cd [ ::abc packagePath ]

        set old [ glob -nocomplain *.old ]
        set old [ concat $old [ glob -nocomplain test/*.old ] ]

        if { "" != "$old" } {

            eval file delete $old
        }

        cd $pwd
    }
}

package provide xox::test::TestTemplate 1.0

