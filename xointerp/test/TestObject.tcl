# Created at Sat Jan 05 00:10:09 EST 2008 by bthomass

namespace eval ::xointerp::test {

    Class TestObject 

    TestObject # TestObject {

        Please describe the class TestObject here.
    }

    TestObject instmixin ::xointerp::Interpretable

    TestObject parameter {

    }

    TestObject instproc <do> { } {
        my set a 5
    }

    TestObject instproc <do2> { } {
        my set a 2
    }

    TestObject instproc <do3> { arg } {

        return [ expr { $arg + 1 } ]
    }

    TestObject instproc xyz { a b c } {

        return [ expr { $a + $b + $c } ]
    }

    TestObject instproc around:xyz { interp commandName a b c  } {

        return [ $interp evalNewCommand $commandName "$commandName $a $b $c" ]
    }
}


