# Created at Mon Feb 04 10:22:54 AM EST 2008 by bthomass

namespace eval ::simpletest {

    ::simpletest loadClass ::simpletest::SimpleTestCaseClass

    ::xodsl::LanguageClass create SimpleTestCase -superclass { ::xodsl::Language ::xounit::TestCase }

    SimpleTestCase # SimpleTestCase {

        Please describe the class SimpleTestCase here.
    }

    SimpleTestCase parameter {
        name
        script
    }

    SimpleTestCase instproc test { } {

        my instvar environment script
        $environment eval $script
    }
}


