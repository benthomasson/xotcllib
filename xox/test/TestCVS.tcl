
namespace eval ::xox::test { 

Class create TestCVS -superclass { ::xounit::TestCase }

TestCVS id {$Id: TestCVS.tcl,v 1.2 2008/02/03 14:32:24 bthomass Exp $}
  
TestCVS @doc TestCVS {
::xox::test::TestCVS tests ::xox::CVS
}
       
TestCVS parameter {

}

TestCVS instproc setUp { } {

    package require abc
    my assertObject ::abc
}

TestCVS instproc testPackageMixin { } {

    my assertFindIn Package.tcl [ ::xox getFiles ]
    my assertFindIn CVS.tcl [ ::xox getFiles ]

    my assertClass ::xox::CVS

    my assertEquals [ ::xox::Package info instmixin ] "::xox::MetaData ::xox::CVS"
}

TestCVS instproc testAdd { } {

#    ::abc add ABCD.tcl
}

TestCVS instproc testUpdate { } {

#    ::abc update ABCD.tcl
}

TestCVS instproc testCommit { } {

   # ::abc commit -files ABCD.tcl "adding ABCD"
}

}


