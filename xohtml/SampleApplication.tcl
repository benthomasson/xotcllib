# Created at Thu Oct 23 11:46:03 EDT 2008 by ben

namespace eval ::xohtml {

    ::xohtml::ApplicationClass create SampleApplication -superclass ::xohtml::Application

    SampleApplication @doc SampleApplication {

        Please describe the class SampleApplication here.
    }

    SampleApplication parameter {

    }

    SampleApplication instproc initialLoad { args } {

        return [ ::xohtml::formatPageWithScopeVariables {
            content {
                ' Hi $args
            }
        } ]
    }
}


