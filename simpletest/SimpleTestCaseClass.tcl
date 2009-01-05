# Created at Mon Feb 04 10:22:54 AM EST 2008 by bthomass

namespace eval ::simpletest {

    Class SimpleTestCaseClass -superclass ::xodsl::LanguageClass

    SimpleTestCaseClass # SimpleTestCaseClass {

        Please describe the class SimpleTestCaseClass here.
    }

    SimpleTestCaseClass parameter {
        name
        script
    }

    SimpleTestCaseClass instproc init { } {

        my instvar name script

        my superclass ::simpletest::SimpleTestCase

        my instproc init {  } [ subst {
            next
            my set environment \[ Object new \]
            [ self ] updateEnvironment \[ self \]
            my set name {$name}
            my set script {$script}
        } ]
    }
}


