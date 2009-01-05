package provide xox::test::TestObject 1.0

package require XOTcl
package require xox
package require xounit

namespace eval ::xox::test {

    namespace import -force ::xotcl::*

    Class TestObject -superclass ::xounit::TestCase

    TestObject instproc testParameter {} {

        set o [ Object new ]

        $o parametercmd v

        my assertNotEquals [ lsearch [ $o info methods ] v ] -1 
        my assertEquals [ lsearch [ $o info vars ] v ] -1 

        $o v 5

        my assertNotEquals [ lsearch [ $o info vars ] v ] -1 
        my assertEquals [ $o v ] 5
    }

    TestObject instproc testDotNotParam {} {

        set o [ Object new ]

        catch {
            $o . v

            puts "Failed TestObject::testDotNotParam"
            exit 
        }
    }
 
    TestObject instproc testDotNoValue {} {

        set o [ Object new ]

        $o parametercmd v

        catch {
            $o . v

            puts "Failed TestObject::testDotNotParam"
            exit 
        }
    }
  
    TestObject instproc testDot {} {

        set o [ Object new ]

        $o parametercmd v

        $o v 5

        my assertEquals [ $o v ]  5
        my assertEquals [ $o . v ]  5
    }
  
    TestObject instproc testDotSecondLevel {} {

        set o [ Object new ]
        set c [ Object new ]

        $o parametercmd c
        $c parametercmd v

        $o c $c
        $c v 5

        my assertEquals [ [ $o c ] v ] 5
        my assertEquals [ $o . c . v ]  5
    }
  
    TestObject instproc testDotSubstitution {} {

        set o [ Object new ]
        set c [ Object new ]

        $o parametercmd c
        $c parametercmd v

        $o c $c
        $c v 5

        set x c
        set y v

        my assertEquals [ [ $o $x ] $y ] 5
        my assertEquals [ $o . $x . $y ]  5
    }
  
    TestObject instproc testDotExecute {} {

        set o [ Object new ]
        set c [ Object new ]

        $o parametercmd c
        $c parametercmd v

        $o c $c

        $c proc test { args } {

            return $args
        }

        my assertEquals [ [ $o c ] test 1 2 3 ] {1 2 3}
        my assertEquals [ $o . c . test 1 2 3 ] {1 2 3}
    }
  
    TestObject instproc testDotExecuteSecondLevel {} {

        set o [ Object new ]
        set t [ Object new ]
        set h [ Object new ]

        $o parametercmd c
        $t parametercmd c

        $o c $t
        $t c $h

        $h proc test { args } {

            return $args
        }

        my assertEquals [ [ [ $o c ] c ] test 1 2 3 ] {1 2 3}
        my assertEquals [ $o . c . c . test 1 2 3 ] {1 2 3}
    } 
 
      
    TestObject instproc testComment {} {

        set o [ Object new ]
        
        my assertEquals [ $o # p {a proc} ] "a proc" 
        my assertEquals [ $o get# p ] "a proc"

        $o # p {more}
        my assertEquals [ $o get# p ] "more"
    }

    TestObject instproc testComment2 {} {

        set o [ Object new ]

        $o # someProc Doc

        $o proc someProc {} {

        }

        my assertEquals [ $o get# someProc ]  "Doc"
    }

    TestObject instproc testIntrospectionWithComment {} {

        set o [ Object new ]

        $o # someProc someProc

        $o proc someProc {} {

        }

        $o # anotherProc anotherProc

        $o proc anotherProc {} {

        }

        my assertEquals [ lsort [ $o info procs ] ]  "anotherProc someProc"

        foreach proc [ $o info procs ] {

            my assertEquals [ $o get# $proc ] "$proc"
        }
    }

    TestObject instproc testLongComment {} {

        set o [ Object new ]

        $o # noProc {This is a really long comment}

        my assertEquals [ $o get# noProc ] "This is a really long comment"

    }

    TestObject instproc testClassComment {} {

        set o [ Class new ]

        $o # $o {NewClass Comment}

        my assertEquals [ $o get# $o ] "NewClass Comment"
    }

    TestObject instproc testHelp {} {

        set o [ Object new ]

        $o ?
        $o ? set
    }

    TestObject instproc testHelpMethods {} {
       
        set o [ Object new ]

        $o ?methods
    }

    TestObject instproc testSetParameterDefaults {} {

        Class ::xox::test::TestSPD

        ::xox::test::TestSPD parameter { 
            { x 1 } 
        }

        set o [ Object new ]

        $o class ::xox::test::TestSPD

        my assertFalse [ $o exists x ]

        $o setParameterDefaults

        my assert [ $o exists x ]
        my assertEquals [ $o x ] 1

        $o class Object

        $o setParameterDefaults
    }

    TestObject instproc testSetParameterDefaultsPrecedence {} {

        Class ::xox::test::TestSPDSuperClass 
        Class ::xox::test::TestSPD2 -superclass ::xox::test::TestSPDSuperClass

        ::xox::test::TestSPDSuperClass parameter { 
            { y 1 } 
            { x 2 } 
        }

        ::xox::test::TestSPD2 parameter { 
            { x 1 } 
        }

        set o [ Object new ]

        $o class ::xox::test::TestSPD2

        my assertFalse [ $o exists x ] 1

        $o setParameterDefaults

        my assert [ $o exists x ] 2
        my assertEquals [ $o x ] 1 3
        my assert [ $o exists y ] 4
        my assertEquals [ $o y ] 1 5

        $o class Object

        $o setParameterDefaults
    }

    TestObject instproc testGarbageCollect { } {

        set o [ ::xotcl::Object new ]

        my assertObject $o

        $o destroy

        my assertFailure {

            my assertObject $o
        }

        set o [ ::xotcl::Object new ]

        my assertObject $o

        $o garbageCollect

        my assertFailure {

            my assertObject $o
        }
    }

    TestObject instproc testGarbageCollectClass { } {

        ::xotcl::Class ::xox::test::GBTest

        my assertObject ::xox::test::GBTest

        ::xox::test::GBTest garbageCollect        

        my assertObject ::xox::test::GBTest
    }

    TestObject instproc testObjectEval { } {

        set o [ Object new ]

        $o proc do { } {

            my set a 5
        }

        $o do
        my assertEquals [ $o set a ] 5
        my assertEquals [ $o eval { set a } ] 5

        $o unset a

        $o eval do
        my assertEquals [ $o set a ] 5
        my assertEquals [ $o eval { set a } ] 5
    }

    TestObject instproc testObjectEval2 { } {

        Class ::xox::test::A

        ::xox::test::A instproc do { } {

            my set a 5
        }

        set o [ ::xox::test::A new ]

        $o eval "interp alias {} do {} $o do"

        $o do
        my assertEquals [ $o set a ] 5
        my assertEquals [ $o eval { set a } ] 5

        $o unset a

        $o eval { do }
        my assertEquals [ $o set a ] 5
        my assertEquals [ $o eval { set a } ] 5

        $o unset a

        interp alias {} do {}

        my assertError { do }

        my assertError { $o set a }
        my assertError { $o eval { set a } }
    }

    TestObject instproc testObjectEval3 { } {

        set o [ Object new ]

        $o proc do { } {

            my set a 5
        }

        $o do
        my assertEquals [ $o set a ] 5
        my assertEquals [ $o eval { set a } ] 5

        $o unset a

        $o eval { puts [ do ] }
        my assertEquals [ $o set a ] 5
        my assertEquals [ $o eval { set a } ] 5
    }


    TestObject instproc testObjectEval4 { } {

        set o [ Object new ]

        $o eval {

            set a 5
        }

        my assertEquals [ $o set a ] 5
        my assertEquals [ $o eval { set a } ] 5

        $o unset a

        $o eval {

            my set a 5
        }

        my assertEquals [ $o set a ] 5
        my assertEquals [ $o eval { set a } ] 5
    }

    TestObject instproc testObjectEval { } {

        set o [ Object new ]

        my assertError {

            $o eval {
                my set x 5
                puts $x
            }
        }

        my assertEquals [ $o set x ] 5

        my assertNoError {

            $o objectEval {
                my set a 5
                puts $a
            }
        }

        my assertEquals [ $o set a ] 5

        my assertNoError {

            $o objectEval {

                foreach x { 1 2 3 } {
                    my set y $x
                    puts $y
                }
            }
        }

        my assertEquals [ $o set y ] 3
    }
}

