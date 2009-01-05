# Created at Tue May 06 10:45:29 AM EDT 2008 by bthomass

namespace eval ::xox::test {

    Class TestMetaData -superclass ::xounit::TestCase

    TestMetaData parameter {

    }

    TestMetaData instproc setUp { } {

        #add set up code here
    }

    TestMetaData @tag testTag ABC
    TestMetaData @tag testTag DEF

    TestMetaData instproc testTag { } {

        my assertEquals [ ::xox::test::TestMetaData set @tagged(ABC) ] testTag
        my assertEquals [ ::xox::test::TestMetaData set @tagged(DEF) ] testTag
        my assertEquals [ ::xox::test::TestMetaData set @tag(testTag) ] {ABC DEF}
    }

    TestMetaData instproc tearDown { } {

        #add tear down code here
    }
}


