# Created at Wed Oct 22 01:39:24 EDT 2008 by ben

namespace eval ::xodsl::test {

    Class TestObject -superclass ::xounit::TestCase

    TestObject parameter {

    }

    TestObject instproc setUp { } {

        #add set up code here
        catch { unset ::a }
    }

    TestObject instproc testSetNormal { } {

        set o [ Object new ]
        $o set a 5
        my assertEquals [ $o set a ] 5
    }

    TestObject instproc testSetEval { } {

        set o [ Object new ]
        $o eval {
            set a 5
        }
        my assertEquals [ $o set a ] 5
    }

    TestObject instproc testSetEval { } {

        set o [ Object new ]
        $o eval {
            set a 5
        }
        my assertEquals [ $o set a ] 5
    }

    TestObject instproc testGlobalSetEval { } {

        catch { unset ::a }

        set o [ Object new ]
        $o eval {
            set ::a 5
        }
        my assertEquals [ set ::a ] 5

        catch { unset ::a }
    }

    TestObject instproc testGlobalGet { } {

        catch { unset ::a }

        set ::a 5

        set o [ Object new ]
        my assertError {
            $o eval {
                puts $a
            }
        }
        my assertEquals [ set ::a ] 5

        catch { unset ::a }
    }

    TestObject instproc testGlobalGet2 { } {

        catch { unset ::a }

        set ::a 5

        set o [ Object new ]
        my assertNoError {
            $o eval {
                puts $::a
            }
        }
        my assertEquals [ set ::a ] 5

        catch { unset ::a }
    }

    TestObject instproc testGlobalConfusion { } {

        catch { unset ::a }

        set ::a 6

        set o [ Object new ]
        my assertNoError {
            $o eval {
                set a 5
            }
        }
        my assertEquals [ $o set a ] 5
        my assertEquals [ set ::a ] 6

        catch { unset ::a }
    }

    TestObject instproc testNamespace { } {

        catch { unset ::a }

        set ::a 5

        set o [ Object new ]
        my assertNoError {
            $o eval {
                set a [ namespace current ]
            }
        }
        my assertEquals [ $o set a ] ::xotcl::fakeNS

        catch { unset ::a }
    }

    TestObject instproc testNamespaceConfusion { } {

        catch { unset ::a }

        set ::a 4

        set o [ Object new ]
        set p [ Object new ]
        my assertNoError {
            $o eval {
                set a 5
            }
            $p eval {
                set a 6
            }
        }
        my assertEquals [ $o set a ] 5
        my assertEquals [ $p set a ] 6
        my assertEquals [ set ::a ] 4

        catch { unset ::a }
    }

    TestObject instproc testForward { } {

        set o [ Object new ]
        set p [ Object new ]

        $o forward set $p set

        $o eval {
            set a 5
        }

        my assertFalse [ $o exists a ] o
        my assertTrue [ $p exists a ] p
        my assertEquals [ $p set a ] 5
    }

    TestObject instproc testEvalFailureClassMethod { } {

        set p [ ::xox::Node new ]

        my assertError {

            $p eval {
                nodeName XYZ
            }
        }

        my assertFalse [ $p exists nodeName ] p
    }

    TestObject instproc testForwardClassMethod { } {

        set o [ Object new ]
        set p [ ::xox::Node new ]

        $o forward nodeName $p nodeName

        $o eval {
            nodeName XYZ
        }

        my assertFalse [ $o exists nodeName ] o
        my assertTrue [ $p exists nodeName ] p
        my assertEquals [ $p set nodeName ] XYZ
    }

    TestObject instproc notestGlobalWeirdness { } {

        my fail "Global calls do not work in xodsl\nThis test case causes failures in other test cases."

        catch { unset ::a }

        set ::a 33

        set o [ Object new ]
        set p [ Object new ]
        set q [ Object new ]

        $o eval {
            global a
            set a 5
        }

        my assertEquals [ set ::a ] 5

        $p eval {
            set a 99
        }

        my assertEquals [ $p set a ] 99

        $p eval {
            append a 100
        }

        my assertEquals [ $p set a ] 99100

        $q eval {
            append a 101
        }

        my assertEquals [ $q set a ] 101

        #catch { unset ::a }
        #namespace eval ::xotcl::fakeNS {
        #    unset a
        #}
        #uplevel #0 { unset a }
    }

    TestObject instproc tearDown { } {

        #add tear down code here
    }
}


